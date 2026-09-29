#!/usr/bin/env python3
"""Compile an exported PyTorch model and print its verified resource/FPS report.

The physical harness currently uses the Gowin tool flow. Board/model choices,
timing evidence, accuracy thresholds and output locations are supplied as data.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile
from threading import Thread
from time import monotonic

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from torch2rtl.cache import write_json


def load_job(location,root):
    job=json.loads(location.read_text())
    setup=job.pop("setup",None)
    if setup is not None:
        defaults=json.loads((root/setup).read_text())
        if "setup" in defaults:
            raise ValueError("A setup file must contain complete settings, not another setup reference")
        job={**defaults,**job}
    return job


parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument("--job",type=Path,required=True,help="Model, target, search, toolflow and verification inputs")
parser.add_argument("--build",type=Path,help="Build directory; default: a fresh directory under build/")
parser.add_argument("--output",type=Path,help="Result directory; default: result/ inside the build directory")
parser.add_argument("--seconds",type=float,default=600,help="Solver time limit per solve (default: 600)")
parser.add_argument("--workers",type=int,default=1)
parser.add_argument("--verify-only",action="store_true",help="Check an existing compile with matching model, target and search inputs")
args=parser.parse_args()
if args.verify_only and args.build is None:
    parser.error("--verify-only requires --build")
root=Path(__file__).resolve().parents[1]
job=load_job(args.job,root)
if args.build is None:
    (root/"build").mkdir(exist_ok=True)
    build=Path(tempfile.mkdtemp(prefix="compile-",dir=root/"build"))
else:
    build=args.build.resolve()
output=args.output.resolve() if args.output else build/"result"
build.mkdir(parents=True,exist_ok=True)
(build/"logs").mkdir(exist_ok=True)
print(f"Build directory: {build}",flush=True)


def path(name):
    return (root/job[name]).resolve(strict=True)


def read(location):
    return json.loads(location.read_text())


phase_seconds={}


def run(name,command,env=None):
    log_path=build/"logs"/(name+".log")
    started=monotonic()
    print(f"[{name}] started; log: {log_path}",flush=True)
    environment=dict(os.environ if env is None else env)
    environment["PYTHONUNBUFFERED"]="1"
    with log_path.open("w") as log, subprocess.Popen(
            [str(item) for item in command],cwd=root,stdout=subprocess.PIPE,
            stderr=subprocess.STDOUT,text=True,errors="replace",env=environment) as process:
        def relay():
            for line in process.stdout:
                log.write(line)
                if line.startswith("[progress] "):
                    log.flush()
                    print(f"[{name}] {line[len('[progress] '):].rstrip()}",flush=True)
                elif name.startswith("implementation-") and line.startswith("["):
                    log.flush()
                    print(line.rstrip(),flush=True)
        reader=Thread(target=relay,daemon=True)
        reader.start()
        try:
            while True:
                try:
                    process.wait(timeout=15)
                    break
                except subprocess.TimeoutExpired:
                    print(f"[{name}] running ({monotonic()-started:.0f}s elapsed)",flush=True)
        except BaseException:
            process.kill()
            process.wait()
            raise
        finally:
            reader.join()
    elapsed=monotonic()-started
    phase_seconds[name]=elapsed
    write_json(build/"phase-metrics.json",phase_seconds)
    if process.returncode:
        raise SystemExit(f"[{name}] failed after {elapsed:.1f}s (exit {process.returncode}); see {log_path}")
    print(f"[{name}] completed in {elapsed:.1f}s",flush=True)


def script(name):
    return [sys.executable,root/"scripts"/(name+".py")]


model_hash=hashlib.sha256(path("model").read_bytes()).hexdigest()
reference=read(path("vectors")/"reference.json")
accuracy=read(path("accuracy_evidence"))
if model_hash!=reference["model_sha256"] or model_hash!=accuracy["model_sha256"]:
    raise ValueError("Reference and accuracy evidence must describe the supplied model")
if reference["frames"]<3 or not accuracy["validation_dice"]>=job["minimum_accuracy"]:
    raise ValueError("Insufficient verification frames or model accuracy")
if job.get("clock_candidates"):
    if args.verify_only:
        parser.error("--verify-only requires a single resolved clock job")
    from torch2rtl.implementation import implement_clocks
    implement_clocks(job,root,build,output,args.seconds,args.workers,run)
    raise SystemExit(0)

if not args.verify_only:
    run("compile",[sys.executable,"-m","torch2rtl","optimize-network",path("model"),
        "--target",path("target"),"--search",path("search"),"--cache",root/job["cache"],
        "--stage","schedule","--seconds",args.seconds,"--workers",args.workers,"--output",build])
target=read(path("target"))
if target!=read(build/"target.json") or read(path("search"))!=read(build/"search.json"):
    raise ValueError("Compile inputs differ from the verification job")
config=read(build/"schedule/configuration.json")
if model_hash!=config["model_sha256"]:
    raise ValueError("Compiled model differs from the verification job")
report=read(build/"schedule/report.json")
if not report["solver_verified"]:
    raise ValueError("An independently verified schedule is required")
(build/"job.json").write_text(json.dumps(job,indent=2)+"\n")
run("transfer-cycles",script("export-schedule-cycles")+[
    "--schedule",build/"schedule","--frames",reference["frames"]])
cycles=read(build/"logs/transfer-cycles.log")
# Spatial networks currently have byte lanes at both boundary ports.
bits=config["lanes"]*8
run("simulation",script("simulate-rtl")+[
    "--rtl",build/"schedule/inference.sv","--input",path("vectors")/"input.hex",
    "--expected",path("vectors")/"expected.hex","--input-bits",bits,"--output-bits",bits,
    "--outputs-per-frame",cycles["outputs_per_frame"],"--max-cycles",cycles["max_cycles"],
    "--input-cycles",build/"schedule/input_cycles.hex","--output-cycles",build/"schedule/output_cycles.hex",
    "--output",build/"simulation"])
run("mapping-proofs",script("prove-mapped-network")+[
    "--mapped",build/"schedule/mapped","--output",build/"proofs"])
run("route",script("route-smoke")+[
    "--mapped-network",build/"schedule/mapped","--input-bits",bits,"--output-bits",bits,
    "--target",path("target"),"--constraints",path("constraints"),"--clock-rtl",path("clock_rtl"),
    "--reference-clock-hz",job["reference_clock_hz"],"--output",build/"route"])
run("dsp-guard",[sys.executable,path("timing_guard"),"--netlist",build/"route/linked-flat.json",
    "--target",path("target"),"--timing",path("timing_table"),"--output",build/"route/dsp-timing-guard.json"])
audit_environment=os.environ.copy()
if job.get("pin_audit_pythonpath"):
    audit_environment["PYTHONPATH"]=os.pathsep.join(str((root/item).resolve(strict=True)) for item in job["pin_audit_pythonpath"])
run("pin-audit",[path("pin_audit_python") if job.get("pin_audit_python") else sys.executable,path("pin_audit"),"--generator",path("database_generator"),
    "--timing",path("timing_table"),"--family",target["place_route"]["family"],
    "--packed-netlist",build/"route/packed.json","--output",build/"route/pin-coverage.json"],env=audit_environment)
run("package",script("package-network-result")+[
    "--build",build,"--vectors",path("vectors"),"--accuracy-evidence",path("accuracy_evidence"),
    "--minimum-accuracy",job["minimum_accuracy"],"--clock-rtl",path("clock_rtl"),
    "--constraints",path("constraints"),"--clock-net",job["clock_net"],
    "--bram-resource",job["bram_resource"],"--dsp-resource",job["dsp_resource"],"--output",output])
result=read(output/"result.json")
if not result["report_completed"]:
    raise ValueError(f"Result reporting incomplete: {output/'result.json'}")
summary="\n".join([
    "Build verified" if result["compiled_result_passes"] else "Build completed with a performance warning",
    f"BRAM blocks:          {result['bram_blocks']}",
    f"Routed logic sites:   {result['routed_logic_sites']:,}",
    f"Signed 9x9 slots:     {result['signed_nine_bit_multiplier_slots']}",
    f"Requested clock:      {result['configured_clock_hz']/1e6:.2f} MHz",
    f"Routed Fmax:          {result['reported_fmax'][job['clock_net']]['achieved']:.2f} MHz",
    f"Period:               {result['period_cycles']:,} cycles/inference",
    f"Reported FPS estimate:{result['reported_fps']:>12.4f}",
    f"Requested FPS:        {result['required_fps']}",
    f"Clock target met:     {result['configured_clock_timing_met']}",
    f"FPS target met:       {result['performance_target_met']}",
    f"Validation Dice:      {result['validation_dice']:.6f} (supplied evidence)",
    f"Board FPS measured:   {result['physical_board_measured']}",
    "",
    f"Harness: {result['harness_scope']}",
    f"Bitstream: {output/'harness.fs'}" if result["bitstream_ready"] else "Bitstream: not generated; adjust the clock and verify timing before hardware use",
    f"Report:    {output/'result.json'}",
    f"Summary:   {output/'summary.txt'}",
    f"Logs:      {build/'logs'}",
])
(output/"summary.txt").write_text(summary+"\n")
print("\n"+summary)
