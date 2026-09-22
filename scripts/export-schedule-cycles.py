"""Export exact boundary transfer times for a saved periodic CP-SAT solution."""

import argparse
import gzip
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from torch2rtl.frontend import load
from torch2rtl.graph import actors, read
from torch2rtl.spatial_schedule import words

parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument("--schedule",type=Path,required=True)
parser.add_argument("--frames",type=int,required=True)
args=parser.parse_args()
if args.frames<1:
    parser.error("Frame count must be positive")
configuration=json.loads((args.schedule/"configuration.json").read_text())
report=json.loads((args.schedule/"report.json").read_text())
model=Path(configuration["model"])
if hashlib.sha256(model.read_bytes()).hexdigest()!=configuration["model_sha256"]:
    raise ValueError("Configuration refers to different model contents")
if not report["solver_verified"]:
    raise ValueError("A verified feasible schedule is required")
_,module=load(model)
graph=actors(read(module),configuration.get("fusions",()),configuration["lanes"])
streams={label:(value.name+".out.",words(value.tensor,configuration["lanes"]))
         for label,value in (("input",graph.input),("output",graph.output))}
offsets={label:{} for label in streams}
with gzip.open(args.schedule/"offsets.jsonl.gz","rt") as source:
    for line in source:
        name,offset=json.loads(line)
        for label,(prefix,_) in streams.items():
            if name.startswith(prefix):
                offsets[label][int(name[len(prefix):])]=offset
period=report["solution"]["period"]
last=0
for label,(_,count) in streams.items():
    if set(offsets[label])!=set(range(count)):
        raise ValueError("Incomplete boundary offsets")
    cycles=[3+frame*period+offsets[label][index] for frame in range(args.frames) for index in range(count)]
    if any(right<=left for left,right in zip(cycles,cycles[1:])):
        raise ValueError("Transfer times must strictly increase")
    (args.schedule/(label+"_cycles.hex")).write_text("".join(f"{cycle:x}\n" for cycle in cycles))
    last=max(last,cycles[-1])
print(json.dumps({"period":period,"frames":args.frames,"outputs_per_frame":streams["output"][1],
                  "max_cycles":last+10},indent=2))
