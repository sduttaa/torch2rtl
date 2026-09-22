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
    assert all({1,3,8} <= {row["depth"] for row in rows.values()} for rows in catalogue["fifo_options"].values())
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
    assert characterize("first",spec,tmp_path,cached_only=True) is None
    assert not calls
    assert not characterize("first",spec,tmp_path)["cache_hit"]
    assert characterize("first",spec,tmp_path,cached_only=True)["cache_hit"]
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
             "pair":{"depth":2,"resources":{"lut":5}},
             "small":{"depth":8,"resources":{"lut":5}},
             "larger":{"depth":16,"resources":{"lut":5}},
             "block":{"depth":128,"resources":{"lut":4,"bram":1}}}
    catalogue={"fifo_options":{"edge":options},"screen":{}}
    prune_fifos(catalogue)
    assert set(catalogue["fifo_options"]["edge"]) == {"register","pair","larger","block"}


def test_resource_proofs_prune_impossible_choices_without_restricting_slower_ones():
    from torch2rtl.optimize import prune_unsupported
    from torch2rtl.schedule import Limits
    catalogue={"actor_options":{
        "left":{"fast":{"period_bound":10,"resources":{"dsp":1}},
                "permitted":{"period_bound":19,"resources":{"dsp":1}},
                "too_slow":{"period_bound":21,"resources":{}},
                "too_wide":{"period_bound":5,"resources":{"dsp":2}}},
        "right":{"fixed":{"period_bound":10,"resources":{"dsp":1}}}},
        "fifo_options":{"edge":{"small":{"depth":1,"resources":{}},
                                "large":{"depth":4,"resources":{"lut":2}}}},
        "period_limit":20,"screen":{},"preferred_options":{"actor:left":"too_wide"}}
    assert prune_unsupported(catalogue,{"resources":{"dsp":2,"lut":2}},Limits(seconds=2))==2
    assert set(catalogue["actor_options"]["left"])=={"fast","permitted"}
    assert len(catalogue["fifo_options"]["edge"])==2
    assert not catalogue["preferred_options"]


def test_input_buffer_absorption_uses_source_geometry_and_preserves_the_seed():
    from torch2rtl.catalogue import absorb_input_buffers
    from torch2rtl.fusion import geometry
    from torch2rtl.network import edges
    graph=fuse(network(shape=(16,10)),2)
    search={"lanes":2,"output_lanes":[2],"reduction_lanes":[2],
            "line_layouts":["packed"],"weight_memories":["block"],
            "extra_rows":[0,1],"fifo_max_words":256,"fifo_small_depths":[1,8],
            "fifo_memories":["block","distributed"],"max_actor_options":4,
            "period_limit":100000,"offset_limit":200000}
    catalogue=prepare(graph,Path("user.pt2"),"hash",target(),search)
    edge=next(name for name,_,destination,port in edges(graph) if destination is graph.output and port==1)
    seed={"model_sha256":"hash","fifo_depths":{name:8 for name,*_ in edges(graph)}}
    seed["fifo_depths"][edge]=160
    hint=absorb_input_buffers(graph,catalogue,seed,target())
    assert seed["fifo_depths"][edge]==160 and "memories" not in seed
    assert hint["fifo_depths"][edge]<=8
    assert hint["memories"][graph.output.name]["extra_rows"]==[0,5]
    for spec in catalogue["actor_options"][graph.output.name].values():
        assert geometry(graph.output,2,spec["memories"]["extra_rows"])[1]["depth"]==160
    assert all(spec["depth"]<=8 for spec in catalogue["fifo_options"][edge].values())
    fresh=prepare(graph,Path("user.pt2"),"hash",target(),search)
    repeated=absorb_input_buffers(graph,fresh,hint,target())
    assert repeated["memories"][graph.output.name]["extra_rows"]==[0,5]
    with pytest.raises(ValueError,match="different model"):
        absorb_input_buffers(graph,catalogue,{**seed,"model_sha256":"other"},target())
    # Fill otherwise unused physical capacity, preferring a depth that permits
    # rolling across frames. This comes from memory modes and source geometry.
    seed["fifo_depths"][edge]=140
    packed_catalogue=prepare(graph,Path("user.pt2"),"hash",target(),search)
    packed=absorb_input_buffers(graph,packed_catalogue,seed,target(),pack_rows=True)
    packed_geometry=geometry(graph.output,2,packed["memories"][graph.output.name]["extra_rows"])[1]
    assert packed_geometry["rolling"]
    assert packed_geometry["depth"]>=seed["fifo_depths"][edge]


def test_retention_preserves_the_seed_and_exact_quantizer_alternatives():
    from types import SimpleNamespace
    from torch2rtl.catalogue import retain
    options={name:{"output_lanes":2,"reduction_lanes":2,"period_bound":100,
                   "requantization":name,"memories":{"weight":"block"},
                   "resources":{"bram":2,"lut":lut}}
             for name,lut in (("multiply",10),("threshold",8),("auto",9))}
    catalogue={"actor_options":{"operator":options},"screen":{}}
    retain(catalogue,SimpleNamespace(period=100,selected={"actor:operator":"multiply"}),2)
    assert "multiply" in catalogue["actor_options"]["operator"]
    assert len(catalogue["actor_options"]["operator"])==2


def test_automatic_buffer_plan_uses_a_fresh_finite_occupancy_schedule(tmp_path):
    from torch2rtl.optimize import automatic_buffer_plan
    from torch2rtl.schedule import Limits
    graph=fuse(network(shape=(4,6)),2)
    search={"lanes":2,"output_lanes":[2],"reduction_lanes":[2],
            "line_layouts":["packed"],"weight_memories":["block"],"extra_rows":[0],
            "storage_memories":["block"],"fifo_max_words":128,"fifo_linear_max_words":8,
            "fifo_small_depths":[1,8],"fifo_memories":["block"],"max_actor_options":4,
            "period_limit":20000,"offset_limit":50000}
    catalogue=prepare(graph,Path("user.pt2"),"hash",target(),search)
    hint,report=automatic_buffer_plan(graph,catalogue,target(),search,tmp_path,Limits(seconds=10),lambda _:None)
    assert report["solver_verified"] and report["physical_candidate"] is False
    assert hint["model_sha256"]=="hash"
    assert all(depth>=1 for depth in hint["fifo_depths"].values())
    assert "initial_schedule" not in report
    import json
    planned=json.loads((tmp_path/"catalogue.json").read_text())
    assert all(spec["resources"]=={} for options in planned["fifo_options"].values() for spec in options.values())
    # The original catalogue keeps its physical costs; the relaxation is local.
    assert any(spec["resources"] for options in catalogue["fifo_options"].values() for spec in options.values())


def test_refinement_keeps_the_measured_incumbent_while_exploring_new_geometry():
    from types import SimpleNamespace
    from torch2rtl.catalogue import retain
    options={name:{"output_lanes":lanes,"reduction_lanes":1,"period_bound":period,
                   "resources":{"lut":cost},"memories":{"weight":"logic"}}
             for name,lanes,period,cost in (("measured",2,105,20),("optimistic",4,100,0),("other",1,200,1))}
    catalogue={"actor_options":{"operator":options},"screen":{}}
    retain(catalogue,SimpleNamespace(period=100,selected={"actor:operator":"optimistic"}),2,
           incumbent=SimpleNamespace(selected={"actor:operator":"measured"}))
    assert set(catalogue["actor_options"]["operator"])=={"measured","optimistic"}


def test_retention_keeps_burst_capacity_missing_from_actor_period_bounds():
    from types import SimpleNamespace
    from torch2rtl.catalogue import retain
    base={"output_lanes":2,"reduction_lanes":1,"period_bound":100,"memories":{"weight":"block"}}
    options={"plain":{**base,"resources":{"lut":1}},
             "arithmetic":{**base,"resources":{"lut":2},"requantization":"threshold"},
             "buffered":{**base,"resources":{"lut":3},"prefetch_words":16,
                         "memories":{"weight":"block","line_layout":"prefetch"}}}
    catalogue={"actor_options":{"operator":options},"screen":{}}
    retain(catalogue,SimpleNamespace(period=100,selected={"actor:operator":"plain"}),2)
    assert set(catalogue["actor_options"]["operator"])=={"plain","buffered"}


def test_ring_window_costs_one_span_without_duplicate_horizontal_storage():
    from test_threshold_quantization import example
    from torch2rtl.memory import actor_memories
    graph=example(pooled=True)
    memories=actor_memories(graph.output,2,{"output_lanes":3,"reduction_lanes":2,
                                           "memories":{"line_layout":"ring"}})
    windows=[memory for memory in memories if memory.name=="window_ring"]
    # Four effective rows/columns, padded input width eight, two channel words.
    assert len(windows)==1 and windows[0].depth==64
    assert all(memory.name not in ("lines","horizontal") for memory in memories)


def test_compact_ring_survives_equal_optimistic_memory_costs():
    from test_threshold_quantization import example
    graph=example()
    board=target()
    board["memory_modes"][0]["depth"]=16
    board["memory_modes"][1]["depth"]=32
    spec={"output_lanes":3,"reduction_lanes":2,"memories":{"line_layout":"ring_compact"}}
    compact=profile(graph.output,2,spec,board)
    padded=profile(graph.output,2,{**spec,"memories":{"line_layout":"ring"}},board)
    assert compact["resources"]["bram"]<padded["resources"]["bram"]
    # A target mapper can select a different aspect ratio than the geometry
    # lower bound. Exact synthesis must see both implementations in that case.
    compact=profile(graph.output,2,spec,target())
    padded=profile(graph.output,2,{**spec,"memories":{"line_layout":"ring"}},target())
    assert compact["resources"]==padded["resources"]


def test_width_bank_candidates_come_from_target_memory_modes():
    from test_threshold_quantization import example
    graph=example(pooled=True)
    board=target()
    search={"lanes":4,"output_lanes":[2],"reduction_lanes":[1],
            "line_layouts":["ring"],"weight_memories":["logic"],"banked_lines":True,
            "fifo_max_words":8,"fifo_small_depths":[1,3,8],"fifo_memories":["distributed"],
            "max_actor_options":4,"period_limit":20000,"offset_limit":50000}
    catalogue=prepare(graph,Path("supplied.pt2"),"hash",board,search)
    options=catalogue["actor_options"][graph.output.name]
    banked=[spec for spec in options.values() if "line_bank_width" in spec["memories"]]
    assert banked
    for spec in banked:
        bank_width=spec["memories"]["line_bank_width"]
        assert bank_width in {mode["width"] for mode in board["memory_modes"]}
        arrays=[row for row in spec["memory_report"] if row["name"].startswith("window_ring_")]
        assert sum(row["width"] for row in arrays)==24
        assert all(row["width"]<=bank_width for row in arrays)
        rtl=actor_rtl(graph.output,4,spec["output_lanes"],spec["memories"],spec["reduction_lanes"])
        assert f".BANK_WIDTH({bank_width})" in rtl
