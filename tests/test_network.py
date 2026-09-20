from pathlib import Path

import numpy as np
import pytest
import torch
from torch.nn import functional as F

from torch2rtl.frontend import import_program
from torch2rtl.graph import actors, read, evaluate
from torch2rtl.network import edges, emit
from rtl_check import pack, simulate


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("depth", [1, 2, 3, 4, 17])
def test_synchronous_fifo(tmp_path, depth, stalls):
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [15:0] in_data, input wire in_valid, output wire in_ready,
  output wire [15:0] out_data, output wire out_valid, input wire out_ready
);
  stream_fifo #(.WIDTH(16), .DEPTH({depth})) fifo (.*);
  integer occupancy = 0;
  always @(posedge clk) begin
    if (rst) occupancy = 0;
    else begin
      occupancy = occupancy + (in_valid && in_ready) - (out_valid && out_ready);
      if (occupancy < 0 || occupancy > {depth}) $fatal(1, "FIFO capacity violated");
    end
  end
endmodule
"""
    source = (Path(__file__).parents[1] / "torch2rtl/templates/fifo.sv").read_text()
    words = np.random.default_rng(89).integers(0, 65536, 500).tolist()
    cycles = simulate(tmp_path, wrapper+source, 16, 16, words, words, stalls)
    if not stalls:
        first_input = next(int(line.split()[2]) for line in (tmp_path / "simulation.log").read_text().splitlines()
                           if line.startswith("INPUT"))
        assert cycles[0] - first_input == (1 if depth == 1 else 2)
        assert cycles[-1] - cycles[0] == len(words)-1


class TinyBranched(torch.nn.Module):
    def __init__(self):
        super().__init__()
        self.register_buffer("stem", torch.randint(-3, 4, (3, 3, 3, 3), dtype=torch.int32))
        self.register_buffer("skip", torch.ones((1, 3, 1, 1), dtype=torch.int32))
        self.register_buffer("head", torch.tensor([-1, -2, 1, 2], dtype=torch.int32).reshape(1, 4, 1, 1))
        self.register_buffer("stem_bias", torch.tensor([90, 120, 150], dtype=torch.int32))
        self.register_buffer("skip_bias", torch.tensor([13], dtype=torch.int32))
        self.register_buffer("head_bias", torch.tensor([-5], dtype=torch.int32))
        self.register_buffer("scale", torch.tensor(1, dtype=torch.int64))
        self.register_buffer("first_scale", torch.tensor(7, dtype=torch.int64))
        self.register_buffer("second_scale", torch.tensor(16, dtype=torch.int64))

    def quantize(self, value):
        return ((value.to(torch.int64)*self.scale+8) >> 4).clamp(0, 255).to(torch.uint8)

    def forward(self, image):
        stem = self.quantize(F.conv2d(image.to(torch.int32), self.stem, self.stem_bias, padding=1))
        skip = self.quantize(F.conv2d(stem.to(torch.int32), self.skip, self.skip_bias))
        coarse = F.interpolate(F.max_pool2d(stem, 2), scale_factor=2.0, mode="nearest")
        joined = torch.cat((coarse.to(torch.int64)*self.first_scale, skip.to(torch.int64)*self.second_scale), dim=1)
        joined = ((joined+8) >> 4).clamp(0, 255).to(torch.uint8)
        head = F.conv2d(joined.to(torch.int32), self.head, self.head_bias)
        result = ((head.to(torch.int64)*self.scale+2) >> 2).clamp(-128, 127).to(torch.int8)
        return (result > 0).to(torch.uint8)


@pytest.mark.parametrize("lanes", [1, 2, 4])
@pytest.mark.parametrize("stalls", [False, True])
def test_branched_convolution_network(tmp_path, lanes, stalls):
    torch.manual_seed(41)
    model = TinyBranched()
    images = [torch.randint(0, 256, (1, 3, 6, 10), dtype=torch.uint8) for _ in range(3)]
    graph = actors(read(import_program(torch.export.export(model, (images[0],), strict=True))))
    assert {value.operation for value in graph.values} == {
        "input", "quantized_convolution", "max_pool2d", "__interpolate.size_list_scale_list", "quantized_concat", "byte_lookup"}
    choices = {value.name: min(2, value.tensor.shape[1]) for value in graph.values if value.operation == "quantized_convolution"}
    depths = {name: 128 for name, _, _, _ in edges(graph)}
    rtl = emit(graph, lanes, choices, depths)
    input_words, expected_words = [], []
    for image in images:
        expected = model(image)
        assert torch.equal(evaluate(graph, image), expected)
        input_words.extend(word for pixel in image.permute(0, 2, 3, 1).reshape(-1, 3) for word in pack(pixel, 8, lanes))
        expected_words.extend(word for pixel in expected.permute(0, 2, 3, 1).reshape(-1, 1) for word in pack(pixel, 8, lanes))
    simulate(tmp_path, rtl, lanes*8, lanes*8, input_words, expected_words, stalls)
