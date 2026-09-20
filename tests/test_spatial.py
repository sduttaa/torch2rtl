import subprocess

import numpy as np
import pytest
import torch
from torch.nn import functional as F

from torch2rtl.graph import Value
from torch2rtl.lower import Tensor
from torch2rtl.spatial import emit_pool, emit_resize
from rtl_check import pack, simulate


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("shape,kernel,stride,padding,dilation,lanes,bits,signed", [
    ((5, 7, 3), (2, 2), (2, 2), (0, 0), (1, 1), 2, 8, False),
    ((7, 9, 5), (3, 3), (2, 2), (1, 1), (2, 2), 4, 8, True),
    ((1, 1, 1), (1, 1), (1, 1), (0, 0), (1, 1), 1, 8, True),
    ((5, 7, 3), (2, 3), (1, 2), (0, 1), (1, 1), 2, 16, True),
    ((9, 11, 5), (3, 4), (3, 4), (0, 0), (1, 1), 2, 8, True),
    ((5, 7, 1), (2, 3), (2, 3), (0, 0), (1, 1), 4, 16, True),
    ((8, 6, 3), (4, 6), (4, 6), (0, 0), (1, 1), 4, 8, False),
    ((4, 9, 5), (1, 3), (1, 3), (0, 0), (1, 1), 3, 8, True),
    ((9, 4, 5), (3, 1), (3, 1), (0, 0), (1, 1), 3, 8, False),
])
def test_max_pool_stream(tmp_path, shape, kernel, stride, padding, dilation, lanes, bits, signed, stalls):
    height, width, channels = shape
    generator = np.random.default_rng(73)
    source = Value("input", "input", (), Tensor((1, channels, height, width), bits, signed))
    input_words, expected_words = [], []
    low, high = (-(1 << (bits-1)), 1 << (bits-1)) if signed else (0, 1 << bits)
    for _ in range(3):
        frame = generator.integers(low, high, (1, channels, height, width))
        expected = F.max_pool2d(torch.from_numpy(frame).float(), kernel, stride, padding, dilation).to(torch.int32).numpy()
        input_words.extend(word for pixel in frame.transpose(0, 2, 3, 1).reshape(-1, channels)
                           for word in pack(pixel, bits, lanes))
        expected_words.extend(word for pixel in expected.transpose(0, 2, 3, 1).reshape(-1, channels)
                              for word in pack(pixel, bits, lanes))
    actor = Value("pool", "max_pool2d", (source, kernel, stride, padding, dilation, False),
                  Tensor(tuple(expected.shape), bits, signed))
    simulate(tmp_path, emit_pool(actor, lanes), lanes*bits, lanes*bits, input_words, expected_words, stalls)


@pytest.mark.parametrize("stalls", [False, True])
@pytest.mark.parametrize("row_buffers", [1, 2, 3])
@pytest.mark.parametrize("shape,size,scale,mode,recompute,lanes", [
    ((3, 5, 3), None, (2.0, 2.0), "nearest", None, 2),
    ((4, 7, 5), (7, 11), None, "nearest", None, 4),
    ((7, 9, 2), (3, 4), None, "nearest", None, 1),
    ((7, 9, 2), (3, 4), None, "nearest-exact", None, 2),
    ((5, 7, 3), None, (1.3, 1.7), "nearest", False, 2),
    ((5, 7, 3), None, (1.3, 1.7), "nearest", True, 2),
    ((1, 1, 1), (1, 1), None, "nearest", None, 1),
    ((9, 7, 3), (1, 1), None, "nearest-exact", None, 2),
])
def test_nearest_stream(tmp_path, shape, size, scale, mode, recompute, lanes, stalls, row_buffers):
    height, width, channels = shape
    generator = np.random.default_rng(17)
    source = Value("input", "input", (), Tensor((1, channels, height, width), 8, True))
    input_words, expected_words = [], []
    for _ in range(5):
        frame = generator.integers(-128, 128, (1, channels, height, width))
        expected = F.interpolate(torch.from_numpy(frame).float(), size=size, scale_factor=scale,
                                 mode=mode, recompute_scale_factor=recompute).to(torch.int32).numpy()
        input_words.extend(word for pixel in frame.transpose(0, 2, 3, 1).reshape(-1, channels)
                           for word in pack(pixel, 8, lanes))
        expected_words.extend(word for pixel in expected.transpose(0, 2, 3, 1).reshape(-1, channels)
                              for word in pack(pixel, 8, lanes))
    actor = Value("resize", "__interpolate.size_list_scale_list", (source, size, scale, mode, None, recompute, False),
                  Tensor(tuple(expected.shape), 8, True))
    simulate(tmp_path, emit_resize(actor, lanes, row_buffers=row_buffers), lanes*8, lanes*8, input_words, expected_words, stalls)


@pytest.mark.parametrize("shape,size,mode,lanes,row_buffers", [
    ((1, 1, 1, 1), (1, 1), "nearest", 1, 2),
    ((1, 3, 3, 5), (7, 9), "nearest", 2, 3),
    ((1, 3, 9, 7), (1, 1), "nearest-exact", 2, 3),
])
def test_resize_memory_accesses_never_collide(tmp_path, shape, size, mode, lanes, row_buffers):
    source = Value("input", "input", (), Tensor(shape, 8, True))
    actor = Value("resize", "__interpolate.size_list_scale_list",
                  (source, size, None, mode, None, None, False), Tensor((*shape[:2], *size), 8, True))
    rtl = emit_resize(actor, lanes, row_buffers=row_buffers)
    assertions = """
    always @(posedge clk) if (!rst) begin
      assert (write_bank < ROW_BUFFERS);
      assert (read_bank < ROW_BUFFERS);
      assert (write_word < ROW_WORDS);
      assert (read_channel < CHANNEL_WORDS);
      assert (output_column < OUTPUT_WIDTH);
      if (store && issue) assert (write_address != read_address);
    end
"""
    marker = "    // Full and free banks are disjoint"
    assert rtl.count(marker) == 1
    (tmp_path / "resize.sv").write_text(rtl.replace(marker, assertions + marker))
    # Inputs and backpressure are arbitrary; only the first cycle must reset.
    (tmp_path / "proof.ys").write_text("""
read_verilog -formal -sv resize.sv
hierarchy -top inference
proc
flatten
memory_map
opt
async2sync
chformal -lower
sat -seq 6 -tempinduct -set-at 1 rst 1 -prove-asserts -verify
""")
    result = subprocess.run(["yosys", "-Q", "-T", "-s", "proof.ys"], cwd=tmp_path,
                            capture_output=True, text=True, timeout=30)
    (tmp_path / "proof.log").write_text(result.stdout + result.stderr)
    assert result.returncode == 0, result.stdout + result.stderr
    assert "Induction step proven: SUCCESS!" in result.stdout
