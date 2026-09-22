from itertools import product
from dataclasses import replace

import pytest

from torch2rtl import cp_sat
from torch2rtl.precedence import domains
from torch2rtl.schedule import Dependency, Fifo, Limits, Option, Problem, validate, validate_solution


def test_path_domains_include_upper_bounds_and_anchor():
    model = Problem(("epoch", "a", "b", "c"), {},
                    (Dependency("a", "b", 3), Dependency("b", "c", 4)), (), {}, 20, 12, "epoch")
    lower, distance = domains(model)
    assert list(lower) == [0, 0, 3, 7]
    assert [model.offset_limit-value for value in distance] == [0, 5, 8, 12]


def choice_problem():
    return Problem(("a", "b", "c"), {"mode": (Option("fast"), Option("slow"))},
        (Dependency("a", "b", 1, when=(("mode", "fast"),)),
         Dependency("a", "b", 2, when=(("mode", "slow"),)), Dependency("c", "a", 0, 1)),
        (Fifo(("b",), ("c",), "mode", {"fast": 1, "slow": 2}, forward_delays={"fast": 1, "slow": 2}),),
        {}, 6, 6, "a")


def test_all_small_feasible_assignments_survive_domains():
    model = choice_problem()
    validate(model)
    lower, distance = domains(model)
    seen = set()
    for choice, period, before, after in product(("fast", "slow"), range(1, 7), range(7), range(7)):
        delay = 1 if choice == "fast" else 2
        depth = delay
        if before >= delay and after >= before+delay and before >= after-depth*period and period >= after:
            seen.add(choice)
            for index, value in enumerate((0, before, after)):
                assert lower[index] <= value <= model.offset_limit-distance[index]
    assert seen == {"fast", "slow"}


def test_fixed_fifo_slot_reuse_is_an_unconditional_path():
    model = Problem(("epoch", "w0", "w1", "r0", "r1"), {"fifo": (Option("one"),)}, (),
        (Fifo(("w0", "w1"), ("r0", "r1"), "fifo", {"one": 1}, replacement_delay=1),), {}, 20, 20, "epoch")
    lower, _ = domains(model)
    assert list(lower) == [0, 0, 2, 1, 3]


@pytest.mark.parametrize("delay", [0, 1])
def test_cycles_are_left_to_cp_sat(delay):
    model = Problem(("epoch", "a", "b"), {},
        (Dependency("epoch", "a", 3), Dependency("a", "b", delay), Dependency("b", "a")), (), {}, 20, 20, "epoch")
    lower, _ = domains(model)
    assert list(lower) == [0, 3, 0]
    result = cp_sat.solve(model, Limits(seconds=5))
    assert result.status == ("OPTIMAL" if delay == 0 else "INFEASIBLE")


@pytest.mark.parametrize("limit", [0, 6, 10])
def test_solver_matches_without_domain_strengthening(monkeypatch, limit):
    model = Problem(("epoch", "a", "b"), {},
        (Dependency("epoch", "a", 3), Dependency("a", "b", 4), Dependency("b", "a", 0, 1)),
        (), {}, 20, limit, "epoch")
    strengthened = cp_sat.solve(model, Limits(seconds=5))
    with monkeypatch.context() as patch:
        patch.setattr(cp_sat, "domains", lambda problem: ([0]*len(problem.events), [0]*len(problem.events)))
        original = cp_sat.solve(model, Limits(seconds=5))
    assert strengthened.status == original.status
    assert strengthened.period == original.period


def test_parameter_selection_matches_original_domains(monkeypatch):
    model = choice_problem()
    strengthened = cp_sat.solve(model, Limits(seconds=5))
    with monkeypatch.context() as patch:
        patch.setattr(cp_sat, "domains", lambda problem: ([0]*len(problem.events), [0]*len(problem.events)))
        original = cp_sat.solve(model, Limits(seconds=5))
    assert strengthened.status == original.status == "OPTIMAL"
    assert strengthened.period == original.period
    assert strengthened.selected == original.selected


def test_decision_search_matches_exhaustive_schedules():
    model = choice_problem()
    periods = []
    for choice, period, before, after in product(("fast", "slow"), range(1, 7), range(7), range(7)):
        delay = 1 if choice == "fast" else 2
        if before >= delay and after >= before+delay and before >= after-delay*period and period >= after:
            periods.append(period)
    solution = cp_sat.solve(model)
    assert solution.status == "OPTIMAL" and solution.period == min(periods)
    validate_solution(model, solution)
    with pytest.raises(ValueError, match="violated dependency"):
        validate_solution(model, replace(solution, offsets={**solution.offsets, "c": 0}))
    with pytest.raises(ValueError, match="missing events"):
        validate_solution(model, replace(solution, offsets={"a": 0}))
    with pytest.raises(ValueError, match="resource totals"):
        validate_solution(model, replace(solution, resources={"invented": 1}))


def test_requested_period_still_requires_a_valid_complete_schedule():
    model=replace(choice_problem(),preferred_period=6)
    solution=cp_sat.solve(model,Limits(seconds=5,stop_at_period=6))
    assert solution.period<=6
    validate_solution(model,solution)
    with pytest.raises(ValueError,match="Stopping period"):
        cp_sat.solve(model,Limits(stop_at_period=0))
