"""Generic screened characterization and joint scheduling, with explicit inputs."""

import hashlib
import json
from pathlib import Path
import subprocess
import math
from concurrent.futures import ThreadPoolExecutor
from collections import Counter
from copy import deepcopy
from dataclasses import replace
from threading import Lock
from time import monotonic

from .catalogue import absorb_input_buffers, prepare, retain
from .cp_sat import solve
from .flow import characterize, counters
from .cache import write_json
from .exploration import refine
from .memory import fifo_latency
from .frontend import load
from .graph import actors, read
from .network import actor_rtl, edges, fifo_width
from .schedule import Dependency, Limits, Option, Problem
from .spatial import wrapped
from .spatial_compile import compile_network, summary


def relaxation(catalogue,target):
    choices,dependencies={},[]
    for actor,options in catalogue["actor_options"].items():
        group="actor:"+actor
        choices[group]=tuple(Option(name,spec["resources"]) for name,spec in options.items())
        for name,spec in options.items():
            dependencies.append(Dependency("epoch","epoch",spec["period_bound"],1,((group,name),)))
    for edge,options in catalogue["fifo_options"].items():
        choices["fifo:"+edge]=tuple(Option(name,spec["resources"]) for name,spec in options.items())
    return Problem(("epoch",),choices,tuple(dependencies),(),target["resources"],
                   catalogue["period_limit"],0,"epoch",fixed_resources=catalogue.get("fixed_resources",{}),
                   resource_weights=target.get("resource_weights",{}))


def measure(graph,catalogue,target,cache,progress=print,workers=1):
    values={value.name:value for value in graph.values}
    if type(workers) is not int or workers<1:
        raise ValueError("Positive characterization worker count required")
    jobs=[(name,label,spec) for name,options in catalogue["actor_options"].items() for label,spec in options.items()]
    progress(f"Characterize {len(jobs)} actor options with {workers} workers; reuse exact cache hits")
    progress("Synthesis reports below describe individual candidates, not whole-design utilization")
    counts=Counter()
    reported_actors=set()
    cache_locks={}
    cache_lock=Lock()
    def run(job):
        name,label,spec=job
        rtl=actor_rtl(values[name],catalogue["lanes"],spec.get("output_lanes"),
                      spec.get("memories"),spec.get("reduction_lanes"),spec.get("requantization","auto"))
        try:
            # Equivalent options can emit identical RTL and share a cache
            # directory. Never let concurrent tool processes write it twice.
            key=hashlib.sha256(rtl.encode()).hexdigest()
            with cache_lock:
                lock=cache_locks.setdefault(key,Lock())
            with lock:
                evidence=characterize(rtl,target,cache)
            return job,evidence,None
        except (ValueError,subprocess.CalledProcessError) as error:
            return job,None,str(error)
    with ThreadPoolExecutor(max_workers=workers) as executor:
        for completed,((name,label,spec),evidence,error) in enumerate(executor.map(run,jobs),1):
            if error is not None:
                counts["rejected"]+=1
                catalogue.setdefault("rejected_measurements",[]).append({"actor":name,"option":label,"error":str(error)})
                del catalogue["actor_options"][name][label]
                progress(f"Actor {name}/{label}: rejected; {error}")
                continue
            spec["estimated_resources"]=spec["resources"]
            spec["resources"]=evidence["resources"]
            spec["measurement"]={key:value for key,value in evidence.items() if key != "resources"}
            counts["cached" if evidence["cache_hit"] else "measured"]+=1
            resources=", ".join(f"{key}={value:,}" for key,value in sorted(evidence["resources"].items()))
            source="cached" if evidence["cache_hit"] else "characterized"
            progress(f"Synthesis {name}/{label}: {resources} ({source})")
            if name not in reported_actors:
                progress(f"Synthesis evidence: {Path(evidence['cache_path'])/'report.json'}")
                reported_actors.add(name)
            if completed%10==0 or completed==len(jobs):
                progress(f"Actors {completed}/{len(jobs)}: {counts['cached']} cached, {counts['measured']} measured, {counts['rejected']} rejected")
    for name,options in catalogue["actor_options"].items():
        if not options:
            raise ValueError(f"No characterized implementation remains for {name}")
    widths={name:fifo_width(source,catalogue["lanes"]) for name,source,*_ in edges(graph)}
    total=sum(len(options) for options in catalogue["fifo_options"].values())
    completed=0
    progress(f"Characterize {total} FIFO options")
    for edge,options in catalogue["fifo_options"].items():
        for label,spec in options.items():
            parameters={"WIDTH":widths[edge],"DEPTH":spec["depth"],"MEMORY_STYLE":'"'+spec["memory"]+'"'}
            rtl=wrapped("stream_fifo",parameters,widths[edge],("fifo.sv",))
            evidence=characterize(rtl,target,cache)
            spec["estimated_resources"]=spec["resources"]
            spec["resources"]=evidence["resources"]
            spec["measurement"]={key:value for key,value in evidence.items() if key != "resources"}
            completed+=1
            if completed%25==0 or completed==total:
                progress(f"FIFOs {completed}/{total} characterized")
    catalogue["resource_provenance"]="Exact RTL/target/tool keyed actor and FIFO synthesis; whole-design mapping and routing still required"
    return catalogue


def prune_unsupported(catalogue,target,limits=Limits()):
    """Drop only options proved impossible by the cheap resource relaxation.

    Fix its period to the allowed ceiling so slower but permitted choices stay
    eligible. A timeout retains the option. No event-schedule feasibility is
    inferred from passing this necessary check.
    """
    model=relaxation(catalogue,target)
    model=replace(model,resource_weights={},dependencies=model.dependencies+(
        Dependency("epoch","epoch",model.period_limit,1),))
    supported={}
    removed=[]
    for group,options in model.choices.items():
        supported[group]=set()
        for option in options:
            probe=replace(model,choices={**model.choices,group:(option,)},dependencies=tuple(
                dependency for dependency in model.dependencies
                if all(choice!=group or name==option.name for choice,name in dependency.when)))
            result=solve(probe,replace(limits,seconds=min(limits.seconds,1)))
            if result.status=="INFEASIBLE":
                removed.append((group,option.name))
            else:
                supported[group].add(option.name)
    if any(not names for names in supported.values()):
        raise ValueError("Resource pruning found no supported option for a required choice")
    for kind in ("actor","fifo"):
        for name,options in catalogue[kind+"_options"].items():
            catalogue[kind+"_options"][name]={label:spec for label,spec in options.items()
                                             if label in supported[kind+":"+name]}
    # Hints may name an option just proved impossible; they have no authority.
    catalogue["preferred_options"]={group:name for group,name in catalogue.get("preferred_options",{}).items()
                                     if name in supported[group]}
    history=catalogue["screen"].setdefault("resource_unsupported_options",[])
    history.extend(pair for pair in removed if list(pair) not in history and pair not in history)
    return len(removed)


def prune_fifos(catalogue):
    """Discard capacity/latency/resource dominated measured FIFO choices."""
    removed=0
    for edge,options in catalogue["fifo_options"].items():
        def dominates(left,right):
            resources=left["resources"].keys() | right["resources"].keys()
            return (left["depth"] >= right["depth"] and
                    fifo_latency(left["depth"]) <= fifo_latency(right["depth"]) and
                    all(left["resources"].get(key,0) <= right["resources"].get(key,0) for key in resources))
        kept={}
        for name,spec in sorted(options.items()):
            if any(dominates(other,spec) for other in kept.values()):
                continue
            kept={label:other for label,other in kept.items() if not dominates(spec,other)}
            kept[name]=spec
        removed+=len(options)-len(kept)
        catalogue["fifo_options"][edge]=kept
    catalogue["screen"]["dominated_measured_fifo_options"]=removed
    return catalogue


def configuration_hints(catalogue,configuration):
    """Warm-start an incremental compile; no suggested choice is fixed."""
    if configuration.get("model_sha256") != catalogue["model_sha256"]:
        raise ValueError("Initial configuration belongs to different model contents")
    preferred={}
    for actor,options in catalogue["actor_options"].items():
        if actor not in configuration.get("memories",{}):
            continue
        memories=configuration["memories"][actor]
        def score(item):
            name,spec=item
            mismatches=sum(spec.get(field) != configuration.get(field,{}).get(actor)
                           for field in ("output_lanes","reduction_lanes"))
            mismatches+=spec.get("requantization","auto") != configuration.get("requantizations",{}).get(actor,"auto")
            selected=spec.get("memories",{})
            keys=("weight","line","storage","line_layout","extra_rows","weight_block_depth","line_bank_width")
            defaults={"weight":"block","line":"block","storage":"block","line_layout":"parallel","extra_rows":0}
            def differs(key):
                left,right=selected.get(key,defaults.get(key)),memories.get(key,defaults.get(key))
                if key=="extra_rows" and (isinstance(left,(tuple,list)) or isinstance(right,(tuple,list))):
                    if type(left)is int:left=(left,)*len(right)
                    if type(right)is int:right=(right,)*len(left)
                    return tuple(left)!=tuple(right)
                return left!=right
            memory_mismatches=sum(differs(key) for key in keys
                                  if not (key == "line_layout" and "extra_rows" in selected)
                                  and not (key == "extra_rows" and key not in memories))
            extra=selected.get("extra_rows",0)
            return (mismatches,memory_mismatches,spec["resources"].get("bram",0),
                    -(extra if type(extra) is int else sum(extra)),spec["resources"].get("lut_sites",spec["resources"].get("lut",0)),name)
        preferred["actor:"+actor]=min(options.items(),key=score)[0]
    depths=configuration.get("fifo_depths",{})
    for edge,options in catalogue["fifo_options"].items():
        old=edge if edge in depths else None
        if old is None:
            same_source=[name for name in depths if name.split("->")[0] == edge.split("->")[0]]
            if len(same_source) == 1:
                old=same_source[0]
        if old is not None:
            depth=depths[old]
            style=configuration.get("fifo_memories",{}).get(old,"block")
            preferred["fifo:"+edge]=min(options,key=lambda name:(abs(options[name]["depth"]-depth),
                                                               options[name].get("memory") != style,name))
    return preferred


def buffering_hints(graph,catalogue,configuration):
    """Keep internal and external capacity when replacing a planning actor.

    A prefetching actor can make its external queue peak very small. Its
    replacement must also account for capacity inside the window RAM.
    These are proposal hints; exact event/occupancy constraints still decide.
    """
    preferred=configuration_hints(catalogue,configuration)
    # The scheduled external source can supply its input just in time; it has
    # no independent actor burst whose buffered capacity must be preserved.
    return {edge:0 if source is graph.input else configuration["fifo_depths"][edge]+
            catalogue["actor_options"][destination.name].get(
                preferred.get("actor:"+destination.name),{}).get("prefetch_words",0)
            for edge,source,destination,_ in edges(graph)}


def reuse_measured_costs(graph,catalogue,target,cache):
    """Use exact cache hits before heuristic pruning; never synthesize here."""
    hits=0
    if not all(key in target for key in ("synthesis","cell_costs")):
        catalogue["screen"]["cached_actor_costs"]=0
        return
    values={value.name:value for value in graph.values}
    for name,options in catalogue["actor_options"].items():
        for spec in options.values():
            rtl=actor_rtl(values[name],catalogue["lanes"],spec.get("output_lanes"),
                          spec.get("memories"),spec.get("reduction_lanes"),spec.get("requantization","auto"))
            evidence=characterize(rtl,target,cache,cached_only=True)
            if evidence is not None:
                spec["estimated_resources"]=spec["resources"]
                spec["resources"]=evidence["resources"]
                spec["measurement"]={key:value for key,value in evidence.items() if key!="resources"}
                hits+=1
    catalogue["screen"]["cached_actor_costs"]=hits
    if hits:
        catalogue["resource_provenance"]="Exact cached actor costs where available, geometry estimates elsewhere; whole-design verification required"


def automatic_buffer_plan(graph,catalogue,target,search,directory,limits,progress=print):
    """Derive a storage hint with CP-SAT, without an architecture supplied by a user.

    Temporarily relax FIFO resource costs while keeping their exact finite
    occupancy constraints. This is only a bootstrap calculation. Retiming and
    the final solve must use physically characterized costs and the real budget.
    """
    bound=solve(relaxation(catalogue,target),limits)
    if bound.period is None:
        return None,{"status":bound.status,"stage":"automatic_architecture_screen"}
    planning=deepcopy(catalogue)
    planning.pop("preferred_options",None)
    planning.pop("initial_schedule",None)
    if "required_fps" in target:
        requested=target["required_fps"]
        if not isinstance(requested,(int,float)) or not math.isfinite(requested) or requested<=0:
            raise ValueError("Required throughput must be a positive finite number")
        planning["preferred_period"]=min(planning["period_limit"],
                                         math.floor(target["clock_hz"]/requested))
        planning["stop_after_feasible"]=True
    planning["actor_options"]={name:{bound.selected["actor:"+name]:options[bound.selected["actor:"+name]]}
                                for name,options in catalogue["actor_options"].items()}
    channels=edges(graph)
    fanout=Counter(source for _,source,*_ in channels)
    fanin=Counter(destination for _,_,destination,_ in channels)
    for edge,source,destination,_ in channels:
        options=catalogue["fifo_options"][edge]
        maximum=search["fifo_max_words"] if fanout[source]>1 or fanin[destination]>1 else search.get("fifo_linear_max_words",search["fifo_max_words"])
        depth=max(spec["depth"] for spec in options.values() if spec["depth"]<=maximum)
        planning["fifo_options"][edge]={"planning_capacity":{"depth":depth,"memory":"block","resources":{}}}
    planning["resource_provenance"]="Buffer-planning relaxation: FIFO resource costs deliberately omitted; not a physical implementation"
    progress("Derive branch storage from a fresh CP-SAT schedule with relaxed FIFO costs")
    report=compile_network(graph,planning,target,directory,limits)
    report["physical_candidate"]=False
    report["scope"]=planning["resource_provenance"]
    (directory/"report.json").write_text(json.dumps(report,indent=2)+"\n")
    if not report["solver_verified"]:
        return None,report
    hint=json.loads((directory/"configuration.json").read_text())
    hint["fifo_depths"]={edge:max(1,record["peak_live_words"])
                         for name,record in report["fifo_occupancy"].items()
                         for edge in [name.removeprefix("fifo:")]}
    # The external source can supply words just in time. An earliest relaxed
    # schedule may eagerly fill its whole planning queue; retaining that peak
    # would spend fabric memory without establishing a throughput benefit.
    # Keep the smallest pipelined input queue as a hint; final CP-SAT still
    # chooses and verifies its exact depth along with every other FIFO.
    for edge,source,_,_ in channels:
        if source is graph.input:
            hint["fifo_depths"][edge]=min((spec["depth"] for spec in catalogue["fifo_options"][edge].values()
                                         if spec["depth"]>1),default=1)
    hint["origin"]="Compiler-derived CP-SAT buffer plan; not an external architecture or schedule seed"
    (directory/"storage-hint.json").write_text(json.dumps(hint,indent=2)+"\n")
    return hint,report


def optimize(model,target,search,directory,cache,limits=Limits(),stage="schedule",progress=print):
    started=monotonic()
    before=counters()
    status="failed"
    try:
        result=_optimize(model,target,search,directory,cache,limits,stage,progress)
        status="completed"
        return result
    finally:
        after=counters()
        write_json(Path(directory)/"compile-metrics.json",{
            "elapsed_seconds":monotonic()-started,"status":status,
            "tool_jobs":{key:value-before.get(key,0) for key,value in after.items()},
            "scope":"This invocation only; exact cache hits do not count as synthesis jobs"})


def _optimize(model,target,search,directory,cache,limits=Limits(),stage="schedule",progress=print):
    directory=Path(directory)
    directory.mkdir(parents=True,exist_ok=True)
    model=Path(model).resolve()
    digest=hashlib.sha256(model.read_bytes()).hexdigest()
    progress(f"Import exported model through torch-mlir: {model}")
    _,module=load(model)
    progress("Form fused actors and generate implementation candidates")
    graph=actors(read(module),search.get("fusions",()),search["lanes"])
    if search.get("automatic_buffering") and any(search.get(key) for key in ("initial_configuration","initial_schedule","absorb_input_fifos")):
        raise ValueError("Automatic buffering requires a cold compile without an external configuration or schedule seed")
    catalogue=prepare(graph,model,digest,target,search)
    initial=json.loads(Path(search["initial_configuration"]).read_text()) if search.get("initial_configuration") else None
    if search.get("absorb_input_fifos"):
        if initial is None:
            raise ValueError("Input-buffer absorption requires an initial_configuration seed")
        initial=absorb_input_buffers(graph,catalogue,initial,target,search.get("absorbed_fifo_max_words",8))
    progress("Look up cached implementation costs")
    reuse_measured_costs(graph,catalogue,target,cache)
    (directory/"model.mlir").write_text(str(module))
    (directory/"search.json").write_text(json.dumps(search,indent=2)+"\n")
    (directory/"target.json").write_text(json.dumps(target,indent=2)+"\n")
    def save():
        (directory/"catalogue.json").write_text(json.dumps(catalogue,indent=2)+"\n")
    save()
    progress("Screen candidate resources and throughput")
    bound=solve(relaxation(catalogue,target),Limits(seconds=min(limits.seconds,10)))
    if bound.period is not None:
        initial_limit=search.get("initial_actor_options",search["max_actor_options"])
        if type(initial_limit) is not int or not 1 <= initial_limit <= search["max_actor_options"]:
            raise ValueError("initial_actor_options must be between 1 and max_actor_options")
        retain(catalogue,bound,initial_limit,search.get("retention_period_slack",1.25))
        save()
    screen={"relaxation":summary(bound),"whole_design_verified":False,
            "optimistic_fps_bound":target["clock_hz"]/bound.period_bound if bound.period_bound>0 else None,
            "resource_evidence":catalogue["resource_provenance"],"screen":catalogue["screen"]}
    (directory/"screen.json").write_text(json.dumps(screen,indent=2)+"\n")
    if stage == "screen" or bound.period is None:
        return screen
    progress("Screen passed; characterize retained implementations with exact cache keys")
    measure(graph,catalogue,target,cache,progress,search.get("characterization_workers",1))
    rounds=search.get("characterization_rounds",1)
    if type(rounds)is not int or rounds<1:
        raise ValueError("Positive characterization round count required")
    if rounds>1 and initial is not None:
        raise ValueError("Characterization refinement requires a cold architecture search")
    history=[]
    for iteration in range(1,rounds):
        # Measured costs can expose a cheaper neighboring compute geometry.
        # Re-screen the generated space inside the same invocation; do not
        # depend on an operator manually rerunning with a richer cost cache.
        incumbent=solve(relaxation(catalogue,target),Limits(seconds=min(limits.seconds,10)))
        expanded=prepare(graph,model,digest,target,search)
        reuse_measured_costs(graph,expanded,target,cache)
        candidate=solve(relaxation(expanded,target),Limits(seconds=min(limits.seconds,10)))
        if candidate.period is None:
            break
        retain(expanded,candidate,search["max_actor_options"],search.get("retention_period_slack",1.25),
               incumbent if incumbent.period is not None else None)
        expanded=refine(catalogue,expanded,incumbent,candidate,target,
                        search.get("refinement_options",search["max_actor_options"]),search["max_actor_options"])
        missing=sum("measurement" not in spec for options in expanded["actor_options"].values() for spec in options.values())
        history.append({"round":iteration+1,"period":candidate.period,"uncached_actor_options":missing})
        catalogue=expanded
        if not missing:
            break
        progress(f"Characterization refinement {iteration+1}: {missing} new actor costs within the global measurement budget")
        measure(graph,catalogue,target,cache,progress,search.get("characterization_workers",1))
    catalogue["screen"]["characterization_refinement"]=history
    prune_fifos(catalogue)
    if initial is not None:
        catalogue["preferred_options"]=configuration_hints(catalogue,initial)
    if search.get("initial_schedule"):
        catalogue["initial_schedule"]=search["initial_schedule"]
    save()
    measured_bound=solve(relaxation(catalogue,target),Limits(seconds=min(limits.seconds,10)))
    (directory/"measured-bound.json").write_text(json.dumps(summary(measured_bound),indent=2)+"\n")
    if measured_bound.period is not None:
        progress("Synthesis-based resource proposal; joint scheduling and whole-design fit still pending")
        for resource,budget in target["resources"].items():
            progress(f"  {resource}: {measured_bound.resources.get(resource,0):,} / {budget:,} target budget")
    if stage == "measure":
        return {"resource_provenance":catalogue["resource_provenance"],"catalogue":str(directory/"catalogue.json")}
    if measured_bound.period is None:
        return {"status":measured_bound.status,"stage":"measured_resource_screen",
                "scope":"Retained options only; broaden the input search before scheduling"}
    if search.get("automatic_buffering"):
        initial,planning=automatic_buffer_plan(graph,catalogue,target,search,directory/"buffer-planning",limits,progress)
        if initial is None:
            return {"status":planning["status"],"stage":"automatic_buffer_planning","solver_verified":False}
        catalogue["preferred_buffer_capacities"]=buffering_hints(graph,catalogue,initial)
        initial=absorb_input_buffers(graph,catalogue,initial,target,search.get("absorbed_fifo_max_words",8),pack_rows=True)
        progress("Characterize the compiler-derived source storage and solve under the actual resource budget")
        measure(graph,catalogue,target,cache,progress,search.get("characterization_workers",1))
        prune_fifos(catalogue)
        catalogue["preferred_options"]=configuration_hints(catalogue,initial)
        catalogue["automatic_buffering"]={"source":"fresh compiler CP-SAT plan","external_architecture_seed":False,
                                          "planning_report":str(directory/"buffer-planning/report.json")}
        save()
    if search.get("clock_candidates_hz"):
        return clock_plans(graph,catalogue,target,search,directory,cache,limits,progress)
    return finish(graph,catalogue,target,search,directory,cache,limits,progress)


def finish(graph,catalogue,target,search,directory,cache,limits=Limits(),progress=print):
    """Schedule and emit an already characterized compiler-generated catalogue."""
    directory=Path(directory)
    def save():
        (directory/"catalogue.json").write_text(json.dumps(catalogue,indent=2)+"\n")
    fallback_catalogue=deepcopy(catalogue)
    catalogue["stop_after_feasible"]=bool(search.get("stop_at_required_fps",False))
    catalogue["proposal_attempts"]=search.get("proposal_attempts",4)
    if "joint_event_limit" in search:
        catalogue["joint_event_limit"]=search["joint_event_limit"]
    if catalogue["stop_after_feasible"] and "required_fps" not in target:
        raise ValueError("Stopping at requested throughput requires target.required_fps")
    progress("Search objective: stop when requested FPS is reached" if catalogue["stop_after_feasible"] else
             "Search objective: maximize throughput within resource limits and solver budget; requested FPS is not a stopping point")
    if "required_fps" in target:
        requested=target["required_fps"]
        if not isinstance(requested,(int,float)) or not math.isfinite(requested) or requested<=0:
            raise ValueError("Required throughput must be a positive finite number")
        original_limit=catalogue["period_limit"]
        catalogue["period_limit"]=max(1,min(original_limit,math.floor(target["clock_hz"]/requested)))
        final_bound=solve(relaxation(catalogue,target),limits)
        catalogue["period_lower_bound"]=max(1,math.ceil(final_bound.period_bound))
        (directory/"throughput-screen.json").write_text(json.dumps(summary(final_bound),indent=2)+"\n")
        save()
        if final_bound.period is None:
            progress("Requested FPS is outside the screened resource tradeoff; solve for the best available period")
            catalogue["period_limit"]=original_limit
            catalogue["stop_after_feasible"]=False
            catalogue.pop("period_lower_bound",None)
    progress("Prove and prune resource-infeasible choices")
    removed=prune_unsupported(catalogue,target,limits)
    progress(f"Resource proofs removed {removed} impossible choices before event scheduling")
    save()
    progress("Solve joint actor scheduling and FIFO occupancy; validate and emit RTL")
    report=compile_network(graph,catalogue,target,directory/"schedule",limits)
    if not report["solver_verified"] and "required_fps" in target and catalogue["period_limit"]<original_limit:
        progress("No verified schedule at the requested FPS; retry within the supplied period limit")
        catalogue=fallback_catalogue
        catalogue["period_limit"]=original_limit
        catalogue["stop_after_feasible"]=False
        catalogue["proposal_attempts"]=search.get("proposal_attempts",4)
        if "joint_event_limit" in search:
            catalogue["joint_event_limit"]=search["joint_event_limit"]
        catalogue.pop("period_lower_bound",None)
        prune_unsupported(catalogue,target,limits)
        save()
        report=compile_network(graph,catalogue,target,directory/"schedule",limits)
    report["automatic_architecture_selection"]={
        "external_configuration_seed":bool(search.get("initial_configuration")),
        "external_schedule_seed":bool(search.get("initial_schedule")),
        "compiler_buffer_planning":bool(search.get("automatic_buffering")),
        "scope":"Bounded compiler search; no global optimality claim"}
    if report["solver_verified"]:
        report["scheduled_fps"]=target["clock_hz"]/report["solution"]["period"]
        progress(f"Verified schedule: {report['scheduled_fps']:.4f} FPS at {target['clock_hz']/1e6:.2f} MHz; physical verification pending")
        if "required_fps" in target:
            report["required_fps"]=target["required_fps"]
            report["required_fps_met"]=report["scheduled_fps"]>=target["required_fps"]
    (directory/"schedule/report.json").write_text(json.dumps(report,indent=2)+"\n")
    if report["solver_verified"] and target.get("characterize_netlist_mapping"):
        from .link import prepare as prepare_link
        configuration=json.loads((directory/"schedule/configuration.json").read_text())
        prepare_link(graph,configuration,target,cache,directory/"schedule/mapped")
        report["mapped_network"]=str(directory/"schedule/mapped")
        (directory/"schedule/report.json").write_text(json.dumps(report,indent=2)+"\n")
    return report


def clock_plans(graph,catalogue,target,search,directory,cache,limits,progress):
    """Schedule a small legal clock set with one shared measured catalogue."""
    clocks=search["clock_candidates_hz"]
    if not isinstance(clocks,list) or not clocks or any(type(hz) is not int or hz<=0 for hz in clocks) or len(set(clocks))!=len(clocks):
        raise ValueError("clock_candidates_hz must contain unique positive integer frequencies")
    plans=[]
    for frequency in clocks:
        location=directory/f"clock-{frequency}"
        location.mkdir(parents=True,exist_ok=True)
        candidate_target={**target,"clock_hz":frequency}
        write_json(location/"target.json",candidate_target)
        write_json(location/"search.json",search)
        progress(f"Schedule clock candidate {frequency/1e6:g} MHz using shared characterized costs")
        report=finish(graph,deepcopy(catalogue),candidate_target,search,location,cache,limits,progress)
        plans.append({"clock_hz":frequency,"directory":str(location.resolve()),
                      "solver_verified":report.get("solver_verified",False),
                      "scheduled_fps":report.get("scheduled_fps"),
                      "resources":report.get("solution",{}).get("resources",{})})
    report={"clock_plans":plans,"scope":"Scheduled predictions; final routing determines clock feasibility"}
    write_json(directory/"clock-plans.json",report)
    return report
