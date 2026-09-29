"""Run vendor-family tools. Parts, clocks, capacities and cell costs are inputs."""

from collections import Counter
from fnmatch import fnmatchcase
from pathlib import Path
import json
import re
import subprocess
import hashlib
import os
import signal
from functools import lru_cache
from threading import Lock

from .cache import entry

_counts=Counter()
_count_lock=Lock()


def counters():
    with _count_lock:
        return dict(_counts)


def count(stage):
    with _count_lock:
        _counts[stage]+=1


def synthesis_command(config, top):
    """Build one family command from explicit target settings, not script text."""
    command = config["command"]
    if command not in {"synth_gowin", "synth_ice40", "synth_ecp5"}:
        raise ValueError(f"Unsupported synthesis family command: {command}")
    if not re.fullmatch(r"[A-Za-z_][A-Za-z0-9_]*", top):
        raise ValueError("Invalid synthesis top identifier")
    family = config.get("family")
    if family and not re.fullmatch(r"[A-Za-z0-9_]+", family):
        raise ValueError("Invalid synthesis family identifier")
    flags = config.get("flags", [])
    if not isinstance(flags, list) or any(not isinstance(flag, str) or not re.fullmatch(r"-[A-Za-z][A-Za-z0-9_-]*", flag) for flag in flags):
        raise ValueError("Synthesis flags must be a list of individual option names")
    family_arg = f" -family {family}" if family else ""
    return f"{command} -top {top}{family_arg}" + "".join(f" {flag}" for flag in flags)


def synthesize(rtl, directory, target):
    count("synthesis_jobs")
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    (directory / "inference.sv").write_text(rtl)
    command = synthesis_command(target["synthesis"], "inference")
    # Recent Yosys may retain alias buffers after family mapping. They are
    # connections, not physical cells; remove them before costing or routing.
    script = (f"read_verilog -sv inference.sv\n{command}\n"
              "bufnorm -conn\nclean\nwrite_json netlist.json\n")
    (directory / "synth.ys").write_text(script)
    with (directory / "synthesis.log").open("w") as log:
        command=["yosys", "-Q", "-T", "-s", "synth.ys"]
        with subprocess.Popen(command,cwd=directory,stdout=log,stderr=subprocess.STDOUT,
                              start_new_session=True) as process:
            (directory/"process.json").write_text(json.dumps({"pid":process.pid,"command":command})+"\n")
            try:
                status=process.wait(timeout=target["synthesis"].get("timeout_seconds"))
            except subprocess.TimeoutExpired:
                os.killpg(process.pid,signal.SIGTERM)
                process.wait()
                raise ValueError("Actor synthesis exceeded the supplied time limit") from None
            if status:
                raise subprocess.CalledProcessError(status,command)
    netlist = json.loads((directory / "netlist.json").read_text())
    cells = Counter(c["type"] for c in netlist["modules"]["inference"]["cells"].values())
    (directory / "cells.json").write_text(json.dumps(cells, indent=2) + "\n")
    return resource_usage(netlist,target)


def resource_usage(netlist,target,top="inference"):
    cells=Counter(cell["type"] for cell in netlist["modules"][top]["cells"].values())
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


@lru_cache(maxsize=1)
def tool_identity():
    return subprocess.check_output(["yosys", "-V"],text=True).strip()


def characterize(rtl,target,cache,cached_only=False):
    """Reuse only exactly matching RTL, mapping settings, costs and tool builds."""
    if target.get("resource_analysis"):
        from . import packing
        if target["resource_analysis"] != {"lut_sites":"gowin"} or target["synthesis"]["command"] != "synth_gowin":
            raise ValueError("Unsupported physical resource analysis")
        base=characterize(rtl,{**target,"resource_analysis":{}},cache,cached_only)
        if base is None:
            return None
        identity={"source":base["identity"],"analysis":target["resource_analysis"],
                  "packer":target["place_route"],
                  "packer_identity":packing.tool_identity(target["place_route"]["executable"],target["place_route"].get("chipdb")),
                  "analyzer_sha256":hashlib.sha256(Path(packing.__file__).read_bytes()).hexdigest()}
        key=hashlib.sha256(json.dumps(identity,sort_keys=True).encode()).hexdigest()
        directory=Path(cache)/key
        def produce():
            count("packing_jobs")
            netlist=Path(base["cache_path"])/"netlist.json"
            if not netlist.exists():
                netlist=netlist.with_name("registered.json")
            resources=packing.characterize(netlist,directory,target,base["resources"])
            return {"resources":resources,"netlist_path":str(netlist),
                    "evidence":"Mapped and packed RTL including carry padding, distributed-memory blockers, and mandatory FF sites"}
        return entry(directory,identity,produce,cached_only)
    if target.get("characterize_netlist_mapping"):
        from . import gowin
        raw=characterize(rtl,{**target,"characterize_netlist_mapping":False},cache,cached_only)
        if raw is None:
            return None
        identity={"source":raw["identity"],"mapping":target["netlist_mapping"],
                  "mapper_sha256":hashlib.sha256(Path(gowin.__file__).read_bytes()).hexdigest()}
        key=hashlib.sha256(json.dumps(identity,sort_keys=True).encode()).hexdigest()
        directory=Path(cache)/key
        def produce():
            count("mapping_jobs")
            mapped=gowin.map_netlist(Path(raw["cache_path"])/"netlist.json",directory,target)
            resources=resource_usage(json.loads(mapped.read_text()),target)
            return {"resources":resources,"raw_cache_path":raw["cache_path"],
                    "evidence":"actor RTL synthesis and selected netlist mapping"}
        return entry(directory,identity,produce,cached_only)
    identity={"rtl_sha256":hashlib.sha256(rtl.encode()).hexdigest(),
              "synthesis":target["synthesis"],"cell_costs":target["cell_costs"],
              "tool":tool_identity()}
    key=hashlib.sha256(json.dumps(identity,sort_keys=True).encode()).hexdigest()
    directory=Path(cache)/key
    def produce():
        return {"resources":synthesize(rtl,directory,target),"evidence":"actor RTL synthesis"}
    return entry(directory,identity,produce,cached_only)
