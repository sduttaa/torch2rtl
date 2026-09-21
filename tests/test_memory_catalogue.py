from dataclasses import replace
from pathlib import Path

import pytest

from test_view_fusion import network
from torch2rtl.catalogue import prepare, profile
from torch2rtl.flow import characterize
from torch2rtl.fusion import fuse
from torch2rtl.memory import Memory, allocation, depth_candidates, mappings
from torch2rtl.network import actor_rtl


def target():
    return {"resources":{"bram":20,"lut":10000,"ff":10000,"dsp":32,"lutram_bits":20000},
        "memory_modes":[
            {"name":"wide","kind":"block","width":16,"depth":64,"read_ports":1,"write_ports":1,"resources":{"bram":1}},
            {"name":"deep","kind":"block","width":8,"depth":128,"read_ports":1,"write_ports":1,"resources":{"bram":1}},
            {"name":"small","kind":"distributed","width":1,"depth":16,"read_ports":1,"write_ports":1,"resources":{"lut":1,"lutram_bits":16}},
            {"name":"rom","kind":"logic","width":1,"depth":16,"read_ports":1,"write_ports":0,"resources":{"lut":1}}],
        "multiplier_modes":[{"input_bits":9,"signed":True,"resources":{"dsp":1}}]}


def test_memory_geometry_selects_width_depth_and_checks_ports():
    result=allocation([Memory("narrow",8,128),Memory("wide",16,64)],target())
    assert result["resources"] == {"bram":2}
    assert [row["mode"] for row in result["memories"]] == ["deep","wide"]
    assert all(row["packing_efficiency"] == 1 for row in result["memories"])
    with pytest.raises(ValueError,match="No supplied physical memory mode"):
        mappings(Memory("two_readers",8,32,read_ports=2),target())
    assert depth_candidates(8,300,target()) == [1,2,3,8,64,128,192,256,300]


def test_generic_catalogue_contains_real_actor_and_fifo_alternatives():
    graph=fuse(network(shape=(4,6)),2)
    search={"lanes":2,"output_lanes":[1,2,4],"reduction_lanes":[1,2],
        "line_layouts":["packed","parallel"],"weight_memories":["block","logic"],
        "row_buffers":[1,2],"extra_rows":[0,1],"hybrid_weights":True,
        "fifo_max_words":128,"fifo_small_depths":[1,3,8],"fifo_memories":["block","distributed"],
        "max_actor_options":4,"period_limit":10000,"offset_limit":20000}
    catalogue=prepare(graph,Path("user.pt2"),"hash",target(),search)
    options=catalogue["actor_options"][graph.output.name]
    assert len(options)>1
    assert len({row["period_bound"] for row in options.values()})>1
    assert all(row["resources"]["dsp"]>0 for row in options.values())
    selected=next(iter(options.values()))
    rtl=actor_rtl(graph.output,2,selected["output_lanes"],selected["memories"],selected["reduction_lanes"])
    assert "view_rows" in rtl
    assert any(row["memory"] == "distributed" for rows in catalogue["fifo_options"].values() for row in rows.values())
    value=graph.output
    spec={"output_lanes":2,"reduction_lanes":2,"memories":{"weight":"block"}}
    renamed=replace(value,name="unrelated_name")
    assert profile(value,2,spec,target()) == profile(renamed,2,spec,target())


def test_characterization_cache_invalidates_changed_mapping_and_rtl(tmp_path,monkeypatch):
    calls=[]
    monkeypatch.setattr("torch2rtl.flow.tool_identity",lambda:"test-tool")
    def synthesize(rtl,directory,target):
        calls.append((rtl,target))
        directory.mkdir(parents=True,exist_ok=True)
        return {"lut":7}
    monkeypatch.setattr("torch2rtl.flow.synthesize",synthesize)
    spec={"synthesis":{"command":"synth_ice40"},"cell_costs":{"LUT4":{"lut":1}}}
    assert not characterize("first",spec,tmp_path)["cache_hit"]
    assert characterize("first",spec,tmp_path)["cache_hit"]
    assert not characterize("second",spec,tmp_path)["cache_hit"]
    changed={**spec,"synthesis":{"command":"synth_ice40","flags":["-abc2"]}}
    assert not characterize("first",changed,tmp_path)["cache_hit"]
    assert len(calls) == 3


def test_retention_crosses_lower_lane_compute_with_both_weight_memories():
    from types import SimpleNamespace
    from torch2rtl.catalogue import retain
    options={}
    for output,reduction,period in ((8,1,100),(2,4,115),(1,4,190)):
        for style in ("logic","block"):
            options[f"{output}_{style}"]={"output_lanes":output,"reduction_lanes":reduction,
                "period_bound":period,"memories":{"weight":style,"line_layout":"packed"},
                "resources":{"dsp":output*reduction,"bram":2 if style == "block" else 0}}
    catalogue={"actor_options":{"operator":options},"screen":{}}
    solution=SimpleNamespace(period=100,selected={"actor:operator":"8_logic"})
    retain(catalogue,solution,4)
    assert set(catalogue["actor_options"]["operator"]) == {"8_logic","8_block","2_logic","2_block"}


def test_fifo_pruning_preserves_latency_and_resource_tradeoffs():
    from torch2rtl.optimize import prune_fifos
    options={"register":{"depth":1,"resources":{"lut":1}},
             "small":{"depth":8,"resources":{"lut":5}},
             "larger":{"depth":16,"resources":{"lut":5}},
             "block":{"depth":128,"resources":{"lut":4,"bram":1}}}
    catalogue={"fifo_options":{"edge":options},"screen":{}}
    prune_fifos(catalogue)
    assert set(catalogue["fifo_options"]["edge"]) == {"register","larger","block"}
