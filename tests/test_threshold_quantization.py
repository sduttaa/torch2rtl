import numpy as np
import pytest
import torch

from rtl_check import pack, simulate
from test_spatial_schedule import check_schedule
from torch2rtl.convolution import configuration, emit, threshold_table
from torch2rtl.graph import Graph, Value, evaluate, pooled_convolutions, reachable
from torch2rtl.lower import Tensor
from torch2rtl.spatial_schedule import ActorConfig


@pytest.mark.parametrize('low,high,offset', [(0,15,32),(-8,7,-15),(3,13,400),(7,7,0)])
def test_threshold_boundaries_match_integer_arithmetic(low,high,offset):
    coefficients=[0,1,3,71,1024]
    bits,table=threshold_table(coefficients,offset,6,low,high,12)
    for channel,coefficient in enumerate(coefficients):
        thresholds=table[channel*(1<<bits):(channel+1)*(1<<bits)]
        for accumulator in range(-2048,2048):
            code=0
            for bit in reversed(range(bits)):
                trial=code | (1<<bit)
                if accumulator >= thresholds[trial]:code=trial
            expected=min(high,max(low,(accumulator*coefficient+offset)>>6))
            assert low+code==expected


def test_wrapping_or_nonmonotone_quantizers_keep_multiplication():
    assert threshold_table([-1],0,3,0,15,32) is None
    assert threshold_table([1<<40],0,3,0,15,32) is None
    assert threshold_table([1],0,3,0,255,32) is None


@pytest.mark.parametrize('coefficients', [(0,1),(-1,0)])
def test_single_bit_coefficient_has_exact_short_tile_deadlines(tmp_path,coefficients):
    source=Value('image','input',(),Tensor((1,1,1,5),8,False))
    actor=Value('conv','quantized_convolution',
        (source,np.array([-3,7],dtype=np.int32).reshape(2,1,1,1),np.array([-17,23],dtype=np.int32),
         (1,1),(0,0),(1,1),1,np.array(coefficients,dtype=np.int64),3,2,-128,127),
        Tensor((1,2,1,5),8,True))
    assert configuration(actor,1,1,1,'overlap_shift_add')['MULTIPLIER_BITS']==1
    graph=Graph(source,actor,(source,actor))
    check_schedule(tmp_path,graph,1,{'conv':{'selected':ActorConfig(1,1,requantization='overlap_shift_add')}},frames=4)


def example(pooled=False,overflow=False,low=0,high=15):
    source=Value('image','input',(),Tensor((1,3,4,6),8,False))
    rng=np.random.default_rng(813)
    weights=rng.integers(-7,8,(5,3,3,3),dtype=np.int32)
    biases=np.array([17,-23,3,100,5],dtype=np.int32)
    if overflow:biases=np.array([2147483647,-2147483648,0,17,-19],dtype=np.int32)
    output=Value('conv','quantized_convolution',
        (source,weights,biases,(1,1),(1,1),(1,1),1,np.array([3,7,0,11,1],dtype=np.int64),32,7,low,high),
        Tensor((1,5,4,6),8,low<0))
    if pooled:
        output=Value('pool','max_pool2d',(output,(2,2),(2,2),(0,0),(1,1),False),Tensor((1,5,2,3),8,low<0))
    graph=Graph(source,output,reachable(output))
    return pooled_convolutions(graph) if pooled else graph


@pytest.mark.parametrize('pooled',[False,True])
@pytest.mark.parametrize('mode',['overlap','overlap_shift_add','overlap_folded'])
def test_prefetch_window_with_overlapped_quantizers_and_counter_wrap(tmp_path,pooled,mode):
    graph=example(pooled=pooled)
    check_schedule(tmp_path,graph,2,
        {graph.output.name:{'chosen':ActorConfig(2,1,'prefetch',requantization=mode)}},frames=12)


@pytest.mark.parametrize('pooled,overflow,low,high',[(False,False,0,15),(True,False,-8,7),(False,True,3,13),
                                                  (False,False,7,7),(True,False,0,1)])
@pytest.mark.parametrize('requantization',['auto','overlap','overlap_shift_add'])
def test_threshold_rtl_preserves_stalls_tiles_and_wrapping_accumulators(tmp_path,pooled,overflow,low,high,requantization):
    graph=example(pooled,overflow,low,high)
    assert configuration(graph.output,2,3,2)['THRESHOLD_BITS']==max(1,(high-low).bit_length())
    source,expected=[],[]
    generator=torch.Generator().manual_seed(82)
    for _ in range(3):
        image=torch.randint(0,256,graph.input.tensor.shape,dtype=torch.uint8,generator=generator)
        result=evaluate(graph,image)
        for data,words in ((image,source),(result,expected)):
            words.extend(word for pixel in data.permute(0,2,3,1).reshape(-1,data.shape[1]) for word in pack(pixel,8,2))
    simulate(tmp_path,emit(graph.output,2,3,reduction_lanes=2,requantization=requantization),16,16,source,expected,True,max_cycles=50000)


@pytest.mark.parametrize('pooled',[False,True])
@pytest.mark.parametrize('requantization',['auto','multiply','overlap','overlap_shift_add'])
def test_threshold_schedule_matches_each_transfer_deadline(tmp_path,pooled,requantization):
    graph=example(pooled)
    check_schedule(tmp_path,graph,2,{graph.output.name:{'chosen':ActorConfig(3,2,requantization=requantization)}},frames=3)


@pytest.mark.parametrize('pooled',[False,True])
@pytest.mark.parametrize('outputs,reduction',[(1,1),(2,2),(5,2)])
def test_overlapped_quantizer_pipeline_depths_and_pixel_boundaries(tmp_path,pooled,outputs,reduction):
    graph=example(pooled)
    fast=check_schedule(tmp_path/'overlap',graph,2,
        {graph.output.name:{'chosen':ActorConfig(outputs,reduction,requantization='overlap')}},frames=4)
    serial=check_schedule(tmp_path/'serial',graph,2,
        {graph.output.name:{'chosen':ActorConfig(outputs,reduction,requantization='threshold')}},frames=4)
    assert fast.period<serial.period


@pytest.mark.parametrize('coefficients,offset',[([3,-7,0],32),
    ([-(1<<63),(1<<60)+3,-((1<<40)+5)],-(1<<62))])
@pytest.mark.parametrize('requantization,outputs',[('overlap_shift_add',1),('overlap_folded',3)])
def test_shift_add_quantizer_preserves_signed_coefficients_and_int64_wrap(tmp_path,coefficients,offset,requantization,outputs):
    kernel=200 if outputs>1 else 80
    source=Value('image','input',(),Tensor((1,1,1,kernel+10),8,True))
    weights=np.resize(np.array([1,-3,7,-2],dtype=np.int32),(3,1,1,kernel))
    actor=Value('conv','quantized_convolution',
        (source,weights,np.array([17,-23,(1<<31)-1],dtype=np.int32),(1,1),(0,0),(1,1),1,
         np.array(coefficients,dtype=np.int64),offset,7,-128,127),Tensor((1,3,1,11),8,True))
    graph=Graph(source,actor,(source,actor))
    inputs,expected=[],[]
    generator=torch.Generator().manual_seed(519)
    for _ in range(3):
        image=torch.randint(-128,128,source.tensor.shape,dtype=torch.int8,generator=generator)
        for data,words in ((image,inputs),(evaluate(graph,image),expected)):
            words.extend(int(value)&255 for value in data.permute(0,2,3,1).flatten())
    simulate(tmp_path,emit(actor,1,outputs,requantization=requantization),8,8,inputs,expected,True,max_cycles=30000)


@pytest.mark.parametrize('outputs',[2,3,5])
def test_folded_quantizer_preserves_channel_tiles_and_deadlines(tmp_path,outputs):
    graph=example(pooled=True)
    parameters=configuration(graph.output,2,outputs,2,'overlap_folded')
    assert parameters['QUANTIZER_LANES']<outputs
    check_schedule(tmp_path,graph,2,
        {graph.output.name:{'chosen':ActorConfig(outputs,2,requantization='overlap_folded')}},frames=4)


def test_folded_quantizer_preserves_stalls_and_signed_channel_coefficients(tmp_path):
    from dataclasses import replace
    graph=example(pooled=True)
    actor=graph.output
    # Negative coefficients prohibit pooling fusion, so use a longer ordinary
    # convolution to exercise several independently signed channel lanes.
    source=replace(graph.input,tensor=Tensor((1,3,4,30),8,True))
    rng=np.random.default_rng(831)
    actor=Value('signed','quantized_convolution',
        (source,rng.integers(-7,8,(5,3,1,20),dtype=np.int32),np.array([17,-23,3,100,5],dtype=np.int32),
         (1,1),(0,0),(1,1),1,np.array([3,-7,0,11,-1],dtype=np.int64),32,7,-128,127),
        Tensor((1,5,4,11),8,True))
    graph=Graph(source,actor,(source,actor))
    inputs,expected=[],[]
    generator=torch.Generator().manual_seed(519)
    for _ in range(3):
        image=torch.randint(-128,128,source.tensor.shape,dtype=torch.int8,generator=generator)
        for data,words in ((image,inputs),(evaluate(graph,image),expected)):
            words.extend(word for pixel in data.permute(0,2,3,1).reshape(-1,data.shape[1]) for word in pack(pixel,8,2))
    simulate(tmp_path,emit(actor,2,3,reduction_lanes=2,requantization='overlap_folded'),16,16,inputs,expected,True,max_cycles=50000)
