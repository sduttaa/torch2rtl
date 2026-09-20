"""Select spatial actor/FIFO options from an explicit resource catalogue."""

from dataclasses import fields
import gzip
import json
from pathlib import Path

from .cp_sat import solve
from .network import edges, emit
from .schedule import Limits, Option, Problem
from .spatial_schedule import ActorConfig, FifoConfig, problem


def summary(solution):
    return {field.name: getattr(solution, field.name) for field in fields(solution) if field.name != "offsets"}


def compile_network(graph, catalogue, target, directory, limits=Limits()):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    if set(catalogue["actor_options"]) != {value.name for value in graph.values if value is not graph.input}:
        raise ValueError("Supply an option catalogue for every actor")
    if set(catalogue["fifo_options"]) != {name for name, *_ in edges(graph)}:
        raise ValueError("Supply a FIFO option catalogue for every edge")
    actors = {actor: {name: ActorConfig(spec.get("output_lanes"), spec.get("reduction_lanes"),
                    spec.get("memories", {}).get("line_layout", "parallel"), spec["resources"])
                    for name, spec in options.items()} for actor, options in catalogue["actor_options"].items()}
    fifos = {edge: {name: FifoConfig(spec["depth"], spec["resources"]) for name, spec in options.items()}
             for edge, options in catalogue["fifo_options"].items()}
    choices = {**{"actor:"+actor: tuple(Option(name, config.resources) for name, config in options.items())
                  for actor, options in actors.items()},
               **{"fifo:"+edge: tuple(Option(name, config.resources) for name, config in options.items())
                  for edge, options in fifos.items()}}
    # This necessary resource check avoids expanding millions of events when
    # every option combination already exceeds the explicit resource budget.
    resource_problem = Problem(("start",), choices, (), (), target["resources"], 1, 0, "start",
                               fixed_resources=catalogue.get("fixed_resources", {}))
    preflight = solve(resource_problem, Limits(min(limits.seconds, 5), limits.workers, limits.seed))
    report = {"resource_preflight": summary(preflight), "solver_verified": False,
              "hardware_fit_verified": False, "timing_verified": False,
              "resource_evidence": "Input catalogue costs; whole-design synthesis and routing remain required"}
    (directory / "catalogue.json").write_text(json.dumps(catalogue, indent=2)+"\n")
    (directory / "target.json").write_text(json.dumps(target, indent=2)+"\n")
    if preflight.status not in ("OPTIMAL", "FEASIBLE"):
        report["status"] = preflight.status
        report["stage"] = "resource_preflight"
    else:
        model = problem(graph, catalogue["lanes"], actors, fifos, target["resources"],
                        catalogue["period_limit"], catalogue["offset_limit"], target.get("resource_weights"),
                        catalogue.get("fixed_resources"))
        solution = solve(model, limits)
        report.update(status=solution.status, stage="joint_schedule", solution=summary(solution),
                      event_count=len(model.events), actor_dependency_count=len(model.dependencies))
        if solution.period is not None:
            selected = {name: catalogue["actor_options"][name][solution.selected["actor:"+name]] for name in actors}
            configuration = {"model": catalogue["model"], "model_sha256": catalogue["model_sha256"],
                "fusions": catalogue.get("fusions", []),
                "lanes": catalogue["lanes"],
                "output_lanes": {name: spec["output_lanes"] for name, spec in selected.items() if spec.get("output_lanes") is not None},
                "reduction_lanes": {name: spec["reduction_lanes"] for name, spec in selected.items() if spec.get("reduction_lanes") is not None},
                "memories": {name: spec["memories"] for name, spec in selected.items() if "memories" in spec},
                "fifo_depths": {edge: fifos[edge][solution.selected["fifo:"+edge]].depth for edge in fifos}}
            rtl = emit(graph, configuration["lanes"], configuration["output_lanes"], configuration["fifo_depths"],
                       configuration["memories"], configuration["reduction_lanes"])
            (directory / "inference.sv").write_text(rtl)
            (directory / "configuration.json").write_text(json.dumps(configuration, indent=2)+"\n")
            with gzip.open(directory / "offsets.jsonl.gz", "wt") as stream:
                for name, offset in solution.offsets.items():
                    stream.write(json.dumps([name, offset])+"\n")
            report["solver_verified"] = True
    if not report["solver_verified"]:
        for name in ("inference.sv", "configuration.json", "offsets.jsonl.gz"):
            (directory / name).unlink(missing_ok=True)
    (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
    return report
