#!/usr/bin/env python3
"""Place/route generated RTL inside an observable source/sink test harness.

The harness tests physical tool compatibility and runs the tool's timing checks.
A successful return does not establish timing-model coverage. It does not
implement a user's external transport or establish inference on a physical board.
"""
import argparse
import json
import math
from pathlib import Path
import subprocess
import sys

sys.path.insert(0, str(Path(__file__).resolve().parents[1]))
from torch2rtl.flow import synthesis_command
from torch2rtl.gowin import map_netlist

parser = argparse.ArgumentParser(description=__doc__)
source = parser.add_mutually_exclusive_group(required=True)
source.add_argument("--compiled", type=Path)
source.add_argument("--rtl", type=Path)
source.add_argument("--mapped-network", type=Path, help="Structural RTL with characterized physical modules")
parser.add_argument("--input-bits", type=int)
parser.add_argument("--output-bits", type=int)
parser.add_argument("--target", type=Path, required=True)
parser.add_argument("--constraints", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
parser.add_argument("--clock-rtl", type=Path, help="Optional inference_clock module with clock_in, clock_out and locked ports")
parser.add_argument("--reference-clock-hz", type=float, help="Reference frequency supplied to --clock-rtl; target clock_hz constrains its output")
args = parser.parse_args()
if ((args.clock_rtl is None) != (args.reference_clock_hz is None) or
        (args.reference_clock_hz is not None and (not math.isfinite(args.reference_clock_hz) or args.reference_clock_hz <= 0))):
    parser.error("Supply --clock-rtl and a positive --reference-clock-hz together")
target = json.loads(args.target.read_text())
if args.compiled:
    compiled = json.loads((args.compiled / "compile.json").read_text())
    candidate = compiled["candidates"][compiled["solution"]["selected"]["hardware"]]
    kernel = compiled["kernel"]
    input_bits = kernel["input"]["bits"] * candidate["lanes"]
    output_bits = kernel["output"]["bits"] * (1 if kernel["reduction"] else candidate["lanes"])
    rtl = args.compiled / "inference.sv"
else:
    if not args.input_bits or not args.output_bits or min(args.input_bits, args.output_bits) < 1:
        parser.error("--rtl requires positive --input-bits and --output-bits")
    input_bits, output_bits = args.input_bits, args.output_bits
    rtl = args.mapped_network/"structure.sv" if args.mapped_network else args.rtl
args.output.mkdir(parents=True, exist_ok=True)
for name in ("routed.json", "route-report.json", "harness.fs"):
    (args.output / name).unlink(missing_ok=True)
clock, reset, clock_setup = "clk", "rst", ""
if args.clock_rtl:
    clock, reset = "core_clock", "core_reset"
    clock_setup = """
  wire core_clock, clock_locked;
  inference_clock clock_source(.clock_in(clk), .clock_out(core_clock), .locked(clock_locked));
  wire reset_requested = rst || !clock_locked;
  (* async_reg = "true" *) reg [1:0] reset_sync = 2'b11;
  always @(posedge core_clock or posedge reset_requested)
    if (reset_requested) reset_sync <= 2'b11;
    else reset_sync <= {reset_sync[0], 1'b0};
  wire core_reset = reset_sync[1];
"""
harness = f"""
module harness(input wire clk, input wire rst, output wire observed);
{clock_setup}
  reg [{input_bits-1}:0] source;
  wire in_ready;
  wire [{output_bits-1}:0] out_data;
  wire out_valid;
  reg [{output_bits-1}:0] checksum;
  inference core(.clk({clock}), .rst({reset}), .in_data(source), .in_valid(1'b1),
    .in_ready(in_ready), .out_data(out_data), .out_valid(out_valid), .out_ready(1'b1));
  always @(posedge {clock}) begin
    if ({reset}) begin source <= 0; checksum <= 0; end
    else begin
      if (in_ready) source <= source + 1'b1;
      if (out_valid) checksum <= (checksum << 1) ^ out_data;
    end
  end
  assign observed = ^checksum;
endmodule
"""
(args.output / "harness.sv").write_text(rtl.read_text() + harness + (args.clock_rtl.read_text() if args.clock_rtl else ""))
config = target["synthesis"]
if config["command"] != "synth_gowin":
    raise ValueError("This routing smoke script currently supports the Gowin family flow")
interfaces=""
if args.mapped_network:
    (args.output/"interfaces.json").write_bytes((args.mapped_network/"interfaces.json").read_bytes())
    interfaces="read_json interfaces.json\n"
(args.output / "synth.ys").write_text(
    interfaces+f"read_verilog -sv harness.sv\n{synthesis_command(config, 'harness')}\n"
    "bufnorm -conn\nclean\nwrite_json netlist.json\n")
pnr = target["place_route"]
route_command = [pnr["executable"], "--device", pnr["device"], "--vopt", "family=" + pnr["family"],
                 "--vopt", "cst=" + str(args.constraints.resolve()), "--json", "netlist.json",
                 "--freq", str(target["clock_hz"] / 1e6)]
if "chipdb" in pnr:
    route_command += ["--chipdb", str(Path(pnr["chipdb"]).resolve(strict=True))]
if args.clock_rtl:
    (args.output / "clocks.py").write_text(
        f'ctx.addClock("clk", {args.reference_clock_hz / 1e6!r})\n'
        f'ctx.addClock("clock_source.clock_out", {target["clock_hz"] / 1e6!r})\n')
    route_command += ["--pre-pack", str((args.output / "clocks.py").resolve())]
commands = [
    ["yosys", "-Q", "-T", "-s", "synth.ys"],
    route_command + ["--pack-only", "--write", "packed.json", "--report", "packing-report.json"],
    route_command + ["--write", "routed.json", "--report", "route-report.json"],
    ["gowin_pack", "-d", pnr["family"], "-o", "harness.fs", "routed.json"],
]
for name, command in zip(("synthesis", "packing", "place-route", "pack"), commands):
    with (args.output / f"{name}.log").open("w") as log:
        subprocess.run(command, cwd=args.output, stdout=log, stderr=subprocess.STDOUT, check=True)
    if name == "synthesis":
        if args.mapped_network:
            linked=json.loads((args.output/"netlist.json").read_text())
            modules=json.loads((args.mapped_network/"modules.json").read_text())["modules"]
            for module in modules:
                if module not in linked["modules"] or not linked["modules"][module].get("attributes",{}).get("blackbox"):
                    raise ValueError(f"Missing blackbox interface for mapped module {module}")
            linked["modules"].update(modules)
            (args.output/"linked.json").write_text(json.dumps(linked)+"\n")
            family=config.get("family")
            if not family or not family.isalnum():
                raise ValueError("Mapped linking requires an alphanumeric synthesis family")
            (args.output/"link.ys").write_text("read_json linked.json\n"+
                f"read_verilog -lib -specify -overwrite +/gowin/cells_sim.v +/gowin/cells_xtra_{family}.v\n"+
                "hierarchy -check -top harness\nflatten\nopt_clean\n"
                "hilomap -singleton -hicell VCC V -locell GND G\nbufnorm -conn\nclean\ncheck\n"
                "blackbox =A:whitebox\nwrite_json linked-flat.json\n")
            with (args.output/"link.log").open("w") as log:
                subprocess.run(["yosys","-Q","-T","-s","link.ys"],cwd=args.output,stdout=log,stderr=subprocess.STDOUT,check=True)
            mapped=(args.output/"linked-flat.json").resolve()
        else:
            mapped = map_netlist(args.output / "netlist.json", args.output / "mapping", target).resolve()
        for following in commands[1:3]:
            following[following.index("--json")+1] = str(mapped)
    if name == "packing":
        utilization = json.loads((args.output / "packing-report.json").read_text())["utilization"]
        # Zero-capacity report entries include virtual bookkeeping cells.
        exceeded = {resource: row for resource, row in utilization.items()
                    if row["available"] > 0 and row["used"] > row["available"]}
        if exceeded:
            raise ValueError(f"Packed resource capacity exceeded: {exceeded}")
        subprocess.run([sys.executable, str(Path(__file__).with_name("check-gowin-capacity.py")),
                        "--netlist", str((args.output / "packed.json").resolve()),
                        "--packing-report", str((args.output / "packing-report.json").resolve()),
                        "--output", str((args.output / "capacity.json").resolve())], check=True)
        capacity=json.loads((args.output/"capacity.json").read_text())
        site_budget=target["resources"].get("lut_sites",capacity["lut_sites_available"])
        if capacity["lut_site_lower_bound"]>site_budget:
            raise ValueError(f"Packed logic needs {capacity['lut_site_lower_bound']} sites; supplied placement budget is {site_budget}")
    if name == "place-route":
        subprocess.run([sys.executable,str(Path(__file__).with_name("check-gowin-capacity.py")),
                        "--netlist",str((args.output/"packed.json").resolve()),
                        "--packing-report",str((args.output/"packing-report.json").resolve()),
                        "--routed-netlist",str((args.output/"routed.json").resolve()),
                        "--output",str((args.output/"capacity.json").resolve())],check=True)
        capacity=json.loads((args.output/"capacity.json").read_text())
        if capacity["routed_logic_sites"]>site_budget:
            raise ValueError(f"Routed logic occupies {capacity['routed_logic_sites']} sites; supplied placement budget is {site_budget}")
result = json.loads((args.output / "route-report.json").read_text())
summary = {"fmax": result.get("fmax"), "utilization": result.get("utilization"),
           "tool_timing_checks_passed": True, "timing_coverage_verified": False,
           "physical_board_measured": False,
           "scope": "Tool-reported timing only; primitive and path coverage require separate verification."}
(args.output / "toolflow-summary.json").write_text(json.dumps(summary, indent=2) + "\n")
print(json.dumps(summary, indent=2))
