"""Small complete integer-subset path, with synthesis-characterized choices."""

from dataclasses import asdict
from math import ceil
from pathlib import Path
import json
import shutil

from .cp_sat import solve
from .flow import synthesize
from .lower import lower
from .rtl import emit
from .schedule import Dependency, Fifo, Limits, Option, Problem


def schedule_problem(kernel, candidates, target):
    events, dependencies, fifos = ["start"], [], []
    options = tuple(Option(name, candidate["resources"]) for name, candidate in candidates.items())
    depths = {name: candidate["depth"] for name, candidate in candidates.items()}
    for name, candidate in candidates.items():
        when = (("hardware", name),)
        words = ceil(kernel.input.elements / candidate["lanes"])
        inputs = tuple(f"{name}/input/{index}" for index in range(words))
        writes = tuple(f"{name}/write/{index}" for index in range(words))
        reads = tuple(f"{name}/read/{index}" for index in range(words))
        events.extend(inputs + writes + reads)
        dependencies.append(Dependency("start", inputs[0], when=when))
        for index, (read_input, write) in enumerate(zip(inputs, writes)):
            dependencies.append(Dependency(read_input, write, 1, when=when))
            successor = (index + 1) % words
            frames = int(successor == 0)
            # The map register is a one-word elastic stage. New input can replace
            # its previous value on the same edge that the FIFO accepts it.
            dependencies.append(Dependency(write, inputs[successor], 0, frames, when))
            dependencies.append(Dependency(read_input, inputs[successor], 1, frames, when))
        if kernel.reduction:
            output = f"{name}/output"
            events.append(output)
            dependencies.append(Dependency(reads[-1], output, 1, when=when))
            dependencies.append(Dependency(output, reads[0], 1, 1, when))
        fifos.append(Fifo(writes, reads, "hardware", depths, when))
    # All delays and frame advances are nonnegative. Every option is connected
    # from start and has no upper-delay constraints: V*max_delay is a safe bound.
    bound = max(1, len(events))
    return Problem(tuple(events), {"hardware": options}, tuple(dependencies), tuple(fifos),
                   target["resources"], bound, bound, "start",
                   resource_weights=target.get("resource_weights", {}))


def compile_module(module, target, lane_options, depth_options, output, limits=Limits()):
    kernel = lower(module)
    output = Path(output)
    output.mkdir(parents=True, exist_ok=True)
    (output / "model.mlir").write_text(str(module))
    candidates = {}
    if not lane_options or not depth_options or min(lane_options + depth_options) < 1:
        raise ValueError("Supply positive lane and FIFO-depth candidates")
    for lanes in sorted(set(lane_options)):
        for depth in sorted(set(depth_options)):
            name = f"lanes_{lanes}_depth_{depth}"
            resources = synthesize(emit(kernel, lanes, depth), output / name, target)
            candidates[name] = {"lanes": lanes, "depth": depth, "resources": resources}
    problem = schedule_problem(kernel, candidates, target)
    solution = solve(problem, limits)
    report = {"solution": asdict(solution), "candidates": candidates, "kernel": asdict(kernel),
              "clock_hz": target["clock_hz"], "event_count": len(problem.events),
              "scheduled_fps": target["clock_hz"] / solution.period if solution.period else None,
              "timing_closed": False, "hardware_measured_fps": None}
    (output / "schedule-problem.json").write_text(json.dumps(asdict(problem), indent=2) + "\n")
    (output / "compile.json").write_text(json.dumps(report, indent=2) + "\n")
    if solution.period is None:
        raise ValueError(f"No candidate schedule: {solution.status}; see reported domains and budgets")
    chosen = output / solution.selected["hardware"]
    for filename in ("inference.sv", "netlist.json"):
        shutil.copyfile(chosen / filename, output / filename)
    return report
