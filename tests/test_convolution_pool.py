from dataclasses import replace

import numpy as np
import pytest
import torch

from rtl_check import pack, simulate
from test_spatial_schedule import check_schedule
from torch2rtl.convolution import configuration, emit
from torch2rtl.cp_sat import solve
from torch2rtl.graph import Graph, Value, actors, evaluate, pooled_convolutions, reachable
from torch2rtl.lower import Tensor
from torch2rtl.ranges import storage_bits
from torch2rtl.network import edges
from torch2rtl.schedule import Limits
from torch2rtl.spatial_schedule import ActorConfig, Events, FifoConfig, problem


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
