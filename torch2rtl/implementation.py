"""Bounded physical implementation search over explicit legal clock choices."""

from pathlib import Path
import json
import math
import shutil
import sys

from .cache import write_json


def clock_choices(job, root):
    choices=job["clock_candidates"]
    if not isinstance(choices,list) or not choices:
        raise ValueError("clock_candidates must be a nonempty list")
    seen=set()
    for choice in choices:
        hz=choice["clock_hz"]
        if type(hz) is not int or hz<=0 or hz in seen:
            raise ValueError("Clock frequencies must be unique positive integers")
        if set(choice)-{"clock_hz","clock_rtl"}:
            raise ValueError("Each clock candidate needs only clock_hz and clock_rtl")
        (root/choice["clock_rtl"]).resolve(strict=True)
        seen.add(hz)
    attempts=job.get("implementation_attempts",min(2,len(choices)))
    margin=job.get("timing_margin",0.05)
    if type(attempts) is not int or not 1<=attempts<=len(choices):
        raise ValueError("implementation_attempts must be between one and the number of clocks")
    if not isinstance(margin,(float,int)) or not math.isfinite(margin) or not 0<=margin<1:
        raise ValueError("timing_margin must be a finite fraction between zero and one")
    return {choice["clock_hz"]:choice for choice in choices},attempts,margin


def rank_plans(plans, resources, feedback_hz=None):
    """Use routed feedback conservatively, without treating it as proof."""
    def key(plan):
        hz=plan["clock_hz"]
        predicted=plan["scheduled_fps"]*min(1,feedback_hz/hz) if feedback_hz else plan["scheduled_fps"]
        pressure=sum(plan.get("resources",{}).get(name,0)/limit for name,limit in resources.items() if limit)
        return (feedback_hz is not None and hz>feedback_hz,-round(predicted,4),pressure,hz)
    return sorted((plan for plan in plans if plan["solver_verified"]),key=key)


def implement_clocks(job,root,build,output,seconds,workers,run):
    choices,attempts,margin=clock_choices(job,root)
    if output.exists() and any(output.iterdir()):
        raise ValueError("Clock search output must be empty; preserve previous results in a separate directory")
    target=json.loads((root/job["target"]).read_text())
    search=json.loads((root/job["search"]).read_text())
    search={**search,"clock_candidates_hz":list(choices)}
    search_path=build/"clock-search.json"
    write_json(build/"job.json",job)
    write_json(search_path,search)
    run("compile",[sys.executable,"-m","torch2rtl","optimize-network",root/job["model"],
        "--target",root/job["target"],"--search",search_path,"--cache",root/job["cache"],
        "--stage","schedule","--seconds",seconds,"--workers",workers,"--output",build])
    plans=json.loads((build/"clock-plans.json").read_text())["clock_plans"]
    pending=rank_plans(plans,target["resources"])
    if not pending:
        raise ValueError("No clock candidate has an independently verified schedule")
    completed=[]
    feedback=None
    for attempt in range(attempts):
        if not pending:
            break
        plan=rank_plans(pending,target["resources"],feedback)[0]
        pending.remove(plan)
        location=Path(plan["directory"])
        choice=choices[plan["clock_hz"]]
        candidate={key:value for key,value in job.items()
                   if key not in {"clock_candidates","implementation_attempts","timing_margin"}}
        candidate.update(target=str(location/"target.json"),search=str(location/"search.json"),
                         clock_rtl=choice["clock_rtl"])
        write_json(location/"verification-job.json",candidate)
        print(f"[progress] Physical attempt {attempt+1}/{attempts}: {plan['clock_hz']/1e6:g} MHz",flush=True)
        run(f"implementation-{attempt+1}",[sys.executable,root/"scripts/compile-and-verify.py",
            "--job",location/"verification-job.json","--build",location,"--verify-only"])
        result=json.loads((location/"result/result.json").read_text())
        achieved=result["reported_fmax"][job["clock_net"]]["achieved"]*1e6
        completed.append({**plan,"result":str(location/"result"),"reported_fps":result["reported_fps"],
                          "bitstream_ready":result["bitstream_ready"],"achieved_clock_hz":achieved,
                          "performance_target_met":result["performance_target_met"]})
        # A throughput target is a reporting threshold unless early stopping
        # was explicitly requested, just as in the scheduling search.
        if search.get("stop_at_required_fps",False) and result["bitstream_ready"] and result["performance_target_met"]:
            break
        feedback=achieved*(1-margin)
        if result["bitstream_ready"]:
            pending=[candidate for candidate in pending if candidate["scheduled_fps"]>result["reported_fps"]]
    best=max(completed,key=lambda record:(record["bitstream_ready"],record["reported_fps"]))
    shutil.copytree(best["result"],output,dirs_exist_ok=True)
    report={"selected":best,"attempts":completed,"plans":plans,"retry_timing_margin":margin,
            "scope":"Bounded search. Each attempted clock uses its supplied RTL and a separately verified schedule; routed FPS is not a board measurement."}
    write_json(build/"implementation-search.json",report)
    write_json(output/"implementation-search.json",report)
    print((output/"summary.txt").read_text(),flush=True)
    print(f"Clock search report: {build/'implementation-search.json'}",flush=True)
