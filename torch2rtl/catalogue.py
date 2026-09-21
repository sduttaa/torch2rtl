"""Build bounded, generic actor/FIFO catalogues before expensive tool runs."""

from collections import Counter
from copy import deepcopy
import json
from functools import lru_cache
from itertools import product
from math import ceil, prod

from .convolution import configuration
from .memory import Memory, actor_memories, allocation, depth_candidates, fifo_memories
from .network import edges, fifo_width
from .spatial_schedule import window, words
from . import spatial_schedule


class Bounds:
    def __init__(self):
        self.period=1
    def series(self,prefix,count):
        return range(count)
    def link(self,*args,**kwargs):
        pass
    implied=link
    def period_bound(self,event,cycles):
        self.period=max(self.period,cycles)
    def order(self,events,delay=1):
        self.period=max(self.period,len(events)*delay)


@lru_cache(maxsize=128)
def window_gaps(value,lanes,layout):
    data,weight,_,stride,padding,dilation,*_=value.args
    kernel=weight.shape[2:]
    pool=value.args[12] if value.operation == "quantized_convolution_pool" else (1,1)
    if prod(pool)>1:
        kernel=tuple((size-1)*dil+1+(extent-1)*step for size,dil,extent,step in zip(kernel,dilation,pool,stride))
        stride=tuple(step*extent for step,extent in zip(stride,pool))
        dilation=(1,1)
    _,gaps=window(Bounds(),"bound",range(words(data.tensor,lanes)),data.tensor.shape,lanes,
        kernel,stride,padding,dilation,[(0,0)]*prod(value.tensor.shape[2:]),layout)
    return Counter(gaps)


def profile(value,lanes,spec,target):
    memories=actor_memories(value,lanes,spec)
    result=allocation(memories,target)
    resources=Counter(result["resources"])
    if value.operation in ("quantized_convolution","quantized_convolution_pool","quantized_view_convolution"):
        original=value
        if value.operation == "quantized_view_convolution":
            from .fusion import materialized
            value=materialized(value)
        p=configuration(value,lanes,spec["output_lanes"],spec.get("reduction_lanes",lanes),spec.get("requantization","auto"))
        mask=p["PRODUCT_MASK"].split("'h")[1]
        multiply=[mode for mode in target["multiplier_modes"]
                  if mode["input_bits"] >= 9 and mode.get("signed",False)]
        if not multiply:
            raise ValueError("Supply a resource model for signed nine-bit multiplication")
        selected=min(multiply,key=lambda mode:tuple(mode["resources"].get(k,0)
                     for k in target.get("resource_priority",["dsp","lut","ff"])))
        resources.update({key:cost*int(mask,16).bit_count() for key,cost in selected["resources"].items()})
        blocks=p["GROUPS"]*ceil((p["OUTPUT_CHANNELS"]//p["GROUPS"])/p["OUTPUT_LANES"])
        dot=p["KERNEL_H"]*p["KERNEL_W"]*ceil((p["INPUT_CHANNELS"]//p["GROUPS"])/p["REDUCTION_LANES"])
        pool=p["POOL_H"]*p["POOL_W"]
        extra=int(p["REDUCTION_LANES"]>1)
        quantizer=p["THRESHOLD_BITS"]+1 if p.get("THRESHOLD_BITS") else p["ACCUMULATOR_BYTES"]*ceil(p["MULTIPLIER_BYTES"]/p["REDUCTION_LANES"])+3
        tile=pool*(dot+2+extra)+quantizer+int(pool>1)
        release=pool*(dot+2)+(pool-1)*extra-2
        if original.operation == "quantized_view_convolution":
            period=prod(value.tensor.shape[2:])*(blocks*tile+1)
        else:
            gaps=window_gaps(value,lanes,spec.get("memories",{}).get("line_layout","parallel"))
            period=sum(count*(max(tile+1,release+gap) if blocks==1 else
                tile+max((blocks-1)*tile+1,(blocks-2)*tile+release+gap)) for gap,count in gaps.items())
        if spec.get("memories",{}).get("weight") == "logic":
            logic=allocation([Memory("logic_weights",p["OUTPUT_LANES"]*p["REDUCTION_LANES"]*p["WEIGHT_BITS"],
                               blocks*dot,write_ports=0,style="logic")],target)
            resources.update(logic["resources"])
            result["memories"]+=logic["memories"]
        result.update(weight_depth=blocks*dot,weight_width=p["OUTPUT_LANES"]*p["REDUCTION_LANES"]*p["WEIGHT_BITS"])
    else:
        from .graph import references
        bounds=Bounds()
        inputs=[range(words(source.tensor,lanes)) for source in references(value.args)]
        outputs=range(words(value.tensor,lanes))
        if value.operation == "max_pool2d":
            spatial_schedule.pool(bounds,"bound",value,inputs[0],outputs,lanes)
        elif value.operation == "__interpolate.size_list_scale_list":
            spatial_schedule.resize(bounds,"bound",value,inputs[0],outputs,lanes,spec.get("memories",{}).get("row_buffers",1))
        elif value.operation == "quantized_concat":
            spatial_schedule.concatenate(bounds,value,inputs,outputs,lanes)
        else:
            bounds.period_bound(0,len(outputs))
        period=bounds.period
    result.update(resources=dict(resources),period_bound=period,
                  resource_coverage="Memory geometry and multiplier slots only; characterize RTL for complete costs")
    result["memory_report"]=result.pop("memories")
    return result


def candidates(value,lanes,search):
    convolution=value.operation in ("quantized_convolution","quantized_convolution_pool","quantized_view_convolution")
    if convolution:
        from .fusion import materialized
        conv=materialized(value) if value.operation == "quantized_view_convolution" else value
        channels=conv.tensor.shape[1]//conv.args[6]
        outputs=[n for n in search["output_lanes"] if 1 <= n <= channels]
        reductions=[n for n in search["reduction_lanes"] if n > 0 and lanes%n==0]
        layouts=("shared",) if value.operation == "quantized_view_convolution" else search["line_layouts"]
        extra_rows=search.get("extra_rows",[0]) if layouts == ("shared",) else [0]
        if layouts == ("shared",) and search.get("source_buffer_depths"):
            from .fusion import geometry
            per_input=[]
            for g in geometry(value,lanes):
                sizes=set(extra_rows)
                sizes.update(max(0,depth//g["row_words"]-g["rows"]) for depth in search["source_buffer_depths"])
                per_input.append(sorted(sizes))
            extra_rows=list(product(*per_input))
        for output,reduction,layout,weight,line,extra,requantization in product(outputs,reductions,layouts,
                search["weight_memories"],search.get("line_memories",["block"]),extra_rows,
                search.get("requantizations",["auto"])):
            memories={"weight":weight,"line":line}
            memories.update({"extra_rows":extra} if layout == "shared" else {"line_layout":layout})
            suffix="" if requantization=="auto" else "_"+requantization
            row_name=str(extra) if type(extra) is int else "-".join(map(str,extra))
            yield f"out{output}_reduce{reduction}_{layout}_{weight}_{line}_rows{row_name}"+suffix,{
                "output_lanes":output,"reduction_lanes":reduction,"memories":memories,
                "requantization":requantization}
    elif value.operation == "__interpolate.size_list_scale_list":
        for rows,style in product(search["row_buffers"],search.get("storage_memories",["block"])):
            yield f"rows{rows}_{style}",{"memories":{"row_buffers":rows,"storage":style}}
    elif value.operation == "max_pool2d":
        for style in search.get("storage_memories",["block"]):
            yield style,{"memories":{"storage":style}}
    else:
        yield "stream",{}


def prepare(graph,model,model_hash,target,search):
    lanes=search["lanes"]
    if any(type(search[key]) is not int or search[key]<1 for key in
           ("lanes","max_actor_options","fifo_max_words","period_limit","offset_limit")):
        raise ValueError("Positive integer search limits are required")
    actor_options={}
    considered={}
    for value in graph.values:
        if value is graph.input:
            continue
        options={}
        for name,spec in candidates(value,lanes,search):
            try:
                cost=profile(value,lanes,spec,target)
            except ValueError:
                continue
            options[name]={**spec,**cost}
            if search.get("hybrid_weights") and spec.get("memories",{}).get("weight") == "block":
                for mode in target["memory_modes"]:
                    if mode["kind"] != "block" or mode["read_ports"] < 1:
                        continue
                    prefix=(cost["weight_depth"]//mode["depth"])*mode["depth"]
                    if 0 < prefix < cost["weight_depth"]:
                        variant={**spec,"memories":{**spec["memories"],"weight_block_depth":prefix}}
                        options[name+f"_prefix{prefix}"]={**variant,**profile(value,lanes,variant,target),"base_option":name}
        considered[value.name]=len(options)
        actor_options[value.name]={name:spec for name,spec in options.items()
                                  if spec["period_bound"] <= search["period_limit"] and all(
                                      spec["resources"].get(key,0)<=budget for key,budget in target["resources"].items())}
        if not actor_options[value.name]:
            raise ValueError(f"No implementation of {value.name} meets the supplied period/resource screen")
    fifo_options={}
    channels=edges(graph)
    fanout=Counter(source for _,source,*_ in channels)
    fanin=Counter(destination for _,_,destination,_ in channels)
    linear_limit=search.get("fifo_linear_max_words",search["fifo_max_words"])
    if type(linear_limit) is not int or linear_limit < 1:
        raise ValueError("Linear FIFO search limit must be positive")
    for name,source,destination,_ in channels:
        width=fifo_width(source,lanes)
        maximum=min(search["fifo_max_words"],words(source.tensor,lanes))
        if fanout[source] == 1 and fanin[destination] == 1:
            maximum=min(maximum,linear_limit)
        options={}
        for depth in depth_candidates(width,maximum,target,search["fifo_small_depths"]):
            for style in search["fifo_memories"]:
                cost=allocation(fifo_memories(width,depth,style),target)
                label=f"depth{depth}_{style}"
                options[label]={"depth":depth,"memory":style,**cost}
        # Equal depth/latency: keep each resource tradeoff, dropping duplicate
        # representations only. Depth itself can change global branch behavior.
        fifo_options[name]={}
        signatures=set()
        for label,spec in options.items():
            signature=(spec["depth"],tuple(sorted(spec["resources"].items())))
            if signature not in signatures and all(spec["resources"].get(k,0)<=v for k,v in target["resources"].items()):
                fifo_options[name][label]=spec
                signatures.add(signature)
        # Within the geometry screen equal memory costs and latency favor the
        # larger capacity. Complete FF/control costs are measured subsequently.
        best={}
        for label,spec in fifo_options[name].items():
            signature=(1 if spec["depth"] == 1 else 2,tuple(sorted(spec["resources"].items())))
            if signature not in best or spec["depth"]>best[signature][1]["depth"]:
                best[signature]=(label,spec)
        fifo_options[name]=dict(best.values())
    return {"model":str(model),"model_sha256":model_hash,"lanes":lanes,
        "fusions":search.get("fusions",[]),"period_limit":search["period_limit"],
        "offset_limit":search["offset_limit"],"actor_options":actor_options,"fifo_options":fifo_options,
        "fixed_resources":search.get("fixed_resources",{}),"resource_provenance":"geometry estimates; complete RTL characterization required",
        "screen":{"considered_actor_options":considered,"max_actor_options":search["max_actor_options"],
                  "fifo_linear_max_words":linear_limit,
                  "scope":"Heuristic catalogue screen; joint CP-SAT optimality applies only to retained options"}}


def absorb_input_buffers(graph,catalogue,configuration,target,maximum_fifo_depth=8):
    """Offer a bounded storage-retiming candidate derived from an input seed.

    A view already stores a random-access source window. Move a large incoming
    queue into that storage, rounding its capacity down to whole source rows.
    This is a search restriction, never a feasibility claim: CP-SAT must check
    the resulting lifetimes, frame boundaries, and remaining small FIFOs.
    """
    from .fusion import geometry
    if configuration.get("model_sha256") != catalogue["model_sha256"]:
        raise ValueError("Storage-retiming seed belongs to different model contents")
    if type(maximum_fifo_depth) is not int or maximum_fifo_depth<1:
        raise ValueError("Retimed FIFO depth limit must be positive")
    hint=deepcopy(configuration)
    channels=edges(graph)
    absorbed={}
    for value in graph.values:
        if value.operation != "quantized_view_convolution":
            continue
        base=geometry(value,catalogue["lanes"])
        existing=geometry(value,catalogue["lanes"],
                          configuration.get("memories",{}).get(value.name,{}).get("extra_rows",0))
        inputs={}
        for edge,source,destination,port in channels:
            if destination is not value:
                continue
            old=edge if edge in configuration["fifo_depths"] else None
            if old is None:
                matches=[name for name in configuration["fifo_depths"] if name.split("->")[0]==source.name]
                if len(matches)==1:old=matches[0]
            depth=configuration["fifo_depths"].get(old,1)
            capacity=max(depth,existing[port]["depth"])
            queued=depth>base[port]["depth"] and depth>=2*base[port]["row_words"]
            retained=existing[port]["rows"]>=2*base[port]["rows"]
            if queued or retained:
                inputs[port]=capacity//base[port]["row_words"]-base[port]["rows"]
                absorbed[edge]={"source_rows":base[port]["rows"]+inputs[port],"previous_fifo_depth":depth}
        if not inputs:
            continue
        def rows(extra):
            result=[extra]*len(base) if type(extra)is int else list(extra)
            for port,count in inputs.items():result[port]=count
            return result
        variants={}
        for label,old in catalogue["actor_options"][value.name].items():
            spec={key:deepcopy(old[key]) for key in ("output_lanes","reduction_lanes","memories","requantization") if key in old}
            spec["memories"]["extra_rows"]=rows(spec["memories"].get("extra_rows",0))
            signature=json.dumps(spec,sort_keys=True)
            if signature not in variants:
                variants[signature]=(label+"_buffered",{**spec,**profile(value,catalogue["lanes"],spec,target)})
        catalogue["actor_options"][value.name]=dict(variants.values())
        memories=hint.setdefault("memories",{}).setdefault(value.name,{})
        memories["extra_rows"]=rows(memories.get("extra_rows",0))
    for edge in absorbed:
        options={name:spec for name,spec in catalogue["fifo_options"][edge].items() if spec["depth"]<=maximum_fifo_depth}
        if not options:
            raise ValueError("Include small FIFO depths when requesting input-buffer absorption")
        catalogue["fifo_options"][edge]=options
        hint["fifo_depths"][edge]=max(spec["depth"] for spec in options.values())
    catalogue["storage_retiming"]={"absorbed_edges":absorbed,"scope":"Candidate only; complete schedule verification required"}
    return hint


def retain(catalogue,solution,limit,period_slack=1.25):
    """Keep a globally resource-balanced seed plus neighboring implementations."""
    for actor,options in catalogue["actor_options"].items():
        selected=solution.selected["actor:"+actor]
        seed=options[selected]
        if len(options) <= limit:
            continue
        if period_slack < 1:
            raise ValueError("Catalogue period slack must be at least one")
        def compute(spec):
            return (spec.get("output_lanes",0),spec.get("reduction_lanes",0))
        def memory_key(name):
            spec=options[name]
            extra=spec.get("memories",{}).get("extra_rows",0)
            return (spec["resources"].get("bram",0),spec["resources"].get("lut",0),
                    -(extra if type(extra) is int else sum(extra)),
                    -spec.get("memories",{}).get("row_buffers",1),
                    spec["period_bound"],name)
        eligible=[name for name,spec in options.items()
                  if spec["period_bound"] <= solution.period*period_slack]
        shapes=[compute(seed)]
        # Fewer output accumulators often save control, requantization and ROM
        # banks. Keep that tradeoff even when its DSP count differs from seed.
        for order in (
            lambda name:(compute(options[name])[0],options[name]["period_bound"],memory_key(name)),
            lambda name:(options[name]["resources"].get("dsp",0),options[name]["period_bound"],memory_key(name)),
        ):
            if eligible:
                shape=compute(options[min(eligible,key=order)])
                if shape not in shapes:
                    shapes.append(shape)
        keys=[selected]
        for shape in shapes:
            matched=[name for name in eligible if compute(options[name]) == shape]
            # Cross each compute choice with storage choices. A logic-only
            # low-lane option cannot rescue a LUT-constrained implementation.
            for style in ("block","logic"):
                group=[name for name in matched if options[name].get("memories",{}).get("weight") == style
                       and "weight_block_depth" not in options[name].get("memories",{})]
                if group:
                    for quantizer in sorted({options[name].get("requantization","auto") for name in group}):
                        candidate=min((name for name in group if options[name].get("requantization","auto")==quantizer),key=memory_key)
                        if candidate not in keys:keys.append(candidate)
        hybrids=[name for name,spec in options.items() if name not in keys and compute(spec) in shapes
                 and spec.get("base_option") in options and
                 spec["resources"].get("bram",0) < options[spec["base_option"]]["resources"].get("bram",0)]
        hybrids.sort(key=lambda name:(
            options[name]["resources"].get("bram",0)-options[options[name]["base_option"]]["resources"].get("bram",0),
            options[name]["resources"].get("lut",0)-options[options[name]["base_option"]]["resources"].get("lut",0),
            memory_key(name)))
        keys+=hybrids[:max(0,limit-len(keys))]
        # Preserve row-lifetime and line-port alternatives around these shapes.
        nearby=sorted((name for name in options if name not in keys),key=lambda name:(
            compute(options[name]) not in shapes,
            options[name].get("memories",{}).get("extra_rows",0) == 0,
            abs(options[name]["period_bound"]-solution.period),memory_key(name)))
        keys+=nearby[:max(0,limit-len(keys))]
        catalogue["actor_options"][actor]={name:options[name] for name in keys[:limit]}
    catalogue["screen"]["seed_period_bound"]=solution.period
    return catalogue
