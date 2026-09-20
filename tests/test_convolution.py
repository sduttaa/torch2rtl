import numpy as np
import pytest
import torch

from torch2rtl.convolution import configuration, emit
from torch2rtl.graph import Value, integer_convolution
from torch2rtl.lower import Tensor
from rtl_check import pack, simulate


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("shape,channels,kernel,stride,padding,dilation,groups,lanes,outputs,signed,overflow", [
    ((3, 5, 3), 5, (3, 3), (1, 1), (1, 1), (1, 1), 1, 2, 3, False, False),
    ((4, 7, 2), 4, (2, 3), (2, 2), (0, 1), (1, 1), 1, 1, 2, True, False),
    ((5, 6, 2), 3, (2, 2), (1, 1), (1, 0), (2, 2), 1, 2, 3, False, False),
    ((3, 4, 4), 6, (3, 3), (1, 1), (1, 1), (1, 1), 2, 2, 2, False, False),
    ((2, 3, 3), 3, (1, 1), (1, 1), (0, 0), (1, 1), 3, 1, 1, True, False),
    ((1, 1, 1), 1, (1, 1), (1, 1), (0, 0), (1, 1), 1, 1, 1, False, False),
    ((3, 4, 3), 4, (3, 3), (1, 1), (1, 1), (1, 1), 1, 2, 2, True, True),
    ((2, 3, 2), 3, (1, 1), (1, 1), (0, 0), (1, 1), 1, 4, 3, False, True),
])
def test_folded_convolution(tmp_path, shape, channels, kernel, stride, padding, dilation,
                            groups, lanes, outputs, signed, overflow, stalls):
    generator = np.random.default_rng(23)
    height, width, inputs = shape
    weight = generator.integers(-128, 128, (channels, inputs // groups, *kernel), dtype=np.int32)
    bias = generator.integers(-2000, 2000, channels, dtype=np.int32)
    multiplier = np.resize(np.array([3, -7, 0, 13, 19], dtype=np.int64), channels)
    offset, shift = 1 << 10, 11
    if overflow:
        bias = np.resize(np.array([2147483647, -2147483648, 5], dtype=np.int32), channels)
        multiplier = np.resize(np.array([(1 << 63)-1, -(1 << 63), (1 << 61)+11, -3], dtype=np.int64), channels)
        offset, shift = (1 << 63)-1, 56
    result_shape = (1, channels, *((size+2*pad-(extent-1)*dil-1)//step+1
        for size, pad, extent, dil, step in zip((height, width), padding, kernel, dilation, stride)))
    source = Value("input", "input", (), Tensor((1, inputs, height, width), 8, signed))
    actor = Value("convolution", "quantized_convolution",
                  (source, weight, bias, stride, padding, dilation, groups, multiplier, offset, shift, -128, 127),
                  Tensor(result_shape, 8, True))
    input_words, expected_words = [], []
    for _ in range(3):
        image = generator.integers(-128 if signed else 0, 128 if signed else 256,
                                   (1, inputs, height, width), dtype=np.int8 if signed else np.uint8)
        accumulation = integer_convolution(torch.from_numpy(image).to(torch.int32), torch.from_numpy(weight),
                                          torch.from_numpy(bias), stride, padding, dilation, groups)
        scaled = accumulation.to(torch.int64) * torch.from_numpy(multiplier)[None, :, None, None]
        expected = ((scaled + offset) >> shift).clamp(-128, 127).to(torch.int8).numpy()
        input_words.extend(word for pixel in image.transpose(0, 2, 3, 1).reshape(-1, inputs)
                           for word in pack(pixel, 8, lanes))
        expected_words.extend(word for pixel in expected.transpose(0, 2, 3, 1).reshape(-1, channels)
                              for word in pack(pixel, 8, lanes))
    simulate(tmp_path, emit(actor, lanes, outputs), lanes*8, lanes*8, input_words, expected_words, stalls)


def test_rejects_group_boundaries_inside_vectors():
    source = Value("input", "input", (), Tensor((1, 6, 3, 3), 8, False))
    actor = Value("convolution", "quantized_convolution",
                  (source, np.ones((4, 3, 1, 1), dtype=np.int32), np.zeros(4, dtype=np.int32),
                   (1, 1), (0, 0), (1, 1), 2, np.ones(4, dtype=np.int64), 0, 0, 0, 255),
                  Tensor((1, 4, 3, 3), 8, False))
    with pytest.raises(ValueError, match="boundaries"):
        configuration(actor, 2, 1)


def test_range_narrowing_preserves_offset_cancellation(tmp_path):
    source = Value("input", "input", (), Tensor((1, 1, 1, 256), 8, False))
    actor = Value("convolution", "quantized_convolution",
                  (source, np.ones((1, 1, 1, 1), dtype=np.int32), np.array([1 << 20], dtype=np.int32),
                   (1, 1), (0, 0), (1, 1), 1, np.array([3], dtype=np.int64), -(3 << 20), 0, 0, 255),
                  Tensor((1, 1, 1, 256), 8, False))
    parameters = configuration(actor, 1, 1)
    assert parameters["REQUANT_BITS"] == 11
    assert parameters["ACCUMULATOR_BITS"] < 32
    words = list(range(256))
    simulate(tmp_path, emit(actor, 1, 1), 8, 8, words, [min(255, 3*value) for value in words], True)
