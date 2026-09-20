from dataclasses import replace
from pathlib import Path
import subprocess

import numpy as np
import pytest
import torch

from rtl_check import pack, simulate
from test_spatial_schedule import check_schedule
from torch2rtl.convolution import configuration, emit
from torch2rtl import convolution
from torch2rtl.cp_sat import solve
from torch2rtl.graph import Graph, Value, actors, evaluate, pooled_convolutions, reachable
from torch2rtl.lower import Tensor
from torch2rtl.ranges import storage_bits
from torch2rtl.network import edges
from torch2rtl.schedule import Limits
from torch2rtl.spatial_schedule import ActorConfig, Events, FifoConfig, problem


@pytest.mark.parametrize("parameters", [
    {"HEIGHT": 4, "WIDTH": 4, "INPUT_CHANNELS": 1, "OUTPUT_CHANNELS": 1, "POOL_H": 2, "POOL_W": 2},
    {"HEIGHT": 7, "WIDTH": 9, "INPUT_CHANNELS": 3, "OUTPUT_CHANNELS": 5, "KERNEL_H": 2, "KERNEL_W": 2,
     "LANES": 2, "REDUCTION_LANES": 1, "OUTPUT_LANES": 3, "POOL_H": 2, "POOL_W": 3, "MULTIPLIER_BYTES": 2},
    {"HEIGHT": 8, "WIDTH": 8, "INPUT_CHANNELS": 4, "OUTPUT_CHANNELS": 6, "GROUPS": 2,
     "LANES": 2, "REDUCTION_LANES": 2, "OUTPUT_LANES": 2, "POOL_H": 3, "POOL_W": 2},
])
def test_pool_comparison_uses_idle_accumulator_cycle(tmp_path, parameters):
    root = Path(convolution.__file__).parent / "templates"
    source = (root / "convolution.sv").read_text()
    assertions = """
  always @(posedge clk) if (!rst && POOL_ITEMS > 1 && pool_update) begin
    assert (!product_valid);
    assert (state == DOT || state == RQ);
    if (pool_last) begin
      assert (state == RQ);
      assert (accumulator_byte == BYTE_BITS'(ACCUMULATOR_BYTES-1));
      assert (multiplier_group == GROUP_BITS'(MULTIPLIER_GROUPS-1));
    end else assert (state == DOT && dot_step == 0);
  end
"""
    marker = source.rfind("endmodule")
    (tmp_path / "convolution.sv").write_text(source[:marker] + assertions + source[marker:]
                                            + (root / "window.sv").read_text())
    assignments = " ".join(f"-set {key} {value}" for key, value in parameters.items())
    (tmp_path / "proof.ys").write_text(f"""
read_verilog -formal -sv convolution.sv
chparam {assignments} integer_convolution
hierarchy -top integer_convolution
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


def example(shape=(1, 3, 7, 9), channels=5, kernel=(3, 3), stride=(1, 1), padding=(1, 1),
            dilation=(1, 1), groups=1, pool=(2, 2), signed=False, overflow=False):
    generator = np.random.default_rng(91)
    source = Value("image", "input", (), Tensor(shape, 8, signed))
    weight = generator.integers(-128, 128, (channels, shape[1]//groups, *kernel), dtype=np.int32)
    bias = generator.integers(-400, 400, channels, dtype=np.int32)
    if overflow:
        bias = np.resize(np.array([2147483647, -2147483648, 0], dtype=np.int32), channels)
    result_shape = (1, channels, *((size+2*pad-(extent-1)*dil-1)//step+1
        for size, pad, extent, dil, step in zip(shape[2:], padding, kernel, dilation, stride)))
    multiplier = np.resize(np.array([3, 0, 7, 11], dtype=np.int64), channels)
    conv = Value("convolution", "quantized_convolution",
        (source, weight, bias, stride, padding, dilation, groups, multiplier, 32, 7, -16, 15),
        Tensor(result_shape, 8, True))
    output = Value("pool", "max_pool2d", (conv, pool, pool, (0, 0), (1, 1), False),
        Tensor((1, channels, *(size//extent for size, extent in zip(result_shape[2:], pool))), 8, True))
    return Graph(source, output, reachable(output))


@pytest.mark.parametrize("layout", ["parallel", "packed"])
@pytest.mark.parametrize("kwargs,lanes,outputs,reduction", [
    ({}, 2, 3, 1),
    ({"shape": (1, 2, 9, 13), "kernel": (2, 3), "stride": (2, 1), "padding": (0, 1),
      "dilation": (2, 2), "pool": (2, 3), "signed": True}, 4, 2, 2),
    ({"shape": (1, 4, 5, 7), "channels": 6, "groups": 2, "overflow": True}, 2, 2, 1),
    ({"shape": (1, 1, 3, 5), "channels": 1, "kernel": (1, 1), "padding": (0, 0),
      "pool": (1, 3)}, 1, 1, 1),
    ({"shape": (1, 1, 5, 1), "channels": 1, "kernel": (3, 1), "padding": (1, 0),
      "pool": (2, 1)}, 1, 1, 1),
    ({"pool": (1, 1)}, 4, 2, 2),
])
def test_pooled_convolution_rtl(tmp_path, layout, kwargs, lanes, outputs, reduction):
    graph = example(**kwargs)
    fused = pooled_convolutions(graph)
    assert len(fused.values) == 2
    assert fused.output.operation == "quantized_convolution_pool"
    assert storage_bits(fused.output) == 5
    generator = torch.Generator().manual_seed(83)
    inputs, expected = [], []
    for _ in range(3):
        signed = graph.input.tensor.signed
        image = torch.randint(-128 if signed else 0, 128 if signed else 256, graph.input.tensor.shape,
                              dtype=torch.int8 if signed else torch.uint8, generator=generator)
        result = evaluate(graph, image)
        assert torch.equal(evaluate(fused, image), result)
        for value, stream in ((image, inputs), (result, expected)):
            stream.extend(word for pixel in value.permute(0, 2, 3, 1).reshape(-1, value.shape[1])
                          for word in pack(pixel, 8, lanes))
    simulate(tmp_path, emit(fused.output, lanes, outputs, line_layout=layout, reduction_lanes=reduction),
             lanes*8, lanes*8, inputs, expected, True, max_cycles=200000)


@pytest.mark.parametrize("case", ["negative", "overflow", "cast", "branch", "overlap", "ceil", "padding", "dilation"])
def test_unproved_fusion_is_rejected(case):
    graph = example()
    conv = graph.output.args[0]
    args = list(conv.args)
    if case == "negative":
        args[7] = np.full(5, -1, dtype=np.int64)
    elif case == "overflow":
        args[7] = np.full(5, 1 << 40, dtype=np.int64)
    elif case == "cast":
        args[10:12] = (-129, 128)
    conv = replace(conv, args=tuple(args))
    pool_args = [conv, *graph.output.args[1:]]
    if case == "overlap":
        pool_args[2] = (1, 1)
    elif case == "ceil":
        pool_args[5] = True
    elif case == "padding":
        pool_args[3] = (1, 1)
    elif case == "dilation":
        pool_args[4] = (2, 2)
    output = replace(graph.output, args=tuple(pool_args))
    if case == "branch":
        output = Value("branches", "cat", ((conv, output), 1), output.tensor)
    graph = Graph(graph.input, output, reachable(output))
    assert not any(value.operation == "quantized_convolution_pool" for value in pooled_convolutions(graph).values)
    if case in ("negative", "overflow", "cast"):
        malformed = Value("pool", "quantized_convolution_pool", (*conv.args, (2, 2)), graph.output.tensor)
        with pytest.raises(ValueError, match="monotone"):
            configuration(malformed, 2, 2)


@pytest.mark.parametrize("layout,outputs,reduction,pool", [
    ("parallel", 5, 2, (2, 2)), ("parallel", 2, 1, (2, 3)), ("packed", 2, 2, (2, 2)),
])
def test_pooled_convolution_deadlines(tmp_path, layout, outputs, reduction, pool):
    graph = pooled_convolutions(example(pool=pool))
    check_schedule(tmp_path, graph, 2, {graph.output.name: {"selected": ActorConfig(outputs, reduction, layout)}}, frames=5)


def test_optional_fusion_is_explicit():
    graph = example()
    assert actors(graph).output.operation == "max_pool2d"
    assert actors(graph, ("convolution_pool",)).output.operation == "quantized_convolution_pool"
    with pytest.raises(ValueError, match="Unknown optional fusion"):
        actors(graph, ("unknown",))


@pytest.mark.parametrize("outputs", [2, 5])
@pytest.mark.parametrize("layout", ["parallel", "packed"])
def test_implied_window_paths_preserve_optimum(monkeypatch, outputs, layout):
    graph = pooled_convolutions(example(shape=(1, 3, 5, 7)))
    options = {graph.output.name: {"selected": ActorConfig(outputs, 1, layout)}}
    fifos = {name: {"selected": FifoConfig(8)} for name, *_ in edges(graph)}
    strengthened = problem(graph, 2, options, fifos, {}, 20000, 50000)
    with monkeypatch.context() as patch:
        patch.setattr(Events, "implied", lambda *args: None)
        original = problem(graph, 2, options, fifos, {}, 20000, 50000)
    first, second = solve(strengthened, Limits(seconds=20)), solve(original, Limits(seconds=20))
    assert first.status == second.status == "OPTIMAL"
    assert first.period == second.period
