import numpy as np
import pytest
import torch

from rtl_check import pack, simulate
from test_network import TinyBranched
from torch2rtl.cp_sat import solve
from torch2rtl.frontend import import_program
from torch2rtl.graph import Graph, Value, actors, evaluate, read
from torch2rtl.lower import Tensor
from torch2rtl.network import edges, emit
from torch2rtl.schedule import Limits
from torch2rtl.spatial_schedule import ActorConfig, Events, FifoConfig, problem, words


def check_schedule(directory, graph, lanes, actor_options, fifo_depths=(1, 2, 8), frames=4, budgets=None):
    fifo_options = {name: {str(depth): FifoConfig(depth, {"slots": depth}) for depth in fifo_depths}
                    for name, *_ in edges(graph)}
    model = problem(graph, lanes, actor_options, fifo_options, {"slots": len(fifo_options)*max(fifo_depths), **(budgets or {})},
                    20000, 50000, {"slots": 1})
    solution = solve(model, Limits(seconds=20))
    assert solution.status in ("OPTIMAL", "FEASIBLE"), solution
    choices = {value.name: actor_options[value.name][solution.selected["actor:"+value.name]]
               for value in graph.values if value is not graph.input}
    outputs = {name: config.output_lanes for name, config in choices.items() if config.output_lanes is not None}
    reductions = {name: config.reduction_lanes for name, config in choices.items() if config.reduction_lanes is not None}
    memories = {name: {"line_layout": config.line_layout} for name, config in choices.items() if config.output_lanes is not None}
    memories.update({value.name: {"row_buffers": choices[value.name].row_buffers} for value in graph.values
                     if value.operation == "__interpolate.size_list_scale_list"})
    depths = {name: fifo_options[name][solution.selected["fifo:"+name]].depth for name in fifo_options}
    rtl = emit(graph, lanes, outputs, depths, memories, reductions)
    torch.manual_seed(81)
    input_words, expected_words = [], []
    input_cycles, output_cycles = [], []
    for frame in range(frames):
        image = torch.randint(0, 256, graph.input.tensor.shape, dtype=torch.uint8)
        expected = evaluate(graph, image)
        for value, destination in ((image, input_words), (expected, expected_words)):
            destination.extend(word for pixel in value.permute(0, 2, 3, 1).reshape(-1, value.shape[1])
                               for word in pack(pixel, 8, lanes))
        for value, destination in ((graph.input, input_cycles), (graph.output, output_cycles)):
            destination.extend(3 + frame*solution.period + solution.offsets[f"{value.name}.out.{index}"]
                               for index in range(words(value.tensor, lanes)))
    simulate(directory, rtl, lanes*8, lanes*8, input_words, expected_words, False,
             max_cycles=max(input_cycles+output_cycles)+10, transfer_cycles=(input_cycles, output_cycles))
    return solution


@pytest.mark.parametrize("lanes,reduction,layout", [(1, 1, "parallel"), (2, 1, "parallel"),
                                                   (4, 2, "parallel"), (4, 1, "packed")])
@pytest.mark.parametrize("groups,kernel,stride,padding,dilation", [
    (1, (3, 3), (1, 1), (1, 1), (1, 1)),
    (1, (2, 3), (2, 1), (0, 1), (2, 1)),
])
def test_convolution_deadlines(tmp_path, lanes, reduction, layout, groups, kernel, stride, padding, dilation):
    source = Value("image", "input", (), Tensor((1, 3, 5, 7), 8, False))
    generator = np.random.default_rng(43)
    weight = generator.integers(-20, 21, (5, 3, *kernel), dtype=np.int32)
    shape = (1, 5, *((length+2*pad-(extent-1)*dil-1)//step+1
        for length, pad, extent, dil, step in zip((5, 7), padding, kernel, dilation, stride)))
    output = Value("convolution", "quantized_convolution",
        (source, weight, np.arange(5, dtype=np.int32), stride, padding, dilation, groups,
         np.array([3, 7, 11, 9, 5], dtype=np.int64), 32, 6, 0, 255), Tensor(shape, 8, False))
    graph = Graph(source, output, (source, output))
    check_schedule(tmp_path, graph, lanes, {output.name: {"selected": ActorConfig(2, reduction, layout)}})


@pytest.mark.parametrize("shape,kernel,stride,padding,dilation", [
    ((1, 3, 5, 7), (2, 2), (2, 2), (0, 0), (1, 1)),
    ((1, 1, 8, 6), (4, 6), (4, 6), (0, 0), (1, 1)),
    ((1, 3, 5, 7), (2, 3), (1, 2), (0, 1), (1, 1)),
    ((1, 3, 7, 9), (3, 3), (2, 2), (1, 1), (2, 2)),
])
def test_pool_deadlines(tmp_path, shape, kernel, stride, padding, dilation):
    source = Value("image", "input", (), Tensor(shape, 8, False))
    result_shape = (1, shape[1], *((length+2*pad-(extent-1)*dil-1)//step+1
        for length, pad, extent, dil, step in zip(shape[2:], padding, kernel, dilation, stride)))
    output = Value("pool", "max_pool2d", (source, kernel, stride, padding, dilation, False), Tensor(result_shape, 8, False))
    check_schedule(tmp_path, Graph(source, output, (source, output)), 2, {output.name: {"selected": ActorConfig()}})


@pytest.mark.parametrize("row_buffers", [1, 2, 3])
@pytest.mark.parametrize("shape,size,scale,mode,recompute", [
    ((1, 3, 3, 5), None, (2., 2.), "nearest", None),
    ((1, 3, 7, 9), (3, 4), None, "nearest-exact", None),
    ((1, 3, 9, 7), (1, 1), None, "nearest-exact", None),
    ((1, 3, 5, 7), None, (1.3, 1.7), "nearest", False),
])
def test_resize_deadlines(tmp_path, shape, size, scale, mode, recompute, row_buffers):
    source = Value("image", "input", (), Tensor(shape, 8, False))
    result_shape = tuple(torch.nn.functional.interpolate(torch.zeros(shape), size=size, scale_factor=scale,
                         mode=mode, recompute_scale_factor=recompute).shape)
    output = Value("resize", "__interpolate.size_list_scale_list",
                   (source, size, scale, mode, None, recompute, False), Tensor(result_shape, 8, False))
    check_schedule(tmp_path, Graph(source, output, (source, output)), 2,
                   {output.name: {"selected": ActorConfig(row_buffers=row_buffers)}}, frames=6)


def test_row_buffer_choice_improves_resampling_overlap(tmp_path):
    source = Value("image", "input", (), Tensor((1, 1, 3, 5), 8, False))
    output = Value("resize", "__interpolate.size_list_scale_list",
                   (source, None, (2., 2.), "nearest", None, None, False), Tensor((1, 1, 6, 10), 8, False))
    graph = Graph(source, output, (source, output))
    options = {output.name: {str(count): ActorConfig(row_buffers=count, resources={"row_slots": count})
                             for count in (1, 2)}}
    single = check_schedule(tmp_path/'single', graph, 1, options, (1, 2), frames=6, budgets={"row_slots": 1})
    double = check_schedule(tmp_path/'double', graph, 1, options, (1, 2), frames=6, budgets={"row_slots": 2})
    assert single.selected['actor:resize'] == '1'
    assert double.selected['actor:resize'] == '2'
    assert double.period < single.period


def branched(activation_bits=8):
    torch.manual_seed(41)
    model = TinyBranched(activation_bits=activation_bits)
    image = torch.zeros((1, 3, 6, 10), dtype=torch.uint8)
    return actors(read(import_program(torch.export.export(model, (image,), strict=True))))


@pytest.mark.parametrize("activation_bits", [5, 8])
def test_joint_branch_schedule_and_fifo_occupancy(tmp_path, activation_bits):
    graph = branched(activation_bits)
    options = {value.name: {"selected": ActorConfig(1, 2) if value.operation == "quantized_convolution" else ActorConfig()}
               for value in graph.values if value is not graph.input}
    small = {name: {"one": FifoConfig(1)} for name, *_ in edges(graph)}
    assert solve(problem(graph, 2, options, small, {}, 20000, 50000), Limits(seconds=10)).status == "INFEASIBLE"
    solution = check_schedule(tmp_path, graph, 2, options, (1, 2, 8, 32, 128), frames=6)
    assert any(int(value) > 1 for name, value in solution.selected.items() if name.startswith("fifo:"))


def test_joint_actor_parameter_choice(tmp_path):
    source = Value("image", "input", (), Tensor((1, 2, 3, 5), 8, False))
    output = Value("convolution", "quantized_convolution",
        (source, np.ones((4, 2, 1, 1), dtype=np.int32), np.zeros(4, dtype=np.int32), (1, 1), (0, 0),
         (1, 1), 1, np.ones(4, dtype=np.int64), 4, 3, 0, 255), Tensor((1, 4, 3, 5), 8, False))
    graph = Graph(source, output, (source, output))
    options = {output.name: {"serial": ActorConfig(1, 2, resources={"multipliers": 2}),
                            "parallel": ActorConfig(2, 2, resources={"multipliers": 4})}}
    slow = check_schedule(tmp_path / "slow", graph, 2, options, budgets={"multipliers": 2})
    fast = check_schedule(tmp_path / "fast", graph, 2, options, budgets={"multipliers": 4})
    assert slow.selected["actor:convolution"] == "serial"
    assert fast.selected["actor:convolution"] == "parallel"
    assert fast.period < slow.period


def test_summed_cycle_bounds_preserve_the_unrestricted_optimum(monkeypatch):
    graph = branched(5)
    options = {value.name: {"selected": ActorConfig(2 if value.tensor.shape[1] > 1 else 1, 2)
               if value.operation == "quantized_convolution" else ActorConfig()}
               for value in graph.values if value is not graph.input}
    fifos = {name: {"selected": FifoConfig(128)} for name, *_ in edges(graph)}
    model = problem(graph, 2, options, fifos, {}, 20000, 50000)
    bounds = [edge for edge in model.dependencies if edge.before == edge.after]
    assert bounds and all(edge.frames == 1 and edge.delay > 0 for edge in bounds)
    with monkeypatch.context() as patch:
        patch.setattr(Events, "implied", lambda *args: None)
        original = problem(graph, 2, options, fifos, {}, 20000, 50000)
    strengthened = solve(model, Limits(seconds=20))
    baseline = solve(original, Limits(seconds=20))
    assert strengthened.status == baseline.status == "OPTIMAL"
    assert strengthened.period == baseline.period
    assert strengthened.period >= max(edge.delay for edge in bounds)


@pytest.mark.parametrize("layout", ["parallel", "packed"])
def test_single_tile_window_release(tmp_path, layout):
    source = Value("image", "input", (), Tensor((1, 1, 3, 1), 8, False))
    output = Value("convolution", "quantized_convolution",
        (source, np.ones((1, 1, 3, 1), dtype=np.int32), np.zeros(1, dtype=np.int32), (1, 1), (1, 0),
         (1, 1), 1, np.ones(1, dtype=np.int64), 4, 3, 0, 255), Tensor((1, 1, 3, 1), 8, False))
    graph = Graph(source, output, (source, output))
    check_schedule(tmp_path, graph, 1, {output.name: {"selected": ActorConfig(1, 1, layout)}})
