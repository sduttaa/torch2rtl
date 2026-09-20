import gzip
import json

from torch2rtl.graph import Graph, Value
from torch2rtl.lower import Tensor
from torch2rtl.schedule import Limits
from torch2rtl.spatial_compile import compile_network


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
    assert configuration["fifo_depths"] == {"image->lookup:0": 1}
    with gzip.open(tmp_path / "offsets.jsonl.gz", "rt") as stream:
        offsets = dict(json.loads(line) for line in stream)
    assert offsets["lookup.out.0"] >= offsets["image.out.0"] + 2
    assert "stream_fifo" in (tmp_path / "inference.sv").read_text()
    target["resources"]["lut"] = 10
    failure = compile_network(graph, catalogue, target, tmp_path, Limits(seconds=5))
    assert failure["status"] == "INFEASIBLE" and failure["stage"] == "resource_preflight"
    assert not failure["solver_verified"]
    assert not any((tmp_path / name).exists() for name in ("inference.sv", "configuration.json", "offsets.jsonl.gz"))
