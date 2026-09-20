#!/usr/bin/env python3
"""Place/route generated RTL inside an observable source/sink test harness.

The harness tests physical tool compatibility and internal timing. It does not
implement a user's external transport or establish inference on a physical board.
"""
import argparse
import json
from pathlib import Path
import subprocess

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--compiled", type=Path, required=True)
parser.add_argument("--target", type=Path, required=True)
parser.add_argument("--constraints", type=Path, required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
target = json.loads(args.target.read_text())
compiled = json.loads((args.compiled / "compile.json").read_text())
candidate = compiled["candidates"][compiled["solution"]["selected"]["hardware"]]
kernel = compiled["kernel"]
input_bits = kernel["input"]["bits"] * candidate["lanes"]
output_bits = kernel["output"]["bits"] * (1 if kernel["reduction"] else candidate["lanes"])
args.output.mkdir(parents=True, exist_ok=True)
harness = f"""
module harness(input wire clk, input wire rst, output wire observed);
  reg [{input_bits-1}:0] source;
  wire in_ready;
  wire [{output_bits-1}:0] out_data;
  wire out_valid;
  reg [{output_bits-1}:0] checksum;
  inference core(.clk(clk), .rst(rst), .in_data(source), .in_valid(1'b1),
    .in_ready(in_ready), .out_data(out_data), .out_valid(out_valid), .out_ready(1'b1));
  always @(posedge clk) begin
    if (rst) begin source <= 0; checksum <= 0; end
    else begin
      if (in_ready) source <= source + 1'b1;
      if (out_valid) checksum <= (checksum << 1) ^ out_data;
    end
  end
  assign observed = ^checksum;
endmodule
"""
(args.output / "harness.sv").write_text((args.compiled / "inference.sv").read_text() + harness)
config = target["synthesis"]
if config["command"] != "synth_gowin":
    raise ValueError("This routing smoke script currently supports the Gowin family flow")
family = config["family"]
if not family.isalnum():
    raise ValueError("Invalid family identifier")
(args.output / "synth.ys").write_text(
    f"read_verilog -sv harness.sv\nsynth_gowin -top harness -family {family} -json netlist.json\n")
pnr = target["place_route"]
commands = [
    ["yosys", "-Q", "-T", "-s", "synth.ys"],
    [pnr["executable"], "--device", pnr["device"], "--vopt", "family=" + pnr["family"],
     "--vopt", "cst=" + str(args.constraints.resolve()), "--json", "netlist.json",
     "--write", "routed.json", "--report", "route-report.json", "--freq", str(target["clock_hz"] / 1e6)],
    ["gowin_pack", "-d", pnr["family"], "-o", "harness.fs", "routed.json"],
]
for name, command in zip(("synthesis", "place-route", "pack"), commands):
    with (args.output / f"{name}.log").open("w") as log:
        subprocess.run(command, cwd=args.output, stdout=log, stderr=subprocess.STDOUT, check=True)
result = json.loads((args.output / "route-report.json").read_text())
print(json.dumps({"fmax": result.get("fmax"), "utilization": result.get("utilization"),
                  "physical_board_measured": False}, indent=2))
