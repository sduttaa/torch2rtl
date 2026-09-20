"""Run vendor-family tools. Parts, clocks, capacities and cell costs are inputs."""

from collections import Counter
from fnmatch import fnmatchcase
from pathlib import Path
import json
import re
import subprocess


def synthesize(rtl, directory, target):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "inference.sv").write_text(rtl)
    config = target["synthesis"]
    command = config["command"]
    if command not in {"synth_gowin", "synth_ice40", "synth_ecp5"}:
        raise ValueError(f"Unsupported synthesis family command: {command}")
    family = config.get("family")
    if family and not re.fullmatch(r"[A-Za-z0-9_]+", family):
        raise ValueError("Invalid synthesis family identifier")
    family_arg = f" -family {family}" if family else ""
    script = f"read_verilog -sv inference.sv\n{command} -top inference{family_arg} -json netlist.json\n"
    (directory / "synth.ys").write_text(script)
    with (directory / "synthesis.log").open("w") as log:
        subprocess.run(["yosys", "-Q", "-T", "-s", "synth.ys"], cwd=directory,
                       stdout=log, stderr=subprocess.STDOUT, check=True)
    netlist = json.loads((directory / "netlist.json").read_text())
    cells = Counter(c["type"] for c in netlist["modules"]["inference"]["cells"].values())
    (directory / "cells.json").write_text(json.dumps(cells, indent=2) + "\n")
    resources = Counter()
    for cell, count in cells.items():
        costs = [cost for pattern, cost in target["cell_costs"].items() if fnmatchcase(cell, pattern)]
        if len(costs) != 1:
            raise ValueError(f"Supply exactly one cell-cost rule for {cell}; matched {len(costs)}")
        for resource, cost in costs[0].items():
            if type(cost) is not int or cost < 0:
                raise ValueError("Cell costs must be nonnegative integers")
            resources[resource] += count * cost
    return dict(resources)
