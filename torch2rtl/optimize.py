"""Generic screened characterization and joint scheduling, with explicit inputs."""

import hashlib
import json
from pathlib import Path
import subprocess

from .catalogue import absorb_input_buffers, prepare, retain
from .cp_sat import solve
from .flow import characterize
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


def measure(graph,catalogue,target,cache,progress=print):
    values={value.name:value for value in graph.values}
    for name,options in catalogue["actor_options"].items():
        for label,spec in list(options.items()):
            rtl=actor_rtl(values[name],catalogue["lanes"],spec.get("output_lanes"),
                          spec.get("memories"),spec.get("reduction_lanes"),spec.get("requantization","auto"))
            try:
                evidence=characterize(rtl,target,cache)
            except (ValueError,subprocess.CalledProcessError) as error:
                catalogue.setdefault("rejected_measurements",[]).append({"actor":name,"option":label,"error":str(error)})
                del options[label]
                progress(f"Actor {name}/{label}: rejected; {error}")
                continue
            spec["estimated_resources"]=spec["resources"]
            spec["resources"]=evidence["resources"]
            spec["measurement"]={key:value for key,value in evidence.items() if key != "resources"}
            progress(f"Actor {name}/{label}: {'cached' if evidence['cache_hit'] else 'measured'}")
        if not options:
            raise ValueError(f"No characterized implementation remains for {name}")
    widths={name:fifo_width(source,catalogue["lanes"]) for name,source,*_ in edges(graph)}
    for edge,options in catalogue["fifo_options"].items():
        for label,spec in options.items():
            parameters={"WIDTH":widths[edge],"DEPTH":spec["depth"],"MEMORY_STYLE":'"'+spec["memory"]+'"'}
            rtl=wrapped("stream_fifo",parameters,widths[edge],("fifo.sv",))
            evidence=characterize(rtl,target,cache)
            spec["estimated_resources"]=spec["resources"]
            spec["resources"]=evidence["resources"]
            spec["measurement"]={key:value for key,value in evidence.items() if key != "resources"}
    catalogue["resource_provenance"]="Exact RTL/target/tool keyed actor and FIFO synthesis; whole-design mapping and routing still required"
    return catalogue


def prune_fifos(catalogue):
    """Discard capacity/latency/resource dominated measured FIFO choices."""
    removed=0
    for edge,options in catalogue["fifo_options"].items():
        def dominates(left,right):
            resources=left["resources"].keys() | right["resources"].keys()
            return (left["depth"] >= right["depth"] and
                    (1 if left["depth"] == 1 else 2) <= (1 if right["depth"] == 1 else 2) and
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
            selected=spec.get("memories",{})
            keys=("weight","line","storage","line_layout","extra_rows","weight_block_depth")
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


def optimize(model,target,search,directory,cache,limits=Limits(),stage="schedule",progress=print):
    directory=Path(directory)
    directory.mkdir(parents=True,exist_ok=True)
    model=Path(model).resolve()
    digest=hashlib.sha256(model.read_bytes()).hexdigest()
    _,module=load(model)
    graph=actors(read(module),search.get("fusions",()),search["lanes"])
    catalogue=prepare(graph,model,digest,target,search)
    initial=json.loads(Path(search["initial_configuration"]).read_text()) if search.get("initial_configuration") else None
    if search.get("absorb_input_fifos"):
        if initial is None:
            raise ValueError("Input-buffer absorption requires an initial_configuration seed")
        initial=absorb_input_buffers(graph,catalogue,initial,target,search.get("absorbed_fifo_max_words",8))
    reuse_measured_costs(graph,catalogue,target,cache)
    (directory/"model.mlir").write_text(str(module))
    (directory/"search.json").write_text(json.dumps(search,indent=2)+"\n")
    (directory/"target.json").write_text(json.dumps(target,indent=2)+"\n")
    def save():
        (directory/"catalogue.json").write_text(json.dumps(catalogue,indent=2)+"\n")
    save()
    bound=solve(relaxation(catalogue,target),Limits(seconds=min(limits.seconds,10)))
    if bound.period is not None:
        retain(catalogue,bound,search["max_actor_options"],search.get("retention_period_slack",1.25))
        save()
    screen={"relaxation":summary(bound),"whole_design_verified":False,
            "optimistic_fps_bound":target["clock_hz"]/bound.period_bound if bound.period_bound>0 else None,
            "resource_evidence":catalogue["resource_provenance"],"screen":catalogue["screen"]}
    (directory/"screen.json").write_text(json.dumps(screen,indent=2)+"\n")
    if stage == "screen" or bound.period is None:
        return screen
    progress("Screen passed; characterize retained implementations with exact cache keys")
    measure(graph,catalogue,target,cache,progress)
    prune_fifos(catalogue)
    if initial is not None:
        catalogue["preferred_options"]=configuration_hints(catalogue,initial)
    if search.get("initial_schedule"):
        catalogue["initial_schedule"]=search["initial_schedule"]
    save()
    measured_bound=solve(relaxation(catalogue,target),Limits(seconds=min(limits.seconds,10)))
    (directory/"measured-bound.json").write_text(json.dumps(summary(measured_bound),indent=2)+"\n")
    if stage == "measure":
        return {"resource_provenance":catalogue["resource_provenance"],"catalogue":str(directory/"catalogue.json")}
    if measured_bound.period is None:
        return {"status":measured_bound.status,"stage":"measured_resource_screen",
                "scope":"Retained options only; broaden the input search before scheduling"}
    report=compile_network(graph,catalogue,target,directory/"schedule",limits)
    if report["solver_verified"] and target.get("characterize_netlist_mapping"):
        from .link import prepare as prepare_link
        configuration=json.loads((directory/"schedule/configuration.json").read_text())
        prepare_link(graph,configuration,target,cache,directory/"schedule/mapped")
        report["mapped_network"]=str(directory/"schedule/mapped")
        (directory/"schedule/report.json").write_text(json.dumps(report,indent=2)+"\n")
    return report
