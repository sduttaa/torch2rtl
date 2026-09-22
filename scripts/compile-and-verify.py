#!/usr/bin/env python3
"""Run automatic architecture selection and all acceptance checks from input files.

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


parser=argparse.ArgumentParser(description=__doc__)
parser.add_argument("--job",type=Path,required=True)
parser.add_argument("--build",type=Path,required=True)
parser.add_argument("--output",type=Path,required=True)
parser.add_argument("--seconds",type=float,default=180)
parser.add_argument("--workers",type=int,default=1)
parser.add_argument("--verify-only",action="store_true",help="Check an existing compile with matching model, target and search inputs")
args=parser.parse_args()
root=Path(__file__).resolve().parents[1]
job=json.loads(args.job.read_text())
build=args.build.resolve()
build.mkdir(parents=True,exist_ok=True)
(build/"logs").mkdir(exist_ok=True)


def path(name):
    return (root/job[name]).resolve(strict=True)


def read(location):
    return json.loads(location.read_text())


def run(name,command,env=None):
    print(name,flush=True)
    with (build/"logs"/(name+".log")).open("w") as log:
        subprocess.run([str(item) for item in command],cwd=root,stdout=log,stderr=subprocess.STDOUT,check=True,env=env)


def script(name):
    return [sys.executable,root/"scripts"/(name+".py")]


model_hash=hashlib.sha256(path("model").read_bytes()).hexdigest()
reference=read(path("vectors")/"reference.json")
accuracy=read(path("accuracy_evidence"))
if model_hash!=reference["model_sha256"] or model_hash!=accuracy["model_sha256"]:
    raise ValueError("Reference and accuracy evidence must describe the supplied model")
if reference["frames"]<3 or not accuracy["validation_dice"]>=job["minimum_accuracy"]:
    raise ValueError("Insufficient verification frames or model accuracy")
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
if not report["solver_verified"] or not report["required_fps_met"]:
    raise ValueError("A verified schedule meeting the requested throughput is required")
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
    "--bram-resource",job["bram_resource"],"--dsp-resource",job["dsp_resource"],"--output",args.output.resolve()])
print((build/"logs/package.log").read_text())
