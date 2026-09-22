"""Prove occupancy and pointer bookkeeping under the window release contract."""

from pathlib import Path
import subprocess

import pytest


@pytest.mark.parametrize("parameters", [
    {"HEIGHT": 1, "WIDTH": 1},
    {"HEIGHT": 5, "WIDTH": 7, "CHANNELS": 3, "LANES": 2,
     "KERNEL_H": 3, "KERNEL_W": 3, "PAD_H": 1, "PAD_W": 1},
    {"HEIGHT": 7, "WIDTH": 9, "KERNEL_H": 2, "KERNEL_W": 3,
     "STRIDE_H": 2, "STRIDE_W": 2, "DILATION_H": 2, "PAD_W": 1},
    {"HEIGHT": 8, "WIDTH": 6, "KERNEL_H": 4, "KERNEL_W": 6,
     "STRIDE_H": 4, "STRIDE_W": 6},
    {"HEIGHT": 3, "WIDTH": 9, "STRIDE_H": 2, "STRIDE_W": 4},
])
def test_registered_occupancy_matches_pointer_difference(tmp_path, parameters):
    source = Path(__file__).resolve().parents[1] / "torch2rtl/templates/window_prefetch.sv"
    # The datapath below this point is unchanged. Keep the actual controller
    # and prove it against the former full-width pointer arithmetic.
    rtl = source.read_text().split("  wire [INDEX_BITS-1:0] write_location=")[0]
    rtl += """
  reg past_valid=0;
  reg [SEQUENCE_BITS-1:0] reference_written, reference_origin;
  wire [SEQUENCE_BITS-1:0] reference_advance=last_column ?
    (last_row ? SEQUENCE_BITS'(FRAME_STEP) : SEQUENCE_BITS'(ROW_STEP)) : SEQUENCE_BITS'(COLUMN_STEP);
  wire signed [SEQUENCE_BITS-1:0] reference_live=$signed(reference_written-reference_origin);
  wire signed [SEQUENCE_BITS-1:0] reference_reserved=reference_live+SEQUENCE_BITS'(pending);
  always @* assume(!release_window || window_available);
  always @(posedge clk) begin
    past_valid<=1;
    if(rst) begin reference_written<=0; reference_origin<=0; end
    else begin
      if(pending) reference_written<=reference_written+1'b1;
      if(release_window) reference_origin<=reference_origin+reference_advance;
    end
    if(past_valid) begin
      assert(reserved==reference_reserved);
      assert(written==INDEX_BITS'(reference_written));
      assert(origin==INDEX_BITS'(reference_origin));
      assert(reserved>=SEQUENCE_BITS'(-FRAME_WORDS) && reserved<=CAPACITY);
      assert(output_column<OUTPUT_W && output_row<OUTPUT_H);
      assert(row<PADDED_H && column<PADDED_W && channel_word<CHANNEL_WORDS);
      assert(row_padding==(32'(row)<PAD_H || 32'(row)>=PAD_H+HEIGHT));
      assert(column_padding==(32'(column)<PAD_W || 32'(column)>=PAD_W+WIDTH));
      assert(window_available==(!rst && reference_live>=LIVE_WORDS));
      assert(can_issue==(!rst && reference_reserved<CAPACITY));
    end
  end
endmodule
"""
    (tmp_path / "controller.sv").write_text(rtl)
    settings = " ".join(f"-set {name} {value}" for name, value in parameters.items())
    (tmp_path / "proof.ys").write_text(f"""
read_verilog -formal -sv controller.sv
chparam {settings} raster_window
prep -top raster_window -flatten
opt
async2sync
chformal -lower
sat -seq 4 -tempinduct -set-assumes -set-at 1 rst 1 -prove-asserts -verify
""")
    result = subprocess.run(["yosys", "-Q", "-T", "-s", "proof.ys"], cwd=tmp_path,
                            capture_output=True, text=True, timeout=30)
    (tmp_path / "proof.log").write_text(result.stdout + result.stderr)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "Induction step proven: SUCCESS!" in result.stdout
