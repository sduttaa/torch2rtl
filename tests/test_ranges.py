import numpy as np
import pytest

from torch2rtl.graph import Value
from torch2rtl.lower import Tensor
from torch2rtl.ranges import bounds, storage_bits


@pytest.mark.parametrize("signed,low,high,expected,bits", [
    (False, 0, 63, (0, 63), 6),
    (True, -16, 15, (-16, 15), 5),
    (True, 0, 63, (0, 63), 7),
    (False, -1, 63, (0, 255), 8),
    (True, 0, 255, (-128, 127), 8),
])
def test_clamp_then_cast_bounds(signed, low, high, expected, bits):
    value = Value("conv", "quantized_convolution", (low, high), Tensor((1, 1, 1, 1), 8, signed))
    assert bounds(value) == expected
    assert storage_bits(value) == bits


def test_padding_cannot_inherit_source_range():
    source = Value("conv", "quantized_convolution", (0, 63), Tensor((1, 1, 1, 1), 8, True))
    pool = Value("pool", "max_pool2d", (source, (2, 2), (1, 1), (1, 1), (2, 2), False), source.tensor)
    assert bounds(pool) == (-128, 127)
    assert storage_bits(pool) == 8


def test_lookup_interprets_signed_input_and_output_bytes():
    source = Value("conv", "quantized_convolution", (-8, 7), Tensor((1, 1, 1, 1), 8, True))
    table = np.arange(256, dtype=np.uint8)
    result = Value("lookup", "byte_lookup", (source, table), source.tensor)
    assert bounds(result) == (-8, 7)
    assert storage_bits(result) == 4
