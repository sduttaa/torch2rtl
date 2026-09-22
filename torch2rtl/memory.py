"""Physical memory geometry supplied by the target, with explicit port demand.

These are mapping estimates, not a placement certificate. RTL characterization
replaces estimates before a measured catalogue is claimed.
"""

from collections import Counter
from dataclasses import asdict, dataclass
from math import ceil

from .convolution import configuration
from .ranges import storage_bits


@dataclass(frozen=True)
class Memory:
    name: str
    width: int
    depth: int
    read_ports: int = 1
    write_ports: int = 1
    style: str = "block"
    copies: int = 1


def mappings(memory, target):
    """Enumerate rectangular banks with adequate width, capacity and ports."""
    if min(memory.width,memory.depth,memory.read_ports,memory.copies) < 1 or memory.write_ports < 0:
        raise ValueError("Memory dimensions and read ports must be positive")
    result = []
    for mode in target["memory_modes"]:
        if mode["kind"] != memory.style:
            continue
        if min(mode["width"],mode["depth"],mode["read_ports"]) < 1 or mode["write_ports"] < 0:
            raise ValueError("Invalid target memory mode")
        if mode["read_ports"] < memory.read_ports or mode["write_ports"] < memory.write_ports:
            continue
        banks=ceil(memory.width/mode["width"])*ceil(memory.depth/mode["depth"])*memory.copies
        costs=mode["resources"]
        if any(type(cost) is not int or cost < 0 for cost in costs.values()):
            raise ValueError("Memory mode costs must be nonnegative integers")
        allocated=banks*mode["width"]*mode["depth"]
        payload=memory.width*memory.depth*memory.copies
        result.append({"mode":mode["name"],"banks":banks,
            "resources":{key:cost*banks for key,cost in costs.items()},
            "payload_bits":payload,"allocated_bits":allocated,
            "packing_efficiency":payload/allocated})
    if not result:
        raise ValueError(f"No supplied physical memory mode supports {memory.name}")
    return result


def allocation(memories,target):
    totals=Counter()
    records=[]
    order=target.get("resource_priority",["bram","lut","ff"])
    for memory in memories:
        selected=min(mappings(memory,target),key=lambda row:(
            tuple(row["resources"].get(key,0) for key in order),row["allocated_bits"]))
        totals.update(selected["resources"])
        records.append({**asdict(memory),**selected})
    return {"resources":dict(totals),"memories":records,"evidence":"geometry estimate"}


def actor_memories(value,lanes,spec):
    """Describe actual arrays in each selected template, including row copies."""
    memories=spec.get("memories",{})
    result=[]
    def add(name,width,depth,style="block",copies=1,write_ports=1):
        if depth and copies:
            result.append(Memory(name,width,depth,1,write_ports,
                                 "block" if style == "auto" else style,copies))
    op=value.operation
    if op in ("quantized_convolution","quantized_convolution_pool","quantized_view_convolution"):
        original=value
        if op == "quantized_view_convolution":
            from .fusion import geometry,materialized
            value=materialized(value)
            for index,g in enumerate(geometry(original,lanes,memories.get("extra_rows",0))):
                add(f"source_rows_{index}",g["width"],g["depth"],memories.get("line","block"))
        p=configuration(value,lanes,spec["output_lanes"],spec.get("reduction_lanes",lanes))
        blocks=p["GROUPS"]*ceil((p["OUTPUT_CHANNELS"]//p["GROUPS"])/p["OUTPUT_LANES"])
        dot=p["KERNEL_H"]*p["KERNEL_W"]*ceil((p["INPUT_CHANNELS"]//p["GROUPS"])/p["REDUCTION_LANES"])
        if memories.get("weight","block") != "logic":
            width=p["OUTPUT_LANES"]*p["REDUCTION_LANES"]*p["WEIGHT_BITS"]
            prefix=memories.get("weight_block_depth",blocks*dot)
            if type(prefix) is not int or not 0 < prefix <= blocks*dot:
                raise ValueError("Weight block prefix must be within the ROM")
            add("weights",width,prefix,
                memories.get("weight","block"),write_ports=0)
            if prefix < blocks*dot:
                add("weight_tail",width,blocks*dot-prefix,"logic",write_ports=0)
        if op != "quantized_view_convolution":
            height=(p["KERNEL_H"]-1)*p["DILATION_H"]+1+(p["POOL_H"]-1)*p["STRIDE_H"]
            width=(p["KERNEL_W"]-1)*p["DILATION_W"]+1+(p["POOL_W"]-1)*p["STRIDE_W"]
            words=ceil(p["INPUT_CHANNELS"]/lanes)
            bits=min(lanes,p["INPUT_CHANNELS"])*p["INPUT_BITS"]
            if memories.get("line_layout","parallel") in ("ring","ring_compact","prefetch"):
                span=((height-1)*(p["WIDTH"]+2*p["PAD_W"])+width)*words
                depth=span if memories["line_layout"]=="ring_compact" else 1 << (span-1).bit_length()
                bank=memories.get("line_bank_width")
                if bank is None:
                    add("window_ring",bits,depth,memories.get("line","block"))
                else:
                    if type(bank)is not int or bank<1:
                        raise ValueError("Line bank width must be positive")
                    for start in range(0,bits,bank):
                        add(f"window_ring_{start//bank}",min(bank,bits-start),depth,memories.get("line","block"))
            elif memories.get("line_layout","parallel") == "packed":
                add("lines",bits,(height-1)*p["WIDTH"]*words,memories.get("line","block"))
            else:
                add("lines",bits,p["WIDTH"]*words,memories.get("line","block"),height-1)
            taps=p["KERNEL_H"] if p["POOL_H"] == 1 else height
            if memories.get("line_layout","parallel") not in ("ring","ring_compact","prefetch"):
                add("horizontal",bits,width*words,"distributed",taps)
    elif op == "max_pool2d":
        data,kernel,stride,padding,dilation,ceil_mode=value.args
        if tuple(stride or kernel) != tuple(kernel) or any(padding) or tuple(dilation) != (1,1) or ceil_mode:
            raise ValueError("Memory catalogue currently covers nonoverlapping pooling")
        add("pool_row",min(lanes,data.tensor.shape[1])*storage_bits(value),
            (data.tensor.shape[3]//kernel[1])*ceil(data.tensor.shape[1]/lanes),memories.get("storage","block"))
    elif op == "__interpolate.size_list_scale_list":
        data=value.args[0]
        add("resize_rows",min(lanes,data.tensor.shape[1])*storage_bits(value),
            memories.get("row_buffers",1)*data.tensor.shape[3]*ceil(data.tensor.shape[1]/lanes),
            memories.get("storage","block"))
    elif op not in ("quantized_concat","byte_lookup"):
        raise ValueError(f"No memory contract for {op}")
    return result


def fifo_latency(depth):
    """Write-to-readable delay of the selected FIFO template, in edges."""
    return 1 if depth<=2 else 2


def fifo_memories(width,depth,style):
    return [] if depth <= 2 else [Memory("fifo",width,depth,style="block" if style == "auto" else style)]


def depth_candidates(width,maximum,target,small=(1,2,3,8)):
    """Include allocation boundaries, where changing depth can save a block."""
    if min(width,maximum) < 1:
        raise ValueError("Positive FIFO width and depth limit required")
    result={depth for depth in small if 1 <= depth <= maximum}
    result.add(maximum)
    for mode in target["memory_modes"]:
        if mode["kind"] == "block" and mode["read_ports"] >= 1 and mode["write_ports"] >= 1:
            for depth in range(mode["depth"],maximum+1,mode["depth"]):
                result.add(depth)
    return sorted(result)
