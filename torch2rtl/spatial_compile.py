"""Select spatial actor/FIFO options from an explicit resource catalogue."""

from dataclasses import fields, replace
import gzip
import json
from pathlib import Path
from math import gcd
from time import monotonic

from .cp_sat import solve
from .network import edges, emit
from .memory import fifo_latency
from .precedence import blocking_cycle
from .schedule import Dependency, Limits, Option, Problem, Solution, fifo_occupancy, resource_totals, validate_solution
from .spatial_schedule import ActorConfig, FifoConfig, problem, words


def summary(solution):
    return {field.name: getattr(solution, field.name) for field in fields(solution) if field.name != "offsets"}


def compile_network(graph, catalogue, target, directory, limits=Limits(), validate_only=False):
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    if catalogue.get("stop_after_feasible"):
        limits=replace(limits,stop_at_period=catalogue.get("preferred_period",catalogue["period_limit"]))
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
    seed_budgets=dict(target["resources"])
    buffered={"fifo:"+edge:destination.name for edge,_,destination,_ in edges(graph)
              if catalogue.get("preferred_buffer_capacities",{}).get(edge,0)>0 and
              any(spec.get("prefetch_words",0)>0 for spec in catalogue["actor_options"][destination.name].values())}
    if initial:
        # Prefer a pipeline-capable queue when the original storage hint was
        # pruned or its eager schedule needed only one word. Then balance the
        # slowest actor, rather than spending lanes on already fast stages.
        # This is a proposal only; the complete event model remains decisive.
        initial=dict(initial)
        for edge,options in catalogue["fifo_options"].items():
            preferred=initial.get("fifo:"+edge)
            if preferred not in options or options[preferred]["depth"]<=fifo_latency(options[preferred]["depth"]):
                pipelined=[name for name,spec in options.items() if spec["depth"]>fifo_latency(spec["depth"])]
                if pipelined:
                    initial["fifo:"+edge]=min(pipelined,key=lambda name:(options[name]["depth"],name))
        traffic={"fifo:"+name:words(source.tensor,catalogue["lanes"]) for name,source,*_ in edges(graph)}
        unit=gcd(*traffic.values())
        traffic={name:count//unit for name,count in traffic.items()}
        periods=sorted({spec.get("period_bound",1) for options in catalogue["actor_options"].values()
                        for spec in options.values()})
        ranks={period:index for index,period in enumerate(periods)}
        maximum=len(periods)-1
        resource_penalty=sum(weight*target["resources"][key] for key,weight in seed_weights.items())
        hint_penalty=resource_penalty+1
        hint_limit=sum(traffic.values())*hint_penalty
        compute_penalty=hint_limit+resource_penalty+1
        pipeline_penalty=maximum*compute_penalty+hint_limit+resource_penalty+1
        def buffering_penalty(group,name):
            if group in buffered:
                return 0
            spec=catalogue["fifo_options"][group[5:]][name]
            return (pipeline_penalty*traffic[group]*int(spec["depth"]<=fifo_latency(spec["depth"]))+
                    hint_penalty*traffic[group]*int(group in initial and name!=initial[group]))
        seed_choices={group:tuple(Option(option.name,option.resources,
                       0 if group.startswith("actor:") else
                       buffering_penalty(group,option.name))
                       for option in options) for group,options in choices.items()}
        # A small virtual choice represents the maximum actor-period rank.
        # Nonnegative complementary costs encode rank(actor) <= rank(maximum)
        # without adding solver-specific variables to the compiler frontend.
        period_keys={actor:"actor_period:"+actor for actor in actors}
        for actor,key in period_keys.items():
            if key in seed_budgets:
                raise ValueError("Target resource name conflicts with an internal period bound")
            seed_budgets[key]=maximum
            group="actor:"+actor
            seed_choices[group]=tuple(replace(option,resources={**option.resources,
                key:ranks[catalogue["actor_options"][actor][option.name].get("period_bound",1)]})
                for option in seed_choices[group])
        seed_choices["proposal:actor_period"]=tuple(Option(str(period),
            {key:maximum-rank for key in period_keys.values()},rank*compute_penalty)
            for period,rank in ranks.items())
        seed_weights=target.get("resource_weights",{})
    bounds=tuple(Dependency("start","start",spec.get("period_bound",1),1,(("actor:"+actor,name),))
                 for actor,options in catalogue["actor_options"].items() for name,spec in options.items())
    # A seed should preserve useful buffering at any permitted period. Chasing
    # the fastest actor bound first can consume the space its FIFOs need.
    seed_bounds=bounds+(Dependency("start","start",catalogue["period_limit"],1),) if initial else bounds
    resource_problem = Problem(("start",), seed_choices, seed_bounds, (), seed_budgets, catalogue["period_limit"], 0, "start",
                               fixed_resources=catalogue.get("fixed_resources", {}),
                               resource_weights=seed_weights)
    # A planning peak can be supplied by an external FIFO or spare capacity in
    # its consumer's prefetch RAM. Encode capacity >= hint using complementary
    # nonnegative costs in this small proposal problem. These are heuristic
    # hints only: the complete event model decides feasibility below.
    capacity_choices=dict(seed_choices)
    capacity_budgets=dict(seed_budgets)
    capacity_hints={}
    for group,actor in buffered.items():
        edge=group[5:]
        actor_group="actor:"+actor
        specs=catalogue["actor_options"][actor]
        queues=catalogue["fifo_options"][edge]
        internal=max(spec.get("prefetch_words",0) for spec in specs.values())
        external=max(spec["depth"] for spec in queues.values())
        # Retain the ring's spare capacity AND a pipeline-capable external
        # queue. Dropping the latter can lose the last slot needed by the
        # planning schedule. Larger eager peaks remain heuristic, not minima.
        minimum_queue=min((spec["depth"] for spec in queues.values()
                           if spec["depth"]>fifo_latency(spec["depth"])),
                          default=min(spec["depth"] for spec in queues.values()))
        needed=min(internal+minimum_queue,catalogue["preferred_buffer_capacities"][edge])
        key="buffer_capacity:"+edge
        if key in capacity_budgets:
            raise ValueError("Target resource name conflicts with an internal capacity hint")
        capacity_budgets[key]=internal+external-needed
        capacity_choices[actor_group]=tuple(replace(option,resources={**option.resources,
            key:internal-specs[option.name].get("prefetch_words",0)}) for option in capacity_choices[actor_group])
        capacity_choices[group]=tuple(replace(option,resources={**option.resources,
            key:external-queues[option.name]["depth"]}) for option in capacity_choices[group])
        capacity_hints[edge]=needed
    proposal=replace(resource_problem,choices=capacity_choices,budgets=capacity_budgets)
    preflight = solve(proposal, Limits(min(limits.seconds, 5), limits.workers, limits.seed))
    capacity_status=preflight.status
    if buffered and preflight.period is None:
        preflight=solve(resource_problem,Limits(min(limits.seconds,5),limits.workers,limits.seed))
    preflight=replace(preflight,resources={key:value for key,value in preflight.resources.items() if key in target["resources"]},
                      selected={key:value for key,value in preflight.selected.items() if key in choices})
    report = {"resource_preflight": summary(preflight), "solver_verified": False,
              "hardware_fit_verified": False, "timing_verified": False,
              "resource_evidence": "Input catalogue costs; whole-design synthesis and routing remain required"}
    if buffered:
        report["buffer_capacity_proposal"]={"hints":capacity_hints,"status":capacity_status,
            "scope":"Heuristic FIFO plus prefetch capacity; full event and lifetime constraints remain required"}
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
        seed_seconds=0
        exclusions=[]
        if incumbent is None and initial and any(len(options)>1 for options in choices.values()):
            # Check the complete automatically proposed architecture first.
            # With every actor and FIFO fixed, all occupancy edges contribute
            # to domain propagation instead of waiting for option decisions.
            attempts=catalogue.get("proposal_attempts",4)
            if type(attempts)is not int or attempts<1:
                raise ValueError("Positive proposal attempt count required")
            report["proposal_attempts"]=[]
            for attempt in range(attempts):
                proposed_actors={name:{preflight.selected["actor:"+name]:options[preflight.selected["actor:"+name]]}
                                 for name,options in actors.items()}
                proposed_fifos={name:{preflight.selected["fifo:"+name]:options[preflight.selected["fifo:"+name]]}
                                for name,options in fifos.items()}
                report.update(status="CHECKING_PROPOSAL",stage="joint_schedule",resource_preflight=summary(preflight))
                (directory/"report.json").write_text(json.dumps(report,indent=2)+"\n")
                proposed=problem(graph,catalogue["lanes"],proposed_actors,proposed_fifos,target["resources"],
                                 catalogue["period_limit"],catalogue["offset_limit"],{},catalogue.get("fixed_resources"))
                proposed=replace(proposed,dependencies=proposed.dependencies+(
                    Dependency(proposed.anchor,proposed.anchor,catalogue["period_limit"],1),))
                candidate=solve(proposed,replace(limits,
                    seconds=max(1,min(limits.seconds/3,limits.seconds-seed_seconds))))
                seed_seconds+=candidate.seconds
                report["incumbent_search"]=summary(candidate)
                report["proposal_attempts"].append(summary(candidate))
                if candidate.period is not None:
                    incumbent=replace(candidate,status="FEASIBLE",resource_optimal=False,
                                      period_bound=catalogue.get("period_lower_bound",0))
                    break
                if candidate.status!="INFEASIBLE":
                    break
                conflict=blocking_cycle(proposed)
                del proposed
                report["proposal_attempts"][-1]["blocking_cycle"]=conflict
                if not conflict or not conflict["choices"]:
                    break
                # A proved core excludes the same temporal contracts even if
                # their physical memory placement/resources differ. Other
                # actors and FIFOs remain unrestricted. Timeouts add no cut.
                clause=[]
                for group,selected in conflict["choices"]:
                    options=actors[group[6:]] if group.startswith("actor:") else fifos[group[5:]]
                    contract=replace(options[selected],resources={})
                    clause.append((group,tuple(name for name,config in options.items()
                                               if replace(config,resources={})==contract)))
                exclusions.append(tuple(clause))
                if attempt+1==attempts or seed_seconds>=limits.seconds:
                    break
                following=solve(replace(proposal,exclusions=tuple(exclusions)),
                                Limits(min(limits.seconds-seed_seconds,5),limits.workers,limits.seed))
                if following.period is None:
                    following=solve(replace(resource_problem,exclusions=tuple(exclusions)),
                                    Limits(min(limits.seconds-seed_seconds,5),limits.workers,limits.seed))
                if following.period is None:
                    break
                preflight=replace(following,resources={key:value for key,value in following.resources.items()
                                                       if key in target["resources"]},
                                  selected={key:value for key,value in following.selected.items() if key in choices})
            report["proved_exclusions"]=exclusions
        report.update(status="BUILDING",stage="joint_schedule")
        (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
        started=monotonic()
        model = problem(graph, catalogue["lanes"], actors, fifos, target["resources"],
                        catalogue["period_limit"], catalogue["offset_limit"], target.get("resource_weights"),
                        catalogue.get("fixed_resources"))
        model=replace(model,exclusions=tuple(exclusions))
        if catalogue.get("period_lower_bound"):
            model=replace(model,dependencies=model.dependencies+(
                Dependency(model.anchor,model.anchor,catalogue["period_lower_bound"],1),))
        preferred={group:option for group,option in preflight.selected.items() if initial or group.startswith("actor:")}
        model=replace(model,preferred_options=preferred,
                      preferred_period=catalogue.get("preferred_period"))
        if incumbent is not None and incumbent.period is not None:
            # Other alternatives can introduce private pipeline events absent
            # from the seed's selected contract. Their guards are inactive;
            # initialize them and validate every constraint of the full model.
            offsets={**{event:0 for event in model.events},**incumbent.offsets}
            incumbent=replace(incumbent,offsets=offsets,resources=resource_totals(model,incumbent.selected))
            validate_solution(model,incumbent)
            model=replace(model,preferred_options=incumbent.selected,
                          preferred_period=incumbent.period,preferred_offsets=incumbent.offsets)
        report.update(status="VALIDATING" if validate_only else "SOLVING",event_count=len(model.events),
                      actor_dependency_count=len(model.dependencies),
                      construction_seconds=monotonic()-started)
        (directory / "report.json").write_text(json.dumps(report, indent=2)+"\n")
        remaining=limits.seconds-seed_seconds
        if validate_only:
            solution=replace(incumbent,status="FEASIBLE",resource_optimal=False,period_bound=0,seconds=0)
            report["search_skipped"]=True
        else:
            varying=any(len(options)>1 for options in model.choices.values())
            if varying and (incumbent is None or incumbent.period is None):
                # Actor-only bootstrap can miss the necessary memory tradeoff.
                # Find a fully joint feasible design at the ceiling before
                # attempting tighter periods with no complete schedule hint.
                feasible=solve(replace(model,resource_weights={},dependencies=model.dependencies+(
                    Dependency(model.anchor,model.anchor,catalogue["period_limit"],1),)),
                    replace(limits,seconds=max(1,remaining)))
                report["feasibility_search"]=summary(feasible)
                if feasible.period is not None:
                    incumbent=replace(feasible,status="FEASIBLE",resource_optimal=False,
                                      period_bound=catalogue.get("period_lower_bound",0))
                    model=replace(model,preferred_options=incumbent.selected,preferred_period=incumbent.period,
                                  preferred_offsets=incumbent.offsets)
                seed_seconds+=feasible.seconds
                remaining-=feasible.seconds
                (directory/"report.json").write_text(json.dumps(report,indent=2)+"\n")
                solution=replace(feasible,period_bound=catalogue.get("period_lower_bound",0),resource_optimal=False)
            if not varying or (incumbent is not None and incumbent.period is not None):
                if incumbent is not None and limits.stop_at_period is not None and incumbent.period<=limits.stop_at_period:
                    solution=incumbent
                    report["objective_search_stopped"]="Requested throughput reached; no global optimum claimed"
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
