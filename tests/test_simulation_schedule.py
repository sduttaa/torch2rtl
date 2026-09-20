import json
from pathlib import Path
import subprocess
import sys


def test_verilator_checks_both_input_and_output_deadlines(tmp_path):
    root = Path(__file__).resolve().parents[1]
    (tmp_path/"actor.sv").write_text("""
module inference(input wire clk, input wire rst, input wire [7:0] in_data,
  input wire in_valid, output wire in_ready, output reg [7:0] out_data,
  output reg out_valid, input wire out_ready);
  assign in_ready = !out_valid || out_ready;
  always @(posedge clk) begin
    if (rst) out_valid <= 0;
    else if (in_ready) begin
      out_valid <= in_valid;
      if (in_valid) out_data <= in_data;
    end
  end
endmodule
""")
    (tmp_path/"words.hex").write_text("13\n27\n")
    (tmp_path/"inputs.hex").write_text("3\n8\n")
    (tmp_path/"outputs.hex").write_text("6\nc\n")
    directory = tmp_path/"simulation"
    subprocess.run([sys.executable, str(root/"scripts/simulate-rtl.py"), "--rtl", str(tmp_path/"actor.sv"),
        "--input", str(tmp_path/"words.hex"), "--expected", str(tmp_path/"words.hex"),
        "--input-bits", "8", "--output-bits", "8", "--outputs-per-frame", "1", "--max-cycles", "30",
        "--input-cycles", str(tmp_path/"inputs.hex"), "--output-cycles", str(tmp_path/"outputs.hex"),
        "--output", str(directory)], check=True, capture_output=True, text=True)
    report = json.loads((directory/"report.json").read_text())
    assert report["scheduled_transfers"] and report["bit_exact"]
    assert report["frame_completion_cycles"] == [6, 12]
    (directory/"input_cycles.hex").write_text("3\n4\n")
    result = subprocess.run(["obj_dir/sim"], cwd=directory, capture_output=True, text=True)
    assert result.returncode != 0 and "Late input" in result.stderr
    (directory/"input_cycles.hex").write_text("3\n8\n")
    (directory/"output_cycles.hex").write_text("3\nc\n")
    result = subprocess.run(["obj_dir/sim"], cwd=directory, capture_output=True, text=True)
    assert result.returncode != 0 and "Late output" in result.stderr
