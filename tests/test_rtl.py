from math import ceil

import pytest
import torch

from torch2rtl.frontend import load
from torch2rtl.lower import lower
from torch2rtl.rtl import emit
from rtl_check import pack, simulate


class IntegerMap(torch.nn.Module):
    def __init__(self, reduce=False):
        super().__init__()
        self.reduce = reduce

    def forward(self, x):
        # An overflow before a cast must not be optimized away during fusion.
        narrow = (x * 3 + 17).to(torch.uint8)
        wide = narrow.to(torch.int32)
        result = (wide * wide - wide * 5 - 200).clamp(-110, 100).to(torch.int8)
        return result.sum(dtype=torch.int32) if self.reduce else result


@pytest.mark.parametrize("reduce", [False, True])
@pytest.mark.parametrize("lanes,depth", [(1, 1), (2, 2), (4, 3)])
@pytest.mark.parametrize("stalls", [False, True])
def test_integer_fusion_fifo_and_reduction(tmp_path, reduce, lanes, depth, stalls):
    model = IntegerMap(reduce)
    generator = torch.Generator().manual_seed(71)
    frames = [torch.randint(-128, 128, (1, 3, 7), dtype=torch.int8, generator=generator)
              for _ in range(9)]
    path = tmp_path / "program.pt2"
    torch.export.save(torch.export.export(model, (frames[0],)), path)
    _, module = load(path)
    kernel = lower(module)
    rtl = emit(kernel, lanes, depth)
    inputs = [word for frame in frames for word in pack(frame.flatten(), 8, lanes)]
    outputs = [word for frame in frames for word in
               pack(model(frame).flatten(), kernel.output.bits, 1 if reduce else lanes)]
    cycles = simulate(tmp_path, rtl, 8 * lanes, kernel.output.bits * (1 if reduce else lanes),
                      inputs, outputs, stalls)
    if not stalls:
        words = ceil(frames[0].numel() / lanes)
        frame_completions = cycles if reduce else cycles[words - 1::words]
        expected_period = words + int(reduce)
        assert set(b - a for a, b in zip(frame_completions, frame_completions[1:])) == {expected_period}


class EdgeCases(torch.nn.Module):
    def __init__(self, kind):
        super().__init__()
        self.kind = kind

    def forward(self, x):
        if self.kind == "boolean":
            return x.to(torch.bool).to(torch.int32).sum(dtype=torch.int32)
        if self.kind == "reversed_clamp":
            return x.clamp(10, 5)
        if self.kind == "unsigned":
            return x.to(torch.uint8).sum(dtype=torch.int32)
        return (x.to(torch.int64) * 10000000000 - 300).sum(dtype=torch.int64)


@pytest.mark.parametrize("kind", ["boolean", "reversed_clamp", "unsigned", "wide"])
@pytest.mark.parametrize("count", [1, 7])
def test_numeric_boundaries_and_single_word_frames(tmp_path, kind, count):
    model = EdgeCases(kind)
    frames = [torch.tensor([[-128, -2, -1, 0, 1, 2, 127][:count]], dtype=torch.int8),
              torch.zeros((1, count), dtype=torch.int8)] * 4
    path = tmp_path / "program.pt2"
    torch.export.save(torch.export.export(model, (frames[0],)), path)
    _, module = load(path)
    kernel = lower(module)
    lanes, depth = 4, 3
    output_lanes = 1 if kernel.reduction else lanes
    simulate(tmp_path, emit(kernel, lanes, depth), 8 * lanes, kernel.output.bits * output_lanes,
             [word for frame in frames for word in pack(frame.flatten(), 8, lanes)],
             [word for frame in frames for word in pack(model(frame).flatten(), kernel.output.bits, output_lanes)], True)
