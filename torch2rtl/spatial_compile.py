"""Select spatial actor/FIFO options from an explicit resource catalogue."""

from dataclasses import fields, replace
import gzip
import json
from pathlib import Path
from time import monotonic

from .cp_sat import solve
from .network import edges, emit
from .schedule import Dependency, Limits, Option, Problem, Solution, fifo_occupancy, resource_totals, validate_solution
from .spatial_schedule import ActorConfig, FifoConfig, problem


def summary(solution):
    return {field.name: getattr(solution, field.name) for field in fields(solution) if field.name != "offsets"}


def compile_network(graph, catalogue, target, directory, limits=Limits(), validate_only=False):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    if validate_only and not catalogue.get("initial_schedule"):
        raise ValueError("Validation requires an initial_schedule containing a CP-SAT solution")
    if set(catalogue["actor_options"]) != {value.name for value in graph.values if value is not graph.input}:
        raise ValueError("Supply an option catalogue for every actor")
    if set(catalogue["fifo_options"]) != {name for name, *_ in edges(graph)}:
        raise ValueError("Supply a FIFO option catalogue for every edge")
    actors = {actor: {name: ActorConfig(spec.get("output_lanes"), spec.get("reduction_lanes"),
                    spec.get("memories", {}).get("line_layout", "parallel"), spec["resources"],
                    spec.get("memories", {}).get("row_buffers", 1), spec.get("memories", {}).get("extra_rows", 0),
                    spec.get("requantization","auto"))
                    for name, spec in options.items()} for actor, options in catalogue["actor_options"].items()}
    fifos = {edge: {name: FifoConfig(spec["depth"], spec["resources"]) for name, spec in options.items()}
             for edge, options in catalogue["fifo_options"].items()}
    choices = {**{"actor:"+actor: tuple(Option(name, config.resources) for name, config in options.items())
                  for actor, options in actors.items()},
               **{"fifo:"+edge: tuple(Option(name, config.resources) for name, config in options.items())
                  for edge, options in fifos.items()}}
    # This necessary resource check avoids expanding millions of events when
    # every option combination already exceeds the explicit resource budget.
    initial=catalogue.get("preferred_options",{})
    seed_choices,seed_weights=choices,target.get("resource_weights",{})
    if initial:
        # A cheap Hamming-distance optimization repairs an old configuration
        # against changed resource costs/budgets before using it as a hint.
        # Preserve a working buffer plan before minimizing actor edits. A
        # capacity cut is cheap in bits but may destroy branch startup.
        fifo_penalty=len(actors)+1
        seed_choices={group:tuple(Option(option.name,option.resources,
                       int(group in initial and option.name != initial[group]) *
                       (fifo_penalty if group.startswith("fifo:") else 1))
                       for option in options) for group,options in choices.items()}
        seed_weights={}
    resource_problem = Problem(("start",), seed_choices, (), (), target["resources"], 1, 0, "start",
                               fixed_resources=catalogue.get("fixed_resources", {}),
                               resource_weights=seed_weights)
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
        incumbent=None
        if catalogue.get("initial_schedule"):
            previous=Path(catalogue["initial_schedule"])
            configuration=json.loads((previous/"configuration.json").read_text())
            if configuration.get("model_sha256") != catalogue["model_sha256"]:
                raise ValueError("Initial schedule belongs to different model contents")
            record=json.loads((previous/"report.json").read_text())["solution"]
            with gzip.open(previous/"offsets.jsonl.gz","rt") as stream:
                offsets=dict(json.loads(line) for line in stream)
            incumbent=Solution(**record,offsets=offsets)
            if incumbent.period is None:
                raise ValueError("Initial schedule has no feasible period")
            # The complete current model validates this candidate below. A
            # saved solver status or matching model hash is not a certificate.
            report["initial_schedule"]=str(previous)
        elif initial:
            # Preserve useful capacity while allowing cheaper physical memory
            # placement or more buffering. Exact old FIFO styles can exclude
            # every resource-feasible seed even when the same depth fits.
            buffered_choices={group:tuple(option for option in options if
                              fifos[group.removeprefix("fifo:")][option.name].depth >=
                              fifos[group.removeprefix("fifo:")][initial[group]].depth)
                              if group.startswith("fifo:") and group in initial else options
                              for group,options in seed_choices.items()}
            bounds=tuple(Dependency("start","start",spec.get("period_bound",1),1,(("actor:"+actor,name),))
                         for actor,options in catalogue["actor_options"].items() for name,spec in options.items())
            seed_plan=solve(replace(resource_problem,choices=buffered_choices,dependencies=bounds,
                                   period_limit=catalogue["period_limit"]),
                            replace(limits,seconds=min(5,limits.seconds)))
            report["seed_relaxation"]=summary(seed_plan)
            selection=seed_plan.selected if seed_plan.period is not None else preflight.selected
            report.update(status="SEEDING",stage="joint_schedule")
            (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
            selected_actors={name:{selection["actor:"+name]:options[selection["actor:"+name]]}
                             for name,options in actors.items()}
            selected_fifos={name:{selection["fifo:"+name]:options[selection["fifo:"+name]]}
                            for name,options in fifos.items()}
            seed_model=problem(graph,catalogue["lanes"],selected_actors,selected_fifos,target["resources"],
                               catalogue["period_limit"],catalogue["offset_limit"],
                               fixed_resources=catalogue.get("fixed_resources"))
            incumbent=solve(seed_model,replace(limits,seconds=min(60,limits.seconds/3)))
            report["incumbent_search"]=summary(incumbent)
            del seed_model
        report.update(status="BUILDING",stage="joint_schedule")
        (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
        started=monotonic()
        model = problem(graph, catalogue["lanes"], actors, fifos, target["resources"],
                        catalogue["period_limit"], catalogue["offset_limit"], target.get("resource_weights"),
                        catalogue.get("fixed_resources"))
        preferred={group:option for group,option in preflight.selected.items() if initial or group.startswith("actor:")}
        model=replace(model,preferred_options=preferred)
        if incumbent is not None and incumbent.period is not None:
            incumbent=replace(incumbent,resources=resource_totals(model,incumbent.selected))
            validate_solution(model,incumbent)
            model=replace(model,preferred_options=incumbent.selected,
                          preferred_period=incumbent.period,preferred_offsets=incumbent.offsets)
        report.update(status="VALIDATING" if validate_only else "SOLVING",event_count=len(model.events),
                      actor_dependency_count=len(model.dependencies),
                      construction_seconds=monotonic()-started)
        (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
        seed_seconds=incumbent.seconds if incumbent is not None and not catalogue.get("initial_schedule") else 0
        remaining=limits.seconds-seed_seconds
        if validate_only:
            solution=replace(incumbent,status="FEASIBLE",resource_optimal=False,period_bound=0,seconds=0)
            report["search_skipped"]=True
        else:
            solution = solve(model,replace(limits,seconds=max(1,remaining)))
        if incumbent is not None and incumbent.period is not None and (solution.period is None or incumbent.period<solution.period):
            if solution.status == "INFEASIBLE":
                raise ValueError("Joint solver rejected an independently verified feasible incumbent")
            solution=replace(incumbent,status="FEASIBLE",period_bound=solution.period_bound,
                             seconds=seed_seconds+solution.seconds,resource_optimal=False)
        report.update(status=solution.status, stage="joint_schedule", solution=summary(solution),
                      event_count=len(model.events), actor_dependency_count=len(model.dependencies))
        if solution.period is not None:
            selected = {name: catalogue["actor_options"][name][solution.selected["actor:"+name]] for name in actors}
            selected_fifos = {edge: catalogue["fifo_options"][edge][solution.selected["fifo:"+edge]] for edge in fifos}
            configuration = {"model": catalogue["model"], "model_sha256": catalogue["model_sha256"],
                "fusions": catalogue.get("fusions", []),
                "lanes": catalogue["lanes"],
                "output_lanes": {name: spec["output_lanes"] for name, spec in selected.items() if spec.get("output_lanes") is not None},
                "reduction_lanes": {name: spec["reduction_lanes"] for name, spec in selected.items() if spec.get("reduction_lanes") is not None},
                "requantizations": {name: spec.get("requantization","auto") for name,spec in selected.items() if spec.get("output_lanes") is not None},
                "memories": {name: spec["memories"] for name, spec in selected.items() if "memories" in spec},
                "fifo_depths": {edge: fifos[edge][solution.selected["fifo:"+edge]].depth for edge in fifos}}
            configuration["fifo_memories"] = {edge: spec["memory"] for edge, spec in selected_fifos.items()
                                               if spec.get("memory", "auto") != "auto"}
            rtl = emit(graph, configuration["lanes"], configuration["output_lanes"], configuration["fifo_depths"],
                       configuration["memories"], configuration["reduction_lanes"], configuration["fifo_memories"],
                       requantizations=configuration["requantizations"])
            (directory / "inference.sv").write_text(rtl)
            (directory / "configuration.json").write_text(json.dumps(configuration, indent=2)+"\n")
            with gzip.open(directory / "offsets.jsonl.gz", "wt") as stream:
                for name, offset in solution.offsets.items():
                    stream.write(json.dumps([name, offset])+"\n")
            report["solver_verified"] = True
            report["fifo_occupancy"] = fifo_occupancy(model,solution)
    if not report["solver_verified"]:
        for name in ("inference.sv", "configuration.json", "offsets.jsonl.gz"):
            (directory / name).unlink(missing_ok=True)
    (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
    return report
