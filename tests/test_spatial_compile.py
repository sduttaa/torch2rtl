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
    assert report["solution"]["period"] == 9
    configuration = json.loads((tmp_path / "configuration.json").read_text())
    assert configuration["fifo_depths"] == {"image->lookup:0": 2}
    with gzip.open(tmp_path / "offsets.jsonl.gz", "rt") as stream:
        offsets = dict(json.loads(line) for line in stream)
    assert offsets["lookup.out.0"] >= offsets["image.out.0"] + 3
    assert "stream_fifo" in (tmp_path / "inference.sv").read_text()
    catalogue["preferred_options"]={"actor:lookup":"table","fifo:image->lookup:0":"small"}
    guided=compile_network(graph,catalogue,target,tmp_path,Limits(seconds=5))
    assert guided["incumbent_search"]["period"] == 12
    assert guided["solution"]["period"] == 9
    assert guided["solution"]["selected"]["fifo:image->lookup:0"] == "large"
    catalogue["initial_schedule"]=str(tmp_path)
    resumed=compile_network(graph,catalogue,target,tmp_path/"resumed",Limits(seconds=5))
    assert resumed["solution"]["period"] == 9
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
