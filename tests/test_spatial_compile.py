import gzip
import json
import pytest

from torch2rtl.graph import Graph, Value
from torch2rtl.lower import Tensor
from torch2rtl.schedule import Limits
from torch2rtl.spatial_compile import compile_network
from torch2rtl.network import emit


def test_catalogue_compiles_and_resource_failure_removes_stale_outputs(tmp_path):
    source = Value("image", "input", (), Tensor((1, 1, 2, 3), 8, False))
    output = Value("lookup", "byte_lookup", (source, tuple(255-i for i in range(256))), source.tensor)
    graph = Graph(source, output, (source, output))
    catalogue = {"model": "explicit-input.pt2", "model_sha256": "test-metadata", "lanes": 1,
        "period_limit": 100, "offset_limit": 200,
        "actor_options": {"lookup": {"table": {"resources": {"lut": 10}}}},
        "fifo_options": {"image->lookup:0": {
            "small": {"depth": 1, "resources": {"lut": 1}},
            "large": {"depth": 2, "resources": {"lut": 2}}}}}
    target = {"resources": {"lut": 12}, "resource_weights": {"lut": 1}}
    report = compile_network(graph, catalogue, target, tmp_path, Limits(seconds=5))
    assert report["solver_verified"] and not report["hardware_fit_verified"] and not report["timing_verified"]
    assert report["solution"]["period"] == 6
    configuration = json.loads((tmp_path / "configuration.json").read_text())
    assert configuration["fifo_depths"] == {"image->lookup:0": 2}
    with gzip.open(tmp_path / "offsets.jsonl.gz", "rt") as stream:
        offsets = dict(json.loads(line) for line in stream)
    assert offsets["lookup.out.0"] >= offsets["image.out.0"] + 2
    assert "stream_fifo" in (tmp_path / "inference.sv").read_text()
    catalogue["preferred_options"]={"actor:lookup":"table","fifo:image->lookup:0":"small"}
    guided=compile_network(graph,catalogue,target,tmp_path,Limits(seconds=5))
    # Bootstrap establishes feasibility at the ceiling; the complete search
    # then repairs the undersized hint and minimizes the frame period.
    assert guided["incumbent_search"]["period"] == catalogue["period_limit"]
    assert guided["solution"]["period"] == 6
    assert guided["solution"]["selected"]["fifo:image->lookup:0"] == "large"
    catalogue["initial_schedule"]=str(tmp_path)
    resumed=compile_network(graph,catalogue,target,tmp_path/"resumed",Limits(seconds=5))
    assert resumed["solution"]["period"] == 6
    assert "incumbent_search" not in resumed
    catalogue["actor_options"]["lookup"]["table"]["resources"]["lut"]=9
    refreshed=compile_network(graph,catalogue,target,tmp_path/"refreshed",Limits(seconds=5),validate_only=True)
    assert refreshed["solution"]["resources"] == {"lut":11}
    assert refreshed["search_skipped"] and refreshed["solution"]["seconds"] == 0
    assert refreshed["solution"]["status"] == "FEASIBLE" and not refreshed["solution"]["resource_optimal"]
    catalogue["actor_options"]["lookup"]["table"]["resources"]["lut"]=10
    saved=json.loads((tmp_path/"report.json").read_text())
    saved["solution"]["period"]=1
    (tmp_path/"report.json").write_text(json.dumps(saved))
    with pytest.raises(ValueError,match="violated dependency"):
        compile_network(graph,catalogue,target,tmp_path/"invalid",Limits(seconds=5))
    catalogue.pop("initial_schedule")
    with pytest.raises(ValueError,match="Validation requires"):
        compile_network(graph,catalogue,target,tmp_path/"missing-seed",validate_only=True)
    target["resources"]["lut"] = 10
    failure = compile_network(graph, catalogue, target, tmp_path, Limits(seconds=5))
    assert failure["status"] == "INFEASIBLE" and failure["stage"] == "resource_preflight"
    assert not failure["solver_verified"]
    assert not any((tmp_path / name).exists() for name in ("inference.sv", "configuration.json", "offsets.jsonl.gz"))


def test_fifo_placement_selected_from_resource_budget(tmp_path):
    source = Value("image", "input", (), Tensor((1, 1, 2, 3), 8, False))
    output = Value("lookup", "byte_lookup", (source, tuple(range(256))), source.tensor)
    graph = Graph(source, output, (source, output))
    edge = "image->lookup:0"
    catalogue = {"model": "explicit-input.pt2", "model_sha256": "test-metadata", "lanes": 1,
        "period_limit": 100, "offset_limit": 200,
        "actor_options": {"lookup": {"table": {"resources": {}}}},
        "fifo_options": {edge: {
            "block": {"depth": 17, "memory": "block", "resources": {"bram": 1}},
            "distributed": {"depth": 17, "memory": "distributed", "resources": {"lutram_bits": 256}}}}}
    target = {"resources": {"bram": 0, "lutram_bits": 256}}
    report = compile_network(graph, catalogue, target, tmp_path, Limits(seconds=5))
    assert report["solver_verified"]
    config = json.loads((tmp_path / "configuration.json").read_text())
    assert config["fifo_memories"] == {edge: "distributed"}
    assert '.DEPTH(17), .MEMORY_STYLE("distributed")' in (tmp_path / "inference.sv").read_text()
    default = emit(graph, 1, {}, {edge: 17})
    assert default == emit(graph, 1, {}, {edge: 17}, fifo_memories={edge: "auto"})
    for invalid in ({edge: "unknown"}, {"missing": "block"}):
        with pytest.raises(ValueError, match="FIFO memory mappings"):
            emit(graph, 1, {}, {edge: 17}, fifo_memories=invalid)


def test_seed_lifts_private_events_of_alternative_pipelines(tmp_path):
    from test_threshold_quantization import example
    graph=example()
    name=graph.output.name
    edge=graph.input.name+"->"+name+":0"
    catalogue={"model":"input.pt2","model_sha256":"metadata","lanes":2,
        "period_limit":10000,"offset_limit":20000,
        "actor_options":{name:{mode:{"output_lanes":3,"reduction_lanes":2,
            "requantization":mode,"resources":{}} for mode in ("threshold","overlap")}},
        "fifo_options":{edge:{"queue":{"depth":8,"resources":{}}}},
        "preferred_options":{"actor:"+name:"threshold","fifo:"+edge:"queue"}}
    serial={**catalogue,"actor_options":{name:{"threshold":catalogue["actor_options"][name]["threshold"]}}}
    serial_report=compile_network(graph,serial,{"resources":{}},tmp_path/"serial",Limits(seconds=5))
    catalogue["initial_schedule"]=str(tmp_path/"serial")
    report=compile_network(graph,catalogue,{"resources":{}},tmp_path/"complete",Limits(seconds=5))
    assert report["solver_verified"]
    assert "initial_schedule" in report
    assert report["solution"]["selected"]["actor:"+name]=="overlap"
    assert report["solution"]["period"]<serial_report["solution"]["period"]


def test_prefetch_capacity_can_replace_an_unaffordable_external_queue(tmp_path):
    from test_threshold_quantization import example
    graph=example();actor=graph.output.name;edge=graph.input.name+"->"+actor+":0"
    catalogue={"model":"input.pt2","model_sha256":"metadata","lanes":2,
        "period_limit":10000,"offset_limit":20000,"stop_after_feasible":True,
        "actor_options":{actor:{
            "direct":{"output_lanes":2,"reduction_lanes":1,"resources":{"lut":1}},
            "prefetch":{"output_lanes":2,"reduction_lanes":1,"resources":{"lut":3},
                        "memories":{"line_layout":"prefetch"},"prefetch_words":26}}},
        "fifo_options":{edge:{"small":{"depth":1,"resources":{"lut":1}},
                              "large":{"depth":8,"resources":{"lut":8}}}},
        "preferred_options":{"actor:"+actor:"direct","fifo:"+edge:"large"},
        "preferred_buffer_capacities":{edge:8}}
    report=compile_network(graph,catalogue,{"resources":{"lut":4}},tmp_path,Limits(seconds=5))
    assert report["solver_verified"]
    assert report["solution"]["selected"]=={"actor:"+actor:"prefetch","fifo:"+edge:"small"}
    assert report["solution"]["resources"]=={"lut":4}
    assert report["buffer_capacity_proposal"]["status"]=="OPTIMAL"
    catalogue["preferred_buffer_capacities"][edge]=28
    catalogue["fifo_options"][edge]["pipeline"]={"depth":2,"resources":{"lut":2}}
    complete=compile_network(graph,catalogue,{"resources":{"lut":5}},tmp_path/"complete",Limits(seconds=5))
    assert complete["solver_verified"]
    assert complete["buffer_capacity_proposal"]["hints"][edge]==28
    assert complete["solution"]["selected"]["fifo:"+edge]=="pipeline"


def test_buffer_hint_preserves_capacity_already_inside_the_planning_actor():
    from dataclasses import replace
    from test_threshold_quantization import example
    from torch2rtl.optimize import buffering_hints
    graph=example();actor=graph.output.name;edge=graph.input.name+"->"+actor+":0"
    catalogue={"model_sha256":"hash","actor_options":{actor:{
        "direct":{"memories":{"line_layout":"ring"},"resources":{}},
        "prefetch":{"memories":{"line_layout":"prefetch"},"prefetch_words":26,"resources":{}}}}}
    configuration={"model_sha256":"hash","memories":{actor:{"line_layout":"prefetch"}},
                   "fifo_depths":{edge:2}}
    catalogue["fifo_options"]={edge:{"small":{"depth":2}}}
    # The boundary is paced by the exported schedule, so it needs no actor
    # burst allowance. An internal producer's burst must retain that space.
    assert buffering_hints(graph,catalogue,configuration)=={edge:0}
    upstream=Value("producer","byte_lookup",(graph.input,tuple(range(256))),graph.input.tensor)
    output=replace(graph.output,args=(upstream,*graph.output.args[1:]))
    graph=Graph(graph.input,output,(graph.input,upstream,output))
    inner="producer->"+actor+":0";outer=graph.input.name+"->producer:0"
    catalogue["actor_options"]["producer"]={"stream":{"resources":{}}}
    catalogue["fifo_options"]={name:{"small":{"depth":2}} for name in (inner,outer)}
    configuration["fifo_depths"]={inner:2,outer:1}
    assert buffering_hints(graph,catalogue,configuration)=={inner:28,outer:0}


def test_buffer_proposal_can_reallocate_compute_and_memory_placement(tmp_path):
    from test_threshold_quantization import example
    graph=example();actor=graph.output.name;edge=graph.input.name+"->"+actor+":0"
    catalogue={"model":"input.pt2","model_sha256":"metadata","lanes":2,
        "period_limit":10000,"offset_limit":20000,"stop_after_feasible":True,
        "actor_options":{actor:{
            "planned":{"output_lanes":1,"reduction_lanes":1,"period_bound":100,
                       "memories":{"weight":"block"},"resources":{"bram":1}},
            "same_timing":{"output_lanes":1,"reduction_lanes":1,"period_bound":100,
                           "memories":{"weight":"logic"},"resources":{"lut":10}},
            "faster":{"output_lanes":2,"reduction_lanes":1,"period_bound":50,
                      "memories":{"weight":"logic"},"resources":{"lut":10}}}},
        "fifo_options":{edge:{"queue":{"depth":8,"resources":{}}}},
        "preferred_options":{"actor:"+actor:"planned","fifo:"+edge:"queue"}}
    report=compile_network(graph,catalogue,{"resources":{"bram":0,"lut":10}},tmp_path,Limits(seconds=5))
    assert report["solver_verified"]
    assert report["resource_preflight"]["selected"]["actor:"+actor]=="faster"
    # Buffer-planning geometry is only a hint. Resources may require returning
    # to the slower contract; either choice gets a complete scheduling check.
    catalogue["actor_options"][actor]["faster"]["resources"]["lut"]=11
    changed=compile_network(graph,catalogue,{"resources":{"bram":0,"lut":10}},tmp_path/"changed",Limits(seconds=5))
    assert changed["solver_verified"]
    assert changed["resource_preflight"]["selected"]["actor:"+actor]=="same_timing"


def test_blocking_cycle_automatically_repairs_branch_storage(tmp_path):
    from test_view_fusion import network
    from torch2rtl.graph import reachable
    from torch2rtl.network import edges
    original=network(shape=(4,4),channels=1)
    joined=original.output.args[0]
    graph=Graph(original.input,joined,reachable(joined))
    bypass=next(name for name,source,destination,_ in edges(graph)
                if source is graph.input and destination is joined)
    queues={name:{"large":{"depth":32,"resources":{"slots":32}}} for name,*_ in edges(graph)}
    queues[bypass]["small"]={"depth":2,"resources":{"slots":2}}
    queues[bypass]["same_depth"]={"depth":2,"memory":"distributed","resources":{"slots":3}}
    catalogue={"model":"input.pt2","model_sha256":"metadata","lanes":1,
        "period_limit":1000,"offset_limit":10000,"stop_after_feasible":True,
        "actor_options":{value.name:{"stream":{"resources":{}}} for value in graph.values if value is not graph.input},
        "fifo_options":queues,"preferred_options":{"fifo:"+bypass:"small"}}
    report=compile_network(graph,catalogue,{"resources":{"slots":32*len(queues)}},tmp_path,Limits(seconds=5))
    assert report["solver_verified"]
    assert len(report["proposal_attempts"])==2
    assert report["proposal_attempts"][0]["status"]=="INFEASIBLE"
    assert report["proposal_attempts"][0]["blocking_cycle"]["delay"]>0
    assert report["solution"]["selected"]["fifo:"+bypass]=="large"
    assert ("fifo:"+bypass,("small","same_depth")) in report["proved_exclusions"][0]


def test_proposal_balances_the_slowest_actor_instead_of_speeding_a_fast_one(tmp_path):
    source=Value("image","input",(),Tensor((1,1,2,3),8,False))
    first=Value("first","byte_lookup",(source,tuple(range(256))),source.tensor)
    second=Value("second","byte_lookup",(first,tuple(range(256))),source.tensor)
    graph=Graph(source,second,(source,first,second))
    catalogue={"model":"input.pt2","model_sha256":"metadata","lanes":1,
        "period_limit":1000,"offset_limit":2000,"stop_after_feasible":True,
        "actor_options":{
            "first":{"small":{"period_bound":100,"resources":{}},
                     "large":{"period_bound":70,"resources":{"lanes":1}}},
            "second":{"small":{"period_bound":60,"resources":{}},
                      "large":{"period_bound":10,"resources":{"lanes":1}}}},
        "fifo_options":{edge:{"queue":{"depth":2,"resources":{}}}
                        for edge in ("image->first:0","first->second:0")},
        "preferred_options":{"actor:first":"small","actor:second":"small"}}
    result=compile_network(graph,catalogue,{"resources":{"lanes":1}},tmp_path,Limits(seconds=5))
    assert result["solver_verified"]
    chosen=result["resource_preflight"]["selected"]
    assert chosen["actor:first"]=="large" and chosen["actor:second"]=="small"
    assert "proposal:actor_period" not in chosen
    # An eager planning queue is a hint, not a required capacity. It must not
    # consume the resource needed to improve the actual bottleneck.
    edge="image->first:0"
    catalogue["fifo_options"][edge]["eager"]={"depth":8,"resources":{"lanes":1}}
    catalogue["preferred_options"]["fifo:"+edge]="eager"
    revised=compile_network(graph,catalogue,{"resources":{"lanes":1}},tmp_path/"eager",Limits(seconds=5))
    chosen=revised["resource_preflight"]["selected"]
    assert chosen["actor:first"]=="large" and chosen["fifo:"+edge]=="queue"
