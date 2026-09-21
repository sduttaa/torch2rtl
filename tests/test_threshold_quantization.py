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


@pytest.mark.parametrize('pooled,overflow,low,high',[(False,False,0,15),(True,False,-8,7),(False,True,3,13),
                                                  (False,False,7,7),(True,False,0,1)])
def test_threshold_rtl_preserves_stalls_tiles_and_wrapping_accumulators(tmp_path,pooled,overflow,low,high):
    graph=example(pooled,overflow,low,high)
    assert configuration(graph.output,2,3,2)['THRESHOLD_BITS']==max(1,(high-low).bit_length())
    source,expected=[],[]
    generator=torch.Generator().manual_seed(82)
    for _ in range(3):
        image=torch.randint(0,256,graph.input.tensor.shape,dtype=torch.uint8,generator=generator)
        result=evaluate(graph,image)
        for data,words in ((image,source),(result,expected)):
            words.extend(word for pixel in data.permute(0,2,3,1).reshape(-1,data.shape[1]) for word in pack(pixel,8,2))
    simulate(tmp_path,emit(graph.output,2,3,reduction_lanes=2),16,16,source,expected,True,max_cycles=50000)


@pytest.mark.parametrize('pooled',[False,True])
@pytest.mark.parametrize('requantization',['auto','multiply'])
def test_threshold_schedule_matches_each_transfer_deadline(tmp_path,pooled,requantization):
    graph=example(pooled)
    check_schedule(tmp_path,graph,2,{graph.output.name:{'chosen':ActorConfig(3,2,requantization=requantization)}},frames=3)
