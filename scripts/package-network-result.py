#!/usr/bin/env python3
"""Package a verified automatic compile; never promote an estimate to a result."""

import argparse
import hashlib
import json
from pathlib import Path
import shutil


def read(path):
    return json.loads(path.read_text())


def digest(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


parser=argparse.ArgumentParser(description=__doc__)
for name in ("build","vectors","accuracy-evidence","clock-rtl","constraints","output"):
    parser.add_argument("--"+name,type=Path,required=True)
parser.add_argument("--minimum-accuracy",type=float,required=True)
parser.add_argument("--clock-net",required=True)
parser.add_argument("--bram-resource",required=True)
parser.add_argument("--dsp-resource",required=True)
args=parser.parse_args()
root=Path(__file__).resolve().parents[1]
build=args.build.resolve()
target=read(build/"target.json")
search=read(build/"search.json")
schedule=read(build/"schedule/report.json")
config=read(build/"schedule/configuration.json")
catalogue=read(build/"schedule/catalogue.json")
planning_report=(root/Path(catalogue["automatic_buffering"]["planning_report"])).resolve()
simulation=read(build/"simulation/report.json")
proof=read(build/"proofs/report.json")
flow=read(build/"route/toolflow-summary.json")
capacity=read(build/"route/capacity.json")
guard=read(build/"route/dsp-timing-guard.json")
pins=read(build/"route/pin-coverage.json")
job=read(build/"job.json")
accuracy=read(args.accuracy_evidence)
reference=read(args.vectors/"reference.json")
model=Path(config["model"])
period=schedule["solution"]["period"]
rate=target["clock_hz"]/period
frames=simulation["frame_completion_cycles"]
bram=flow["utilization"][args.bram_resource]["used"]
dsp=flow["utilization"][args.dsp_resource]["used"]
fmax=flow["fmax"][args.clock_net]
automatic=schedule["automatic_architecture_selection"]
gates={
    "unchanged_model":digest(model)==config["model_sha256"]==accuracy["model_sha256"]==reference["model_sha256"],
    "accuracy_requirement":accuracy["validation_dice"]>=args.minimum_accuracy,
    "automatic_selection":automatic["compiler_buffer_planning"] and
        not automatic["external_configuration_seed"] and not automatic["external_schedule_seed"] and
        not any(search.get(key) for key in ("initial_configuration","initial_schedule","absorb_input_fifos")),
    "solver_verified":schedule["solver_verified"],
    "rtl_identity":digest(build/"schedule/inference.sv")==digest(build/"simulation/inference.sv"),
    "bit_exact_frames":simulation["bit_exact"] and len(frames)==reference["frames"] and len(frames)>=3 and
        simulation["input_words"]==reference["input_words"] and simulation["output_words"]==reference["output_words"],
    "scheduled_transfers":simulation["scheduled_transfers"],
    "steady_frame_interval":all(right-left==period for left,right in zip(frames,frames[1:])),
    "mapping_equivalence":proof["passed"],
    "physical_capacity":capacity["necessary_capacity_check_passes"],
    "logic_margin":capacity["routed_logic_sites"]<=target["resources"].get("lut_sites",capacity["lut_sites_available"]),
    "dsp_configuration_guard":guard["passed"] and guard["cells"]==dsp,
    "used_pin_coverage":not pins["missing_used_pins"],
    "route_timing":flow["tool_timing_checks_passed"] and
        fmax["achieved"]>=fmax["constraint"]>=target["clock_hz"]/1e6,
    "bitstream_packed":(build/"route/harness.fs").stat().st_size>0,
    "bram_requirement":bram<=target["resources"]["bram"],
    "throughput_requirement":rate>=target["required_fps"],
}
source_identity=build/"source-equivalence"
timing_identity=build/"route/timing-database-identity.json"
if timing_identity.exists():
    identity=read(timing_identity)
    gates["timing_database_identity"]=(identity["passed"] and
        identity["decoded_timing_identical"] and identity["original_bba_reassembles_to_routed_database"] and
        digest(Path(target["place_route"]["chipdb"]))==identity["evidence"]["binary"]["sha256"] and
        all(digest(Path(item["path"]))==item["sha256"] for item in identity["evidence"].values()))
if (source_identity/"report.json").exists():
    identity=read(source_identity/"report.json")
    gates["source_annotation_identity"]=(identity["passed"] and
        identity["before"]["elaboration_sha256"]==identity["after"]["elaboration_sha256"] and
        digest(source_identity/"before/inference.sv")==identity["before"]["rtl_sha256"] and
        digest(source_identity/"after/inference.sv")==identity["after"]["rtl_sha256"]==
        digest(build/"schedule/inference.sv"))
if not all(gates.values()):
    raise ValueError("Result gates failed: "+", ".join(name for name,passed in gates.items() if not passed))
files={
    "inference.sv":build/"schedule/inference.sv",
    "configuration.json":build/"schedule/configuration.json",
    "schedule-report.json":build/"schedule/report.json",
    "selected-catalogue.json":build/"schedule/catalogue.json",
    "architecture-bound.json":build/"throughput-screen.json",
    "simulation-report.json":build/"simulation/report.json",
    "mapping-proofs.json":build/"proofs/report.json",
    "mapping-evidence.json":build/"schedule/mapped/evidence.json",
    "target.json":build/"target.json", "search.json":build/"search.json", "job.json":build/"job.json",
    "pll.sv":args.clock_rtl,"constraints.cst":args.constraints,
}
for name in ("capacity.json","route-report.json","toolflow-summary.json","dsp-timing-guard.json",
             "pin-coverage.json","harness.fs","harness.sv","clocks.py"):
    files[name]=build/"route"/name
if timing_identity.exists():
    files["timing-database-identity.json"]=timing_identity
if (build/"resource-breakdown.json").exists():
    files["resource-breakdown.json"]=build/"resource-breakdown.json"
if (build/"resume-provenance.json").exists():
    files["resume-provenance.json"]=build/"resume-provenance.json"
if (source_identity/"report.json").exists():
    for name in ("report.json","verify.py","before/inference.sv","after/inference.sv"):
        files["source-equivalence/"+name]=source_identity/name
evidence={**files,"model":model,"accuracy":args.accuracy_evidence,
    "reference":args.vectors/"reference.json","reference_input":args.vectors/"input.hex",
    "reference_output":args.vectors/"expected.hex",
    "offsets":build/"schedule/offsets.jsonl.gz",
    "input_cycles":build/"schedule/input_cycles.hex","output_cycles":build/"schedule/output_cycles.hex",
    "mapped_modules":build/"schedule/mapped/modules.json","mapped_structure":build/"schedule/mapped/structure.sv",
    "linked_netlist":build/"route/linked-flat.json","packed_netlist":build/"route/packed.json",
    "routed_netlist":build/"route/routed.json","route_log":build/"route/place-route.log",
    "buffer_plan":planning_report,"buffer_hint":planning_report.parent/"storage-hint.json",
    "chip_database":Path(target["place_route"]["chipdb"]),
}
for key in ("timing_guard","timing_table","pin_audit","database_generator"):
    evidence[key]=root/job[key]
result={
    "model_sha256":digest(model),"validation_dice":accuracy["validation_dice"],
    "accuracy_scope":accuracy.get("accuracy_scope","Inherited from the unchanged model's supplied validation evidence."),
    "period_cycles":period,"configured_clock_hz":target["clock_hz"],"scheduled_fps":rate,
    "required_fps":target["required_fps"],"bram_blocks":bram,
    "signed_nine_bit_multiplier_slots":dsp,"mandatory_logic_sites":capacity["lut_site_lower_bound"],
    "logic_sites_available":capacity["lut_sites_available"],
    "routed_logic_sites":capacity["routed_logic_sites"],
    "logic_sites_reserved":capacity["routed_logic_sites_free"],
    "reported_fmax":flow["fmax"],"compiled_result_passes":True,"gates":gates,
    "automatic_architecture_selection":automatic,"physical_board_measured":False,
    "timing_scope":"Configuration-scoped DSP timing database and used-pin structural audit; not independent timing signoff.",
    "harness_scope":"Counter-source/checksum harness; no host/camera transport or board measurement.",
    "evidence":{name:{"path":str(path.resolve()),"sha256":digest(path)} for name,path in evidence.items()},
}
args.output.mkdir(parents=True,exist_ok=True)
for name,path in files.items():
    (args.output/name).parent.mkdir(parents=True,exist_ok=True)
    shutil.copyfile(path,args.output/name)
(args.output/"result.json").write_text(json.dumps(result,indent=2)+"\n")
sources=sorted([*root.glob("torch2rtl/*.py"),*root.glob("torch2rtl/templates/*.sv"),*root.glob("scripts/*.py")])
(args.output/"compiler-source-hashes.json").write_text(json.dumps(
    {str(path.relative_to(root)):digest(path) for path in sources},indent=2)+"\n")
print(json.dumps({"gates":gates,"bram":bram,"scheduled_fps":rate,"fmax":fmax},indent=2))
