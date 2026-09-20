from pathlib import Path
from math import ceil

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
