"""Independent occupancy and protocol tests for periodic schedule selection."""

from dataclasses import replace
from itertools import combinations

import pytest

from torch2rtl.cp_sat import solve
from torch2rtl.schedule import Dependency, Fifo, Limits, Option, Problem


def test_ordered_capacity_matches_occupancy():
    for writes in combinations(range(7), 3):
        for reads in combinations(range(1, 8), 3):
            if any(r <= w for w, r in zip(writes, reads)):
                continue
            for depth in range(1, 5):
                ordered = all(writes[k] >= reads[k - depth] for k in range(depth, 3))
                occupancy = max(sum(w <= cycle < r for w, r in zip(writes, reads))
                                for cycle in range(8))
                assert ordered == (occupancy <= depth)


def pipeline(depths=(1, 2, 5), budget=5):
    writes = tuple(f"w{i}" for i in range(3))
    reads = tuple(f"r{i}" for i in range(3))
    return Problem(
        events=("start",) + writes + reads,
        choices={"fifo": tuple(Option(str(d), {"slots": d}) for d in depths)},
        dependencies=(Dependency("start", "w0"),),
        fifos=(Fifo(writes, reads, "fifo", {str(d): d for d in depths}),),
        budgets={"slots": budget}, period_limit=30, offset_limit=60, anchor="start",
    )


@pytest.mark.parametrize("depth", [1, 2, 5])
def test_periodic_fifo_and_empty_startup(depth):
    problem = pipeline((depth,))
    solution = solve(problem)
    assert solution.status == "OPTIMAL"
    assert solution.period == 3
    fifo = problem.fifos[0]
    writes = [solution.offsets[w] + frame * solution.period
              for frame in range(6) for w in fifo.writes]
    reads = [solution.offsets[r] + frame * solution.period
             for frame in range(6) for r in fifo.reads]
    assert all(r > w for w, r in zip(writes, reads))
    assert max(sum(w <= t < r for w, r in zip(writes, reads))
               for t in range(max(reads) + 1)) <= depth


def test_reduction_bypass_requires_full_buffer():
    # A fork writes three bypass words. The join cannot consume any until the
    # reduction has seen all three: a depth-two FIFO causes a true deadlock.
    problem = pipeline()
    problem = replace(problem, dependencies=problem.dependencies + (Dependency("w2", "r0", 1),))
    solution = solve(problem)
    assert solution.status == "OPTIMAL"
    assert solution.selected["fifo"] == "5"
    assert solve(replace(problem, budgets={"slots": 2})).status == "INFEASIBLE"


def test_actor_choice_balances_rate_within_resources():
    problem = pipeline((1,))
    problem = replace(problem, choices={**problem.choices, "actor": (
        Option("serial", {"lanes": 1}), Option("parallel", {"lanes": 2}))},
        budgets={"slots": 1, "lanes": 2}, dependencies=problem.dependencies + (
            Dependency("start", "start", 8, 1, (("actor", "serial"),)),
            Dependency("start", "start", 4, 1, (("actor", "parallel"),)),
        ))
    fast = solve(problem)
    slow = solve(replace(problem, budgets={"slots": 1, "lanes": 1}))
    assert fast.period == 4 and fast.selected["actor"] == "parallel"
    assert slow.period == 8 and slow.selected["actor"] == "serial"


def test_invalid_domains_and_resources_are_rejected():
    with pytest.raises(ValueError):
        solve(replace(pipeline(), budgets={}))
    with pytest.raises(ValueError):
        solve(pipeline(), Limits(seconds=0))


def test_resource_tiebreak_keeps_the_best_period():
    solution = solve(replace(pipeline(), resource_weights={"slots": 1}))
    assert solution.status == "OPTIMAL" and solution.period == 3
    assert solution.selected["fifo"] == "1" and solution.resource_optimal


def test_fifo_without_simultaneous_slot_replacement():
    problem = pipeline((1,))
    problem = replace(problem, fifos=(replace(problem.fifos[0], replacement_delay=1),))
    solution = solve(problem)
    assert solution.period == 6


@pytest.mark.parametrize("depth,latency,period", [(1, 1, 3), (1, 2, 6), (2, 2, 3)])
def test_fifo_forward_latency_participates_in_the_schedule(depth, latency, period):
    problem = pipeline((depth,))
    problem = replace(problem, fifos=(replace(problem.fifos[0], forward_delays={str(depth): latency}),))
    solution = solve(problem)
    assert solution.period == period
    assert all(solution.offsets[read] >= solution.offsets[write] + latency
               for write, read in zip(problem.fifos[0].writes, problem.fifos[0].reads))


@pytest.mark.parametrize("delays", [{"1": 3, "2": 1, "5": 2}, {"1": 2, "2": 2, "5": 2}])
@pytest.mark.parametrize("budget", [0, 1, 2, 5])
def test_selected_forward_latency_matches_explicit_guarded_constraints(delays, budget):
    model = replace(pipeline(budget=budget), resource_weights={"slots": 1})
    fifo = model.fifos[0]
    selected_delay = replace(model, fifos=(replace(fifo, forward_delays=delays),))
    explicit_guards = replace(model, dependencies=model.dependencies + tuple(
        Dependency(write, read, delay, when=((fifo.choice, option),))
        for option, delay in delays.items() for write, read in zip(fifo.writes, fifo.reads)))
    selected, explicit = solve(selected_delay), solve(explicit_guards)
    assert (selected.status, selected.period, selected.selected) == (explicit.status, explicit.period, explicit.selected)


def test_large_period_cycle_is_optimized_without_an_explicit_cycle_sum():
    # Summing the two inequalities gives T >= 1,000,000. The event offsets
    # float relative to the anchor, so this bound must be found by CP-SAT.
    model = Problem(("epoch", "a", "b"), {},
        (Dependency("a", "b", 123457), Dependency("b", "a", 876543, 1)),
        (), {}, 2000000, 3000000, "epoch")
    solution = solve(model, Limits(seconds=5))
    assert solution.status == "OPTIMAL" and solution.period == 1000000
