import torch

from torch2rtl.analysis import analyze
from torch2rtl.cp_sat import solve
from torch2rtl.storage import constant_storage, integer_encodings, storage_problem


def test_lossless_candidates_count_their_codebooks():
    dense = integer_encodings(list(range(-128, 128)), 8)
    assert dense["raw"] == 256
    assert dense["palette"] > dense["raw"]
    assert dense["canonical_huffman"] > dense["raw"]
    assert integer_encodings([0] * 1024, 8)["range_packed"] == 2
    sparse = integer_encodings([0] * 1023 + [127], 8)
    assert sparse["zero_bitmap"] == 129


def test_shared_views_do_not_multiply_replay_storage():
    class ViewNormalization(torch.nn.Module):
        def forward(self, x):
            enlarged = torch.nn.functional.interpolate(x, scale_factor=2, mode="nearest")
            repeated = torch.cat((enlarged, enlarged), dim=1)
            return repeated / repeated.amax().clamp(min=1e-8)

    example = torch.rand(1, 2, 3, 5)
    program = torch.export.export(ViewNormalization(), (example,))
    report = analyze(program)
    reduction = report["reductions"][0]
    assert reduction["direct_replay_bytes"] == example.numel() * 4 * 4 * 2
    assert reduction["view_regenerated_replay_bytes"] == example.numel() * 4
    assert len(reduction["view_replay_sources"]) == 1


def test_storage_accounts_float_constants_and_optimistic_target():
    target = {"fabric_memory_bits": {"ram": 64}, "logic_lut_inputs": 4,
              "resources": {"lut": 2, "ff": 8}}
    report = constant_storage({"a": torch.zeros(1024, dtype=torch.int8),
                               "b": torch.ones(2, dtype=torch.float32)}, target)
    assert report["raw_bytes"] == 1032
    assert report["smallest_catalogue_bytes"] == 10
    assert not report["catalogue_fits_fabric_ram"]
    assert report["optimistic_all_storage_bytes"] == 13
    assert report["catalogue_fits_optimistic_all_storage"]


def test_storage_relaxation_distinguishes_catalogue_fit():
    report = constant_storage({"weight": torch.arange(-128, 128, dtype=torch.int8)})
    assert solve(storage_problem(report, 255)).status == "INFEASIBLE"
    solution = solve(storage_problem(report, 256))
    assert solution.status == "OPTIMAL"
    assert solution.resources["payload_bytes"] == 256
    assert solution.selected["weight"] == "raw"
