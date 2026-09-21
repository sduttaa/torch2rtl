import numpy as np
import pytest
import torch

from rtl_check import pack, simulate
from test_spatial_schedule import check_schedule
from torch2rtl.fusion import fuse, geometry
from torch2rtl.graph import Graph, Value, evaluate, reachable
from torch2rtl.lower import Tensor
from torch2rtl.network import edges, emit
from torch2rtl.spatial_schedule import ActorConfig


def network(shape=(7, 11), kernel=(3, 3), dilation=(1, 1), groups=1, channels=4, narrow=False, signed=False):
    image = Value("pixels", "input", (), Tensor((1, channels, *shape), 8, signed))
    source=image
    if narrow:
        table=np.array([index%16-(8 if signed else 0) for index in range(256)],dtype=np.int8 if signed else np.uint8)
        source=Value("narrow","byte_lookup",(image,table),image.tensor)
    pooled = Value("pool", "max_pool2d", (source, (2,2), (2,2), (0,0), (1,1), False),
                   Tensor((1, channels, shape[0]//2, shape[1]//2), 8, signed))
    resized = Value("resize", "__interpolate.size_list_scale_list",
                    (pooled, shape, None, "nearest-exact", None, None, False), source.tensor)
    multipliers = (np.arange(channels, dtype=np.int64)+1, np.arange(channels, dtype=np.int64)-2)
    if narrow:
        multipliers=tuple(values*37 for values in multipliers)
    joined = Value("join", "quantized_concat", ((resized, source), multipliers, 8, 4, -128 if narrow else -16, 127 if narrow else 15),
                   Tensor((1, 2*channels, *shape), 8, True))
    rng = np.random.default_rng(67)
    padding = tuple((extent-1)*dil//2 for extent,dil in zip(kernel,dilation))
    weights = rng.integers(-3, 4, (4, 2*channels//groups, *kernel), dtype=np.int32)
    output = Value("result", "quantized_convolution",
        (joined, weights, np.arange(4, dtype=np.int32), (1,1), padding, dilation, groups,
         np.array([3,7,1,5], dtype=np.int64), 7, 4, -128,127), Tensor((1,4,*shape),8,True))
    return Graph(image,output,reachable(output))


@pytest.mark.parametrize("signed",[False,True])
def test_scale_alignment_after_read_preserves_narrow_signed_and_unsigned_sources(tmp_path,monkeypatch,signed):
    from torch.nn import functional as functional
    interpolate=functional.interpolate
    monkeypatch.setattr(functional,"interpolate",lambda data,*args,**kwargs:interpolate(data.float(),*args,**kwargs).to(data.dtype))
    original=network(shape=(4,8),narrow=True,signed=signed)
    graph=fuse(original,4)
    assert all(g["bits"] == 4 and g["quantize_on_read"] for g in geometry(graph.output,4))
    source,expected=[],[]
    torch.manual_seed(909)
    for _ in range(3):
        image=torch.randint(-128 if signed else 0,128 if signed else 256,graph.input.tensor.shape,
                            dtype=torch.int8 if signed else torch.uint8)
        result=evaluate(original,image)
        assert torch.equal(result,evaluate(graph,image))
        for data,words in ((image,source),(result,expected)):
            words.extend(word for pixel in data.permute(0,2,3,1).reshape(-1,data.shape[1]) for word in pack(pixel,8,4))
    rtl=emit(graph,4,{"result":2},{name:512 for name,*_ in edges(graph)},reduction_lanes={"result":4})
    simulate(tmp_path,rtl,32,32,source,expected,True,max_cycles=200000)


@pytest.mark.parametrize("lanes,kernel,dilation,groups,channels", [
    (1,(1,1),(1,1),1,4), (2,(3,3),(1,1),1,4), (4,(3,3),(2,1),2,4),
    (1,(3,3),(1,1),1,1)])
@pytest.mark.parametrize("stalls", [False,True])
def test_compact_view_preserves_values_and_backpressure(tmp_path, lanes, kernel, dilation, groups, channels, stalls):
    original = network(kernel=kernel,dilation=dilation,groups=groups,channels=channels)
    graph = fuse(original,lanes)
    assert graph.output.operation == "quantized_view_convolution"
    assert not any(v.operation in ("quantized_concat","__interpolate.size_list_scale_list") for v in graph.values)
    source, expected = [], []
    torch.manual_seed(613)
    for _ in range(4):
        image=torch.randint(0,256,graph.input.tensor.shape,dtype=torch.uint8)
        reference=evaluate(original,image)
        assert torch.equal(reference,evaluate(graph,image))
        for array, destination in ((image,source),(reference,expected)):
            destination.extend(word for pixel in array.permute(0,2,3,1).reshape(-1,array.shape[1])
                               for word in pack(pixel,8,lanes))
    rtl=emit(graph,lanes,{"result":2},{name:512 for name,*_ in edges(graph)},
             reduction_lanes={"result":lanes})
    simulate(tmp_path,rtl,lanes*8,lanes*8,source,expected,stalls,max_cycles=200000)


def test_hybrid_weight_rom_preserves_the_read_pipeline(tmp_path):
    from torch2rtl.convolution import emit as emit_convolution
    from torch2rtl.fusion import materialized
    graph=fuse(network(shape=(4,6)),2)
    value=materialized(graph.output)
    image=torch.randint(-16,16,value.args[0].tensor.shape,dtype=torch.int8)
    direct=Graph(value.args[0],value,(value.args[0],value))
    expected=evaluate(direct,image)
    source_words=[word for pixel in image.permute(0,2,3,1).reshape(-1,image.shape[1]) for word in pack(pixel,8,2)]
    result_words=[word for pixel in expected.permute(0,2,3,1).reshape(-1,expected.shape[1]) for word in pack(pixel,8,2)]
    rtl=emit_convolution(value,2,2,reduction_lanes=2,weight_block_depth=32)
    simulate(tmp_path,rtl,16,16,source_words,result_words,True,max_cycles=50000)


@pytest.mark.parametrize("extra_rows",[0,1,(0,5),(3,0)])
def test_fused_view_periodic_deadlines(tmp_path,extra_rows):
    graph=fuse(network(shape=(4,6)),2)
    options={value.name:{"selected":ActorConfig(2,2,extra_rows=extra_rows)
             if value is graph.output else ActorConfig()}
             for value in graph.values if value is not graph.input}
    check_schedule(tmp_path,graph,2,options,(1,3,32,128),frames=4)


def test_rolling_source_buffers_overlap_frames_without_external_branch_storage(tmp_path):
    graph=fuse(network(shape=(8,10)),2)
    extra=(0,1)
    assert all(g["rolling"] for g in geometry(graph.output,2,extra))
    options={value.name:{"selected":ActorConfig(2,2,extra_rows=extra)
             if value is graph.output else ActorConfig()}
             for value in graph.values if value is not graph.input}
    solution=check_schedule(tmp_path,graph,2,options,(1,3,8),frames=5)
    advance=solution.offsets["result.actor.advance.0"]
    assert any(solution.offsets[f"result.in{port}.0"]+solution.period<advance
               for port in range(2))


def test_nondivisible_row_buffers_keep_the_per_frame_contract():
    graph=fuse(network(shape=(7,11)),2)
    for g in geometry(graph.output,2):
        assert g["rolling"] == (g["words"] % g["depth"] == 0)
        if not g["rolling"]:
            assert max(g["limits"])<=g["words"]


def test_ragged_vector_boundary_retains_original_actors():
    original=network(channels=3)
    assert fuse(original,2).output.operation == "quantized_convolution"
    assert fuse(original,1).output.operation == "quantized_view_convolution"


def test_narrow_quantized_export_uses_the_same_fusion(tmp_path):
    from test_network import TinyBranched
    from torch2rtl.frontend import import_program
    from torch2rtl.graph import actors,read
    torch.manual_seed(914)
    model=TinyBranched(activation_bits=4,raw_output=True)
    images=[torch.randint(0,256,(1,3,6,10),dtype=torch.uint8) for _ in range(3)]
    graph=actors(read(import_program(torch.export.export(model,(images[0],),strict=True))),
                 ["resize_concat_convolution"],1)
    assert graph.output.operation == "quantized_view_convolution"
    outputs={value.name:1 for value in graph.values if value.operation in
             ("quantized_convolution","quantized_view_convolution")}
    rtl=emit(graph,1,outputs,{name:512 for name,*_ in edges(graph)})
    source_words=[]
    expected_words=[]
    for image in images:
        result=model(image)
        assert torch.equal(result,evaluate(graph,image))
        for array,words in ((image,source_words),(result,expected_words)):
            words.extend(int(item)&255 for item in array.permute(0,2,3,1).flatten())
    simulate(tmp_path,rtl,8,8,source_words,expected_words,True,max_cycles=200000)


def test_affine_coordinate_factoring_is_exact_and_keeps_irregular_fallback():
    from torch2rtl.fusion import affine_table
    values=[0]+[3*((i-1)//2) for i in range(1,31)]
    valid=[False]+[True]*30
    shift,step,bases=affine_table(values,valid)
    assert shift==1
    assert all(not included or value==(i >> shift)*step+bases[i % (1 << shift)]
               for i,(value,included) in enumerate(zip(values,valid)))
    assert affine_table([i*i for i in range(64)],[True]*64) is None


def test_fused_view_has_explicit_verilator_widths(tmp_path):
    import subprocess
    graph=fuse(network(shape=(4,8)),2)
    rtl=emit(graph,2,{"result":2},{name:8 for name,*_ in edges(graph)})
    (tmp_path/"inference.sv").write_text(rtl)
    subprocess.run(["verilator","--lint-only","--top-module","inference","inference.sv"],
                   cwd=tmp_path,check=True,capture_output=True,text=True)


@pytest.mark.parametrize('shape,kernel,dilation',[((7,11),(3,3),(1,1)),((4,8),(1,1),(1,1)),
                                                 ((9,13),(3,3),(2,2))])
def test_word_release_never_overwrites_a_future_window(shape,kernel,dilation):
    graph=fuse(network(shape=shape,kernel=kernel,dilation=dilation),2)
    value=graph.output
    height,width=value.tensor.shape[2:]
    for g in geometry(value,2):
        accessed=[]
        for y in range(height):
            for x in range(width):
                accessed.append([row*g['row_words']+column*2+channel
                    for row in g['row_map'][y*kernel[0]:(y+1)*kernel[0]]
                    for column in g['column_map'][x*kernel[1]:(x+1)*kernel[1]]
                    for channel in range(2) if row>=0 and column>=0])
        first=g['words']
        for pixel in reversed(range(len(accessed))):
            first=min([first,*accessed[pixel]])
            assert g['limits'][pixel] <= first+g['depth']
        assert g['limits']==sorted(g['limits'])
    assert any(limit>g['row_limits'][pixel//width]
               for g in geometry(value,2) for pixel,limit in enumerate(g['limits']))
