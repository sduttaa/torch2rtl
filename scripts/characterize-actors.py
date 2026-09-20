#!/usr/bin/env python3
"""Synthesize explicitly selected actor configurations, without graph FIFOs."""

import argparse
from collections import Counter
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import re
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from torch2rtl.frontend import load
from torch2rtl.graph import actors, read
from torch2rtl.network import actor_rtl
from torch2rtl.flow import synthesize
from torch2rtl.ranges import bounds, storage_bits

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--configuration", type=Path, required=True)
parser.add_argument("--target", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--workers", type=int, default=1)
parser.add_argument("--options", type=Path, help="Explicit actor-to-option mapping to measure instead of one configuration")
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
graph = actors(read(module), config.get("fusions", ()))
args.output.mkdir(parents=True, exist_ok=True)


def measure(job):
    value, label, spec = job
    directory = args.output / value.name
    if label is not None:
        directory /= label
    record = {"name": value.name, "operation": value.operation, "output_shape": value.tensor.shape,
              "lanes": config["lanes"], "option": label, "output_lanes": spec.get("output_lanes"),
              "memories": spec.get("memories", {}), "reduction_lanes": spec.get("reduction_lanes")}
    rtl = actor_rtl(value, config["lanes"], record["output_lanes"], record["memories"], record["reduction_lanes"])
    record.update(rtl_sha256=hashlib.sha256(rtl.encode()).hexdigest(),
                  output_range=bounds(value), output_storage_bits=storage_bits(value))
    try:
        record["resources"] = synthesize(rtl, directory, target)
    except Exception as error:
        record["error"] = str(error)
    (directory / "report.json").write_text(json.dumps(record, indent=2) + "\n")
    print(json.dumps(record), flush=True)
    return record


values = {value.name: value for value in graph.values if value is not graph.input}
if args.options:
    options = json.loads(args.options.read_text())
    if not options or not options.keys() <= values.keys():
        raise ValueError("Options must refer to existing actors")
    if any(not variants or any(not re.fullmatch(r"[A-Za-z0-9_-]+", label) for label in variants)
           for variants in options.values()):
        raise ValueError("Use nonempty options with simple alphanumeric option names")
    jobs = [(values[name], label, spec) for name, variants in options.items() for label, spec in variants.items()]
else:
    jobs = [(value, None, {"output_lanes": config["output_lanes"].get(name),
              "reduction_lanes": config.get("reduction_lanes", {}).get(name),
              "memories": config.get("memories", {}).get(name, {})}) for name, value in values.items()]
with ThreadPoolExecutor(max_workers=args.workers) as executor:
    records = list(executor.map(measure, jobs))
totals = Counter()
for record in records:
    totals.update(record.get("resources", {}))
report = {"model_sha256": model_hash, "options" if args.options else "actors": records,
          "fusions": config.get("fusions", []),
          "all_succeeded": all("error" not in record for record in records),
          "whole_design_routed": False}
if not args.options:
    report["totals_without_graph_fifos"] = dict(totals)
(args.output / "report.json").write_text(json.dumps(report, indent=2) + "\n")
if not report["all_succeeded"]:
    raise SystemExit("Some actor measurements failed; inspect report.json and synthesis logs")
