from math import ceil

import pytest
import torch

from torch2rtl.compiler import schedule_problem
from torch2rtl.cp_sat import solve
from torch2rtl.frontend import load
from torch2rtl.lower import lower
from torch2rtl.rtl import emit
from rtl_check import pack, simulate


class Sum(torch.nn.Module):
    def forward(self, x):
        return (x.to(torch.int32) * 3 - 10).clamp(-100, 100).sum(dtype=torch.int32)


@pytest.mark.parametrize("lanes,depth", [(1, 1), (2, 2), (4, 3)])
def test_solved_schedule_matches_rtl(tmp_path, lanes, depth):
    torch.manual_seed(5)
    frames = [torch.randint(-128, 128, (1, 13), dtype=torch.int8) for _ in range(12)]
    model = Sum()
    path = tmp_path / "program.pt2"
    torch.export.save(torch.export.export(model, (frames[0],)), path)
    _, module = load(path)
    kernel = lower(module)
    # Resource measurements belong to the flow test. Here only timing is tested.
    problem = schedule_problem(kernel, {"candidate": {"lanes": lanes, "depth": depth, "resources": {}}},
                               {"resources": {}})
    result = solve(problem)
    assert result.status == "OPTIMAL"
    assert result.period == ceil(frames[0].numel() / lanes) + 1
    cycles = simulate(tmp_path, emit(kernel, lanes, depth), 8 * lanes, 32,
                      [w for f in frames for w in pack(f.flatten(), 8, lanes)],
                      [int(model(f)) & 0xffffffff for f in frames], False)
    assert all(b - a == result.period for a, b in zip(cycles, cycles[1:]))
