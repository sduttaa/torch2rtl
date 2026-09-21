"""Preserve characterized actor mappings when assembling a physical network."""

from copy import deepcopy
import hashlib
import json
from pathlib import Path

from .flow import characterize
from .network import actor_rtl, edges, emit, fifo_width
from .spatial import wrapped


def internal_module(module):
    """Remove isolated top-level pads before connecting an actor internally."""
    module=deepcopy(module)
    aliases={}
    for name,cell in list(module["cells"].items()):
        if cell["type"] in ("IBUF","OBUF"):
            connections=cell["connections"]
            if set(connections) != {"I","O"} or any(len(bits) != 1 for bits in connections.values()):
                raise ValueError("Unexpected actor pad interface")
            aliases[connections["O"][0]]=connections["I"][0]
            del module["cells"][name]
    def bits(items):
        result=[]
        for bit in items:
            seen=set()
            while bit in aliases:
                if bit in seen:
                    raise ValueError("Cyclic pad aliases")
                seen.add(bit)
                bit=aliases[bit]
            result.append(bit)
        return result
    for group in (module["ports"],module["netnames"]):
        for item in group.values():
            item["bits"]=bits(item["bits"])
    for cell in module["cells"].values():
        cell["connections"]={name:bits(items) for name,items in cell["connections"].items()}
    module["attributes"].pop("top",None)
    return module


def prepare(graph,configuration,target,cache,directory):
    """Emit a structural wrapper and exactly keyed, already mapped modules."""
    if target["synthesis"]["command"] != "synth_gowin":
        raise ValueError("Mapped linking currently supports Gowin actor pads")
    directory=Path(directory)
    directory.mkdir(parents=True,exist_ok=True)
    lanes=configuration["lanes"]
    modules,interfaces,evidence={},{},{}
    def add(name,rtl):
        record=characterize(rtl,target,cache)
        path=Path(record.get("netlist_path",str(Path(record["cache_path"])/"netlist.json")))
        if not path.exists():
            path=path.with_name("registered.json")
        module=internal_module(json.loads(path.read_text())["modules"]["inference"])
        modules[name]=module
        interfaces[name]={"attributes":{"blackbox":"1"},"ports":module["ports"],"cells":{},"netnames":{}}
        evidence[name]={**record,"netlist_path":str(path.resolve()),
                        "netlist_sha256":hashlib.sha256(path.read_bytes()).hexdigest()}
    for index,value in enumerate(graph.values):
        if value is graph.input:
            continue
        add(f"actor_{index}",actor_rtl(value,lanes,configuration["output_lanes"].get(value.name),
            configuration.get("memories",{}).get(value.name),configuration.get("reduction_lanes",{}).get(value.name),
            configuration.get("requantizations",{}).get(value.name,"auto")))
    for index,(name,source,*_) in enumerate(edges(graph)):
        width=fifo_width(source,lanes)
        parameters={"WIDTH":width,"DEPTH":configuration["fifo_depths"][name],
                    "MEMORY_STYLE":'"'+configuration.get("fifo_memories",{}).get(name,"auto")+'"'}
        add(f"fifo_actor_{index}",wrapped("stream_fifo",parameters,width,("fifo.sv",)))
    structure=emit(graph,lanes,configuration["output_lanes"],configuration["fifo_depths"],
        configuration.get("memories"),configuration.get("reduction_lanes"),configuration.get("fifo_memories"),
        external_modules=True)
    (directory/"structure.sv").write_text(structure)
    for name,items in (("modules",modules),("interfaces",interfaces)):
        (directory/(name+".json")).write_text(json.dumps({"modules":items})+"\n")
    (directory/"evidence.json").write_text(json.dumps(evidence,indent=2)+"\n")
    return evidence
