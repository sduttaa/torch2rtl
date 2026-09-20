"""The only module that knows about OR-Tools."""

from time import monotonic
from dataclasses import replace

from ortools.sat.python import cp_model

from .schedule import Limits, Problem, Solution, validate, validate_solution
from .precedence import domains


def solve(problem: Problem, limits: Limits = Limits()) -> Solution:
    validate(problem)
    if limits.seconds <= 0 or limits.workers < 1:
        raise ValueError("Positive solver time and worker count required")
    model = cp_model.CpModel()
    period = model.new_int_var(1, problem.period_limit, "period")
    lower, distance = domains(problem)
    offsets = {}
    for index, name in enumerate(problem.events):
        first, last = lower[index], problem.offset_limit-distance[index]
        if first > last:
            model.add(False)
            first, last = 0, problem.offset_limit
        offsets[name] = model.new_int_var(first, last, name)
    del lower, distance
    model.add(offsets[problem.anchor] == 0)
    chosen = {(group, option.name): model.new_bool_var(f"{group}/{option.name}")
              for group, options in problem.choices.items() for option in options}
    for group, options in problem.choices.items():
        model.add_exactly_one(chosen[group, option.name] for option in options)
    # Once period and options are fixed, every remaining constraint is a
    # difference inequality. Its propagated lower bounds form a valid event
    # assignment; branching on those offsets cannot improve the objective.
    model.add_decision_strategy([period, *chosen.values()], cp_model.CHOOSE_FIRST, cp_model.SELECT_MIN_VALUE)
    varying = {group for group, options in problem.choices.items() if len(options) > 1}

    def add(before, after, delay=0, frames=0, when=()):
        constraint = model.add(offsets[after] + frames * period >= offsets[before] + delay)
        guards = [chosen[pair] for pair in when if pair[0] in varying]
        if guards:
            constraint.only_enforce_if(guards)

    for dependency in problem.dependencies:
        add(dependency.before, dependency.after, dependency.delay, dependency.frames, dependency.when)
    for fifo in problem.fifos:
        count = len(fifo.writes)
        if fifo.order_transfers:
            for writes_or_reads in (fifo.writes, fifo.reads):
                for before, after in zip(writes_or_reads, writes_or_reads[1:]):
                    add(before, after, 1, when=fifo.when)
                add(writes_or_reads[-1], writes_or_reads[0], 1, 1, fifo.when)
        if not fifo.forward_delays:
            for write, read in zip(fifo.writes, fifo.reads):
                add(write, read, 1, when=fifo.when)
        for option, depth in fifo.depths.items():
            active = fifo.when + ((fifo.choice, option),)
            if fifo.forward_delays:
                for write, read in zip(fifo.writes, fifo.reads):
                    add(write, read, fifo.forward_delays[option], when=active)
            for index, write in enumerate(fifo.writes):
                frame, word = divmod(index - depth, count)
                # write_j >= read_h + frame*T + replacement_delay.
                # frame may be negative, or zero within a large frame.
                add(fifo.reads[word], write, fifo.replacement_delay, -frame, active)

    resource_expressions = {}
    for resource, budget in problem.budgets.items():
        usage = problem.fixed_resources.get(resource, 0) + sum(
            option.resources.get(resource, 0) * chosen[group, option.name]
            for group, options in problem.choices.items() for option in options)
        resource_expressions[resource] = usage
        model.add(usage <= budget)
    model.minimize(period)
    validation_error = model.validate()
    if validation_error:
        raise ValueError(validation_error)
    solver = cp_model.CpSolver()
    solver.parameters.max_time_in_seconds = limits.seconds
    solver.parameters.num_search_workers = limits.workers
    solver.parameters.random_seed = limits.seed
    solver.parameters.search_branching = cp_model.FIXED_SEARCH
    solver.parameters.instantiate_all_variables = False
    start = monotonic()
    status = solver.solve(model)
    feasible = status in (cp_model.OPTIMAL, cp_model.FEASIBLE)
    result = Solution(
        status=solver.status_name(status),
        period=solver.value(period) if feasible else None,
        offsets={name: solver.value(var) for name, var in offsets.items()} if feasible else {},
        selected={group: option.name for group, options in problem.choices.items() for option in options
                  if feasible and solver.boolean_value(chosen[group, option.name])},
        resources={r: solver.value(expr) for r, expr in resource_expressions.items()} if feasible else {},
        period_bound=solver.best_objective_bound, seconds=monotonic() - start,
        period_limit=problem.period_limit, offset_limit=problem.offset_limit,
    )
    remaining = limits.seconds - (monotonic() - start)
    if status == cp_model.OPTIMAL and any(problem.resource_weights.values()) and remaining > 0:
        model.add(period == result.period)
        model.minimize(sum(weight * resource_expressions[resource]
                           for resource, weight in problem.resource_weights.items()))
        solver.parameters.max_time_in_seconds = remaining
        tie_status = solver.solve(model)
        if tie_status in (cp_model.OPTIMAL, cp_model.FEASIBLE):
            result = replace(result,
                offsets={name: solver.value(var) for name, var in offsets.items()},
                selected={group: option.name for group, options in problem.choices.items()
                          for option in options if solver.boolean_value(chosen[group, option.name])},
                resources={r: solver.value(expr) for r, expr in resource_expressions.items()},
                resource_optimal=tie_status == cp_model.OPTIMAL)
    result = replace(result, seconds=monotonic() - start)
    if result.period is not None:
        validate_solution(problem, result)
    return result
