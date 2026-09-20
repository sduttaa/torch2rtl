from math import ceil

import numpy as np
import pytest
import torch

from torch2rtl.concatenate import emit
from torch2rtl.graph import Value
from torch2rtl.lower import Tensor
from rtl_check import pack, simulate


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("channels,lanes,overflow", [((3, 5), 2, False), ((1, 3, 5), 4, True), ((3,), 2, False)])
def test_integer_scale_and_concatenate(tmp_path, channels, lanes, overflow, stalls):
    generator = np.random.default_rng(90)
    inputs = tuple(Value(f"input_{index}", "input", (), Tensor((1, count, 2, 3), 8, index % 2 == 0))
                   for index, count in enumerate(channels))
    coefficients = [3, -7, 0, 11, 19] if not overflow else [(1 << 63)-1, -(1 << 63), 1, -3, (1 << 61)+9]
    multipliers = tuple(np.resize(np.array(coefficients, dtype=np.int64), count) for count in channels)
    offset, shift = ((1 << 63)-1, 56) if overflow else (8, 4)
    actor = Value("join", "quantized_concat", (inputs, multipliers, offset, shift, -128, 127),
                  Tensor((1, sum(channels), 2, 3), 8, True))
    input_words, expected_words = [], []
    for _ in range(3):
        arrays, results = [], []
        for source, multiplier in zip(inputs, multipliers):
            low, high = (-128, 128) if source.tensor.signed else (0, 256)
            array = generator.integers(low, high, (6, source.tensor.shape[1]))
            arrays.append(array)
            scaled = torch.from_numpy(array) * torch.from_numpy(multiplier)
            results.append(((scaled+offset) >> shift).clamp(-128, 127).numpy())
        for pixel in range(6):
            for array in arrays:
                input_words.extend(pack(array[pixel], 8, lanes))
            expected_words.extend(pack(np.concatenate([result[pixel] for result in results]), 8, lanes))
    # Serialize independent input streams only in this test adapter. The actor
    # itself has a separate ready/valid handshake for every branch.
    words = [ceil(count/lanes) for count in channels]
    selection = "\n".join(f"{index}: count = {count};" for index, count in enumerate(words))
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{lanes*8-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  integer port, word, count;
  wire [{len(channels)-1}:0] ready;
  wire [{len(channels)-1}:0] valid = in_valid ? {len(channels)}'d1 << port : {len(channels)}'d0;
  assign in_ready = ready[port];
  joined core(.clk(clk), .rst(rst), .in_data({{{len(channels)}{{in_data}}}}), .in_valid(valid), .in_ready(ready),
              .out_data(out_data), .out_valid(out_valid), .out_ready(out_ready));
  always @* begin count = 1; case (port) {selection} endcase end
  always @(posedge clk) begin
    if (rst) begin port <= 0; word <= 0; end
    else if (in_valid && in_ready) begin
      if (word == count-1) begin word <= 0; port <= port == {len(channels)-1} ? 0 : port+1; end
      else word <= word+1;
    end
    if (!rst && (ready & (ready-1)) != 0) $fatal(1, "Multiple input branches accepted simultaneously");
  end
endmodule
"""
    rtl = emit(actor, lanes).replace("module inference (", "module joined (", 1) + wrapper
    simulate(tmp_path, rtl, lanes*8, lanes*8, input_words, expected_words, stalls)
