import numpy as np
import pytest
import torch
from torch.nn import functional as F
from torch2rtl.frontend import import_program

from torch2rtl.graph import read, quantized_convolutions, window_convolutions, quantized_concatenations, evaluate


class QuantizedConvolution(torch.nn.Module):
    def __init__(self, groups=1, overflow=False):
        super().__init__()
        self.register_buffer("weight", torch.randint(-127, 128, (4, 2 // groups, 3, 3), dtype=torch.int32))
        self.register_buffer("bias", torch.tensor([-2000, 0, 1300, 9000], dtype=torch.int32))
        self.register_buffer("multiplier", torch.tensor([1, -3, 7, (1 << 61) if overflow else 11], dtype=torch.int64))
        self.groups = groups

    def forward(self, image):
        accumulator = F.conv2d(image.to(torch.int32), self.weight, self.bias, padding=1, groups=self.groups)
        scaled = accumulator.to(torch.int64) * self.multiplier[None, :, None, None]
        return ((scaled + 64) >> 7).clamp(-128, 127).to(torch.int8)


@pytest.mark.parametrize("groups", [1, 2])
@pytest.mark.parametrize("overflow", [False, True])
def test_mlir_constant_folding_and_convolution_fusion(groups, overflow):
    torch.manual_seed(31)
    model = QuantizedConvolution(groups, overflow)
    image = torch.randint(0, 256, (1, 2, 7, 9), dtype=torch.uint8)
    exported = torch.export.export(model, (image,), strict=True)
    module = import_program(exported)
    original = read(module)
    fused = quantized_convolutions(original)
    assert sum(value.operation == "quantized_convolution" for value in fused.values) == 1
    actor = next(value for value in fused.values if value.operation == "quantized_convolution")
    assert actor.args[0] is fused.input
    assert actor.args[1].dtype == np.int32
    assert torch.equal(evaluate(original, image), model(image))
    assert torch.equal(evaluate(fused, image), model(image))


def test_intermediate_branch_prevents_convolution_fusion():
    class Branched(QuantizedConvolution):
        def forward(self, image):
            accumulator = F.conv2d(image.to(torch.int32), self.weight, self.bias, padding=1)
            scaled = accumulator.to(torch.int64) * self.multiplier[None, :, None, None]
            quantized = ((scaled + 64) >> 7).clamp(-128, 127).to(torch.int8)
            return quantized.to(torch.int32) + accumulator

    image = torch.randint(0, 256, (1, 2, 5, 6), dtype=torch.uint8)
    model = Branched()
    exported = torch.export.export(model, (image,), strict=True)
    module = import_program(exported)
    graph = quantized_convolutions(read(module))
    assert not any(value.operation == "quantized_convolution" for value in graph.values)
    assert torch.equal(evaluate(graph, image), model(image))


@pytest.mark.parametrize("padding,partial,branch", [
    ((1, 1, 2, 2), False, False),
    ((1, 2, 2, 2), False, False),
    ((1, 1, 2, 2), True, False),
    ((1, 1, 2, 2), False, True),
])
def test_window_matrix_convolution_recognition(padding, partial, branch):
    class WindowMatrix(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.register_buffer("weight", torch.randint(-20, 21, (2 * (2 if partial else 3) * 2, 3), dtype=torch.int32))
            self.register_buffer("bias", torch.tensor([13, -97, 127], dtype=torch.int32)[None, :, None, None])
            self.register_buffer("multiplier", torch.tensor([1, 3, 5], dtype=torch.int64)[None, :, None, None])

        def forward(self, image):
            padded = F.pad(image.to(torch.int32), padding)
            windows = padded.unfold(2, 5, 1).unfold(3, 3, 2)[..., ::2, ::2]
            if partial:
                windows = windows[..., 1:, :]
            patches = windows.permute(0, 2, 3, 1, 4, 5).flatten(3)
            result = (patches @ self.weight).permute(0, 3, 1, 2) + self.bias
            if branch:
                result = result + windows.sum().to(torch.int32)
            return ((result.to(torch.int64) * self.multiplier + 64) >> 7).clamp(0, 255).to(torch.uint8)

    torch.manual_seed(77)
    model = WindowMatrix()
    image = torch.randint(0, 256, (1, 2, 7, 9), dtype=torch.uint8)
    original = read(import_program(torch.export.export(model, (image,), strict=True)))
    convolution = window_convolutions(original)
    fused = quantized_convolutions(convolution)
    expected_fusion = not partial and not branch and padding[0] == padding[1]
    assert sum(value.operation == "quantized_convolution" for value in fused.values) == int(expected_fusion)
    assert torch.equal(evaluate(original, image), model(image))
    assert torch.equal(evaluate(convolution, image), model(image))
    assert torch.equal(evaluate(fused, image), model(image))


@pytest.mark.parametrize("branch", [False, True])
def test_integer_concatenation_scale_alignment(branch):
    class Aligned(torch.nn.Module):
        def __init__(self):
            super().__init__()
            self.register_buffer("first", torch.tensor([3, -7, (1 << 63)-1], dtype=torch.int64)[None, :, None, None])
            self.register_buffer("second", torch.tensor(13, dtype=torch.int64))

        def forward(self, image):
            first = image[:, 1:].to(torch.int64) * self.first
            second = image[:, :2].to(torch.int64) * self.second
            joined = torch.cat((first, second), dim=1)
            result = ((joined + 73) >> 3).clamp(-128, 127).to(torch.int8)
            return result.to(torch.int64) + joined if branch else result

    image = torch.randint(-128, 128, (1, 4, 3, 5), dtype=torch.int8)
    model = Aligned()
    original = read(import_program(torch.export.export(model, (image,), strict=True)))
    fused = quantized_concatenations(original)
    assert sum(value.operation == "quantized_concat" for value in fused.values) == int(not branch)
    assert torch.equal(evaluate(original, image), model(image))
    assert torch.equal(evaluate(fused, image), model(image))
