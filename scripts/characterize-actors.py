#!/usr/bin/env python3
"""Synthesize explicitly selected actor configurations, without graph FIFOs."""

import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from torch2rtl.frontend import load
from torch2rtl.graph import actors, read
from torch2rtl.network import actor_rtl
from torch2rtl.flow import synthesize

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--configuration", type=Path, required=True)
parser.add_argument("--target", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--workers", type=int, default=1)
args = parser.parse_args()
if args.workers < 1:
    parser.error("--workers must be positive")
config = json.loads(args.configuration.read_text())
target = json.loads(args.target.read_text())
model_path = Path(config["model"])
model_hash = hashlib.sha256(model_path.read_bytes()).hexdigest()
if "model_sha256" in config and config["model_sha256"] != model_hash:
    raise ValueError("Configuration refers to different model contents")
_, module = load(model_path)
graph = actors(read(module))
args.output.mkdir(parents=True, exist_ok=True)


def measure(value):
    directory = args.output / value.name
    record = {"name": value.name, "operation": value.operation, "output_shape": value.tensor.shape,
              "lanes": config["lanes"], "output_lanes": config["output_lanes"].get(value.name),
              "memories": config.get("memories", {}).get(value.name, {}),
              "reduction_lanes": config.get("reduction_lanes", {}).get(value.name)}
    rtl = actor_rtl(value, config["lanes"], record["output_lanes"], record["memories"], record["reduction_lanes"])
    try:
        record["resources"] = synthesize(rtl, directory, target)
    except Exception as error:
        record["error"] = str(error)
    (directory / "report.json").write_text(json.dumps(record, indent=2) + "\n")
    print(json.dumps(record), flush=True)
    return record


with ThreadPoolExecutor(max_workers=args.workers) as executor:
    records = list(executor.map(measure, (value for value in graph.values if value is not graph.input)))
totals = Counter()
for record in records:
    totals.update(record.get("resources", {}))
report = {"model_sha256": model_hash, "actors": records, "totals_without_graph_fifos": dict(totals),
          "all_succeeded": all("error" not in record for record in records),
          "whole_design_routed": False}
(args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
if not report["all_succeeded"]:
    raise SystemExit("Some actor measurements failed; inspect report.json and synthesis logs")
