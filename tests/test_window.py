from pathlib import Path
from math import ceil
import subprocess

import numpy as np
import pytest

from rtl_check import pack, simulate


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("packed_lines", [False, True])
@pytest.mark.parametrize("shape,kernel,stride,dilation,padding,lanes", [
    ((5, 7, 3), (3, 3), (1, 1), (1, 1), (1, 1), 2),
    ((7, 9, 5), (2, 3), (2, 2), (2, 1), (2, 0), 4),
    ((1, 1, 1), (1, 1), (1, 1), (1, 1), (0, 0), 1),
    ((1, 3, 3), (1, 3), (1, 1), (1, 1), (0, 1), 2),
    ((7, 5, 4), (3, 2), (2, 1), (2, 2), (0, 1), 2),
    ((6, 8, 1), (2, 2), (3, 3), (1, 1), (0, 0), 1),
    ((3, 1, 1), (3, 1), (1, 1), (1, 1), (1, 0), 1),
    ((2, 1, 3), (3, 2), (1, 1), (1, 1), (2, 3), 2),
])
def test_raster_windows_across_frames(tmp_path, shape, kernel, stride, dilation, padding, lanes, stalls, packed_lines):
    height, width, channels = shape
    kh, kw = kernel
    sh, sw = stride
    dh, dw = dilation
    ph, pw = padding
    channel_words = ceil(channels / lanes)
    window_words = kh * kw * channel_words
    bits = max(1, (window_words - 1).bit_length())
    parameters = {"HEIGHT": height, "WIDTH": width, "CHANNELS": channels,
                  "KERNEL_H": kh, "KERNEL_W": kw, "STRIDE_H": sh, "STRIDE_W": sw,
                  "DILATION_H": dh, "DILATION_W": dw, "PAD_H": ph, "PAD_W": pw, "LANES": lanes,
                  "PACKED_LINES": int(packed_lines)}
    assignments = ", ".join(f".{key}({value})" for key, value in parameters.items())
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{lanes*8-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  reg [{bits-1}:0] window_address;
  wire release_window = out_valid && out_ready && window_address == {bits}'d{window_words-1};
  raster_window #({assignments}) window (
    .clk(clk), .rst(rst), .in_data(in_data), .in_valid(in_valid), .in_ready(in_ready),
    .window_available(out_valid), .release_window(release_window),
    .window_address(window_address), .window_data(out_data)
  );
  always @(posedge clk) begin
    if (rst) window_address <= 0;
    else if (out_valid && out_ready)
      window_address <= release_window ? 0 : window_address + 1'b1;
  end
endmodule
"""
    source = (Path(__file__).parents[1] / "torch2rtl/templates/window.sv").read_text()
    if packed_lines and (kh-1)*dh+1 > 1:
        # The no_rw_check declaration is valid only when the parent never
        # overlaps transactions and simultaneous RAM accesses are disjoint.
        assertions = """
  always @(posedge clk) if (!rst) begin
    if (issue && busy) $fatal(1, "Overlapping packed-row transactions");
    if (busy && !complete && read_location == location)
      $fatal(1, "Packed-row read/write collision");
  end
"""
        marker = source.rfind("endmodule")
        source = source[:marker] + assertions + source[marker:]
    input_words, expected = [], []
    generator = np.random.default_rng(99)
    for _ in range(3):
        frame = generator.integers(0, 256, size=shape, dtype=np.uint8)
        input_words.extend(word for pixel in frame.reshape(-1, channels) for word in pack(pixel, 8, lanes))
        padded = np.pad(frame, ((ph, ph), (pw, pw), (0, 0)))
        for y in range(0, padded.shape[0] - (kh-1)*dh, sh):
            for x in range(0, padded.shape[1] - (kw-1)*dw, sw):
                for row in range(kh):
                    for column in range(kw):
                        expected.extend(pack(padded[y+row*dh, x+column*dw], 8, lanes))
    simulate(tmp_path, wrapper + source, lanes*8, lanes*8, input_words, expected, stalls)


@pytest.mark.parametrize("parameters", [
    {"HEIGHT": 3, "WIDTH": 1, "CHANNELS": 1, "KERNEL_H": 2, "KERNEL_W": 1, "LANES": 1, "PAD_H": 1},
    {"HEIGHT": 5, "WIDTH": 3, "CHANNELS": 3, "KERNEL_H": 3, "KERNEL_W": 2,
     "DILATION_H": 2, "LANES": 2, "PAD_H": 2, "PAD_W": 1},
    {"HEIGHT": 4, "WIDTH": 7, "CHANNELS": 5, "KERNEL_H": 3, "KERNEL_W": 3,
     "LANES": 4, "PAD_H": 1, "PAD_W": 1},
])
@pytest.mark.parametrize("packed_lines", [0, 1])
def test_memory_accesses_never_collide(tmp_path, parameters, packed_lines):
    # Check the actual parent controller with arbitrary input-valid, release
    # and reset signals. Only the first cycle is constrained to reset.
    source = (Path(__file__).parents[1] / "torch2rtl/templates/window.sv").read_text()
    address_assertion = """
  always @(posedge clk) if (!rst && pending && !pending_column_padding && !column_padding)
    assert ((address == pending_address) == (LINE_WORDS == 1));
"""
    marker = source.index("endmodule")
    source = source[:marker] + address_assertion + source[marker:]
    assertions = """
  always @(posedge clk) if (!rst) begin
    assert (!issue || !busy);
    if (busy && !complete) assert (read_location != location);
  end
"""
    marker = source.rfind("endmodule")
    (tmp_path / "window.sv").write_text(source[:marker] + assertions + source[marker:])
    assignments = " ".join(f"-set {key} {value}" for key, value in parameters.items())
    script = f"""
read_verilog -formal -sv window.sv
chparam {assignments} -set PACKED_LINES {packed_lines} raster_window
hierarchy -top raster_window
proc
flatten
memory_map
opt
async2sync
chformal -lower
sat -seq 6 -tempinduct -set-at 1 rst 1 -prove-asserts -verify
"""
    (tmp_path / "proof.ys").write_text(script)
    result = subprocess.run(["yosys", "-Q", "-T", "-s", "proof.ys"], cwd=tmp_path,
                            capture_output=True, text=True, timeout=30)
    (tmp_path / "proof.log").write_text(result.stdout + result.stderr)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "Induction step proven: SUCCESS!" in result.stdout
