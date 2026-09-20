#!/usr/bin/env python3
"""Measure the compiler's registered FIFO options for an explicit target."""

import argparse
from concurrent.futures import ThreadPoolExecutor
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from torch2rtl.flow import synthesize
from torch2rtl.spatial import wrapped

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--bits", type=int, required=True)
parser.add_argument("--depths", type=int, nargs="+", required=True)
parser.add_argument("--target", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--workers", type=int, default=1)
parser.add_argument("--memory", choices=("auto", "block", "distributed"), default="auto")
args = parser.parse_args()
if min(args.bits, args.workers, *args.depths) < 1 or len(set(args.depths)) != len(args.depths):
    parser.error("Supply positive width, workers and distinct positive depths")
target = json.loads(args.target.read_text())
args.output.mkdir(parents=True, exist_ok=True)


def measure(depth):
    directory = args.output / str(depth)
    parameters = {"WIDTH": args.bits, "DEPTH": depth}
    if args.memory != "auto":
        parameters["MEMORY_STYLE"] = f'"{args.memory}"'
    rtl = wrapped("stream_fifo", parameters, args.bits, ("fifo.sv",))
    record = {"bits": args.bits, "depth": depth, "forward_delay": 1 if depth == 1 else 2,
              "memory": args.memory, "rtl_sha256": hashlib.sha256(rtl.encode()).hexdigest()}
    try:
        record["resources"] = synthesize(rtl, directory, target)
    except Exception as error:
        record["error"] = str(error)
    (directory / "report.json").write_text(json.dumps(record, indent=2)+"\n")
    print(json.dumps(record), flush=True)
    return record


with ThreadPoolExecutor(max_workers=args.workers) as executor:
    records = list(executor.map(measure, args.depths))
report = {"target": target, "options": records, "all_succeeded": all("error" not in row for row in records),
          "whole_design_routed": False}
(args.output / "report.json").write_text(json.dumps(report, indent=2)+"\n")
if not report["all_succeeded"]:
    raise SystemExit("Some FIFO measurements failed; inspect their synthesis logs")
