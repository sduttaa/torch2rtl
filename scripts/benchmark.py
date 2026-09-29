#!/usr/bin/env python3
"""Export and compile small input-defined models; expensive tools are opt-in."""

import argparse
import gzip
import hashlib
import json
from pathlib import Path
import subprocess
import sys
from time import monotonic

root=Path(__file__).resolve().parents[1]
sys.path.insert(0,str(root))
import torch

from benchmarks.models import IntegerGraph
from torch2rtl.cache import write_json
from torch2rtl.catalogue import prepare, retain
from torch2rtl.cp_sat import solve
from torch2rtl.flow import counters
from torch2rtl.frontend import load
from torch2rtl.graph import actors, evaluate, read
from torch2rtl.optimize import optimize, relaxation
from torch2rtl.schedule import Limits
from torch2rtl.simulation import pack, simulate
from torch2rtl.spatial_compile import compile_network


def run_case(case,target,search,directory,cache,mode,limits,physical_job=None):
    started=monotonic()
    before=counters()
    directory.mkdir(parents=True,exist_ok=True)
    search={**search,**case.get("search",{})}
    model=IntegerGraph(case).eval()
    generator=torch.Generator().manual_seed(case["seed"])
    if case["frames"]<3:
        raise ValueError("Benchmarks require at least three consecutive frames")
    images=[torch.randint(0,256,case["shape"],generator=generator,dtype=torch.uint8) for _ in range(case["frames"])]
    exported=torch.export.export(model,(images[0],),strict=True)
    model_path=directory/"model.pt2"
    torch.export.save(exported,model_path)
    _,module=load(model_path)
    graph=actors(read(module),search.get("fusions",()),search["lanes"])
    if mode=="quick":
        catalogue=prepare(graph,model_path,hashlib.sha256(model_path.read_bytes()).hexdigest(),target,search)
        bound=solve(relaxation(catalogue,target),limits)
        if bound.period is None:
            raise ValueError(f"Analytical screening failed: {bound.status}")
        retain(catalogue,bound,search["max_actor_options"],search.get("retention_period_slack",1.25))
        report=compile_network(graph,catalogue,target,directory/"schedule",limits)
        write_json(directory/"schedule/report.json",report)
    else:
        report=optimize(model_path,target,search,directory,cache,limits)
    if not report.get("solver_verified"):
        raise ValueError(f"No verified schedule: {report.get('status',report.get('solution'))}")
    lanes=search["lanes"]
    inputs,outputs=[],[]
    for image in images:
        expected=model(image)
        if not torch.equal(expected,evaluate(graph,image)):
            raise ValueError("Frontend/fusion result differs from exported PyTorch model")
        for data,words in ((image,inputs),(expected,outputs)):
            words.extend(word for pixel in data.permute(0,2,3,1).reshape(-1,data.shape[1]) for word in pack(pixel,8,lanes))
    with gzip.open(directory/"schedule/offsets.jsonl.gz","rt") as stream:
        offsets=dict(json.loads(line) for line in stream)
    period=report["solution"]["period"]
    transfers=[]
    for value,count in ((graph.input,len(inputs)//len(images)),(graph.output,len(outputs)//len(images))):
        transfers.append([3+frame*period+offsets[f"{value.name}.out.{index}"]
                          for frame in range(len(images)) for index in range(count)])
    rtl=(directory/"schedule/inference.sv").read_text()
    maximum=max(*transfers[0],*transfers[1])+10
    simulate(directory/"scheduled",rtl,lanes*8,lanes*8,inputs,outputs,False,maximum,tuple(transfers))
    simulate(directory/"backpressure",rtl,lanes*8,lanes*8,inputs,outputs,True,maximum*4)
    simulate(directory/"reset",rtl,lanes*8,lanes*8,inputs,outputs,True,maximum*4,reset_after=17)
    result={"name":case["name"],"passed":True,"mode":mode,"model_sha256":hashlib.sha256(model_path.read_bytes()).hexdigest(),
            "bit_exact_frames":len(images),"backpressure":True,"midstream_reset":True,
            "period_cycles":period,"scheduled_fps":target["clock_hz"]/period,
            "solver_status":report["solution"]["status"],
            "input_identity":hashlib.sha256(json.dumps({"case":case,"target":target,"search":search},sort_keys=True).encode()).hexdigest(),
            "latency_cycles":transfers[1][len(outputs)//len(images)-1]-transfers[0][0]+1,
            "resources":report["solution"]["resources"],
            "resource_evidence":"analytical estimates" if mode=="quick" else "isolated actor synthesis/packing",
            "routed_fps":None,"routed_resources":None,"physical_board_measured":False}
    if mode=="route":
        job=physical_job
        with (directory/"mapping-proofs.log").open("w") as log:
            subprocess.run([sys.executable,str(root/"scripts/prove-mapped-network.py"),"--mapped",str(directory/"schedule/mapped"),
                            "--output",str(directory/"proofs")],cwd=root,stdout=log,stderr=subprocess.STDOUT,check=True)
        command=[sys.executable,root/"scripts/route-smoke.py","--mapped-network",directory/"schedule/mapped",
                 "--input-bits",str(lanes*8),"--output-bits",str(lanes*8),"--target",directory/"target.json",
                 "--constraints",root/job["constraints"],"--clock-rtl",root/job["clock_rtl"],
                 "--reference-clock-hz",str(job["reference_clock_hz"]),"--output",directory/"route"]
        with (directory/"route.log").open("w") as log:
            subprocess.run(list(map(str,command)),cwd=root,stdout=log,stderr=subprocess.STDOUT,check=True)
        flow=json.loads((directory/"route/toolflow-summary.json").read_text())
        achieved=flow["fmax"][job["clock_net"]]["achieved"]*1e6
        capacity=json.loads((directory/"route/capacity.json").read_text())
        result.update(routed_fps=min(target["clock_hz"],achieved)/period,
                      routed_resources=flow["utilization"],routed_logic_sites=capacity["routed_logic_sites"],
                      timing_met=flow["tool_timing_checks_passed"],
                      timing_scope="Tool timing estimate; benchmark does not establish vendor timing-model coverage or board operation")
    result["elapsed_seconds"]=monotonic()-started
    result["actor_tool_jobs"]={key:value-before.get(key,0) for key,value in counters().items()}
    result["whole_design_route_jobs"]=int(mode=="route")
    write_json(directory/"benchmark.json",result)
    return result


def main():
    parser=argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--cases",type=Path,default=root/"benchmarks/cases.json")
    parser.add_argument("--target",type=Path,required=True)
    parser.add_argument("--search",type=Path,default=root/"benchmarks/search.json")
    parser.add_argument("--output",type=Path,required=True)
    parser.add_argument("--cache",type=Path)
    parser.add_argument("--mode",choices=("quick","measure","route"),default="quick")
    parser.add_argument("--physical-job",type=Path,help="Complete job with clock RTL and pin constraints, required for routing")
    parser.add_argument("--seconds",type=float,default=20)
    args=parser.parse_args()
    if args.mode=="route" and args.physical_job is None:
        parser.error("--mode route requires --physical-job")
    args.output=args.output.resolve()
    cases=json.loads(args.cases.read_text())
    names=[case["name"] for case in cases]
    if len(set(names))!=len(names) or any(Path(name).name!=name or name in {".",".."} for name in names):
        raise ValueError("Case names must be unique directory names")
    target=json.loads(args.target.read_text())
    search=json.loads(args.search.read_text())
    job=json.loads(args.physical_job.read_text()) if args.physical_job else None
    results=[]
    for case in cases:
        print(f"[progress] Benchmark {case['name']}: {args.mode}",flush=True)
        started=monotonic()
        try:
            result=run_case(case,target,search,args.output/case["name"],args.cache or args.output/"cache",
                            args.mode,Limits(seconds=args.seconds),job)
        except Exception as error:
            result={"name":case["name"],"passed":False,"error":str(error),"elapsed_seconds":monotonic()-started}
            write_json(args.output/case["name"]/"benchmark.json",result)
        results.append(result)
        write_json(args.output/"report.json",{"cases":results,"all_passed":all(item["passed"] for item in results)})
        print(f"[progress] {case['name']}: {'PASS' if result['passed'] else result['error']}",flush=True)
    print(f"Report: {args.output/'report.json'}")
    return 0 if all(result["passed"] for result in results) else 1


if __name__=="__main__":
    raise SystemExit(main())
