"""The only module that knows about OR-Tools."""

from time import monotonic
from dataclasses import replace
import os

from ortools.sat.python import cp_model

from .schedule import ChoiceDelay, Limits, Problem, Solution, validate, validate_solution
from .precedence import domains


def solve(problem: Problem, limits: Limits = Limits()) -> Solution:
    validate(problem)
    if limits.seconds <= 0 or limits.workers < 1:
        raise ValueError("Positive solver time and worker count required")
    if limits.stop_at_period is not None and (type(limits.stop_at_period) is not int or limits.stop_at_period<1):
        raise ValueError("Stopping period must be a positive integer")
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
    for clause in problem.exclusions:
        model.add(sum(chosen[group,name] for group,names in clause for name in names)<len(clause))
    # First seek an incumbent at the supplied upper bound. Hints are not
    # constraints; the full joint search may replace every suggested option.
    model.add_hint(period,problem.preferred_period or problem.period_limit)
    for name,value in problem.preferred_offsets.items():
        model.add_hint(offsets[name],value)
    for group,preferred in problem.preferred_options.items():
        for option in problem.choices[group]:
            model.add_hint(chosen[group,option.name],int(option.name == preferred))
    # Once period and options are fixed, every remaining constraint is a
    # difference inequality. Its propagated lower bounds form a valid event
    # assignment; branching on those offsets cannot improve the objective.
    # Split the period interval so an infeasible short period rules out a range,
    # rather than advancing a million-cycle domain one value at a time.
    model.add_decision_strategy([period], cp_model.CHOOSE_FIRST, cp_model.SELECT_LOWER_HALF)
    # Try the resource-feasible proposal first, then the remaining alternatives.
    # One-hot groups propagate their other options as soon as one is selected.
    ordered=[]
    for group,options in problem.choices.items():
        preferred=problem.preferred_options.get(group)
        ordered.extend(chosen[group,option.name] for option in
                       sorted(options,key=lambda option:option.name!=preferred))
    model.add_decision_strategy(ordered,cp_model.CHOOSE_FIRST,cp_model.SELECT_MAX_VALUE)
    varying = {group for group, options in problem.choices.items() if len(options) > 1}

    def add(before, after, delay=0, frames=0, when=(), extra_guards=()):
        constraint = model.add(offsets[after] + frames * period >= offsets[before] + delay)
        guards = [chosen[pair] for pair in when if pair[0] in varying] + list(extra_guards)
        if guards:
            constraint.only_enforce_if(guards)

    delays={}
    for dependency in problem.dependencies:
        delay=dependency.delay
        guards=()
        if isinstance(delay,ChoiceDelay):
            if delay not in delays:
                complete=len(delay.values) == len(problem.choices[delay.choice])
                values=[value for _,value in delay.values]
                lower=min(values) if complete else 0
                variable=model.new_int_var(lower,max(values),f"delay{len(delays)}")
                model.add(variable == sum(value*chosen[delay.choice,option] for option,value in delay.values))
                if not complete:
                    enabled=model.new_bool_var(f"edge_enabled{len(delays)}")
                    model.add(enabled == sum(chosen[delay.choice,option] for option,_ in delay.values))
                    guards=(enabled,)
                delays[delay]=(variable,guards)
            delay,guards=delays[delay]
        add(dependency.before, dependency.after, delay, dependency.frames, dependency.when,guards)
    for fifo in problem.fifos:
        count = len(fifo.writes)
        when=fifo.when
        if fifo.order_transfers:
            for writes_or_reads in (fifo.writes, fifo.reads):
                for before, after in zip(writes_or_reads, writes_or_reads[1:]):
                    add(before, after, 1, when=when)
                add(writes_or_reads[-1], writes_or_reads[0], 1, 1, when)
        forward_delay = 1
        if fifo.forward_delays:
            first, last = min(fifo.forward_delays.values()), max(fifo.forward_delays.values())
            forward_delay = first
            if first != last:
                forward_delay = model.new_int_var(first, last, f"{fifo.choice}/forward_delay")
                model.add(forward_delay == sum(delay * chosen[fifo.choice, option]
                                               for option, delay in fifo.forward_delays.items()))
        # Availability is one inequality per word, even when many depth
        # choices share a latency. Choices fix the auxiliary delay exactly.
        for write, read in zip(fifo.writes, fifo.reads):
            add(write, read, forward_delay, when=when)
        depth_options = {}
        for option, depth in fifo.depths.items():
            depth_options.setdefault(depth, []).append(option)
        for depth, options in depth_options.items():
            if len(options) == len(fifo.depths):
                guards = ()
            elif len(options) == 1:
                guards = (chosen[fifo.choice, options[0]],)
            else:
                selected_depth = model.new_bool_var(f"{fifo.choice}/depth{depth}")
                model.add(selected_depth == sum(chosen[fifo.choice, option] for option in options))
                guards = (selected_depth,)
            for index, write in enumerate(fifo.writes):
                frame, word = divmod(index - depth, count)
                # write_j >= read_h + frame*T + replacement_delay.
                # frame may be negative, or zero within a large frame.
                add(fifo.reads[word], write, fifo.replacement_delay, -frame, when, guards)

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
    solver.parameters.log_search_progress = bool(os.environ.get("TORCH2RTL_SOLVER_LOG")) and len(problem.events)>1
    solver.parameters.search_branching = cp_model.FIXED_SEARCH if len(problem.events)>1 else cp_model.AUTOMATIC_SEARCH
    solver.parameters.instantiate_all_variables = False
    # Event models benefit from direct integer propagation. A one-event
    # resource/period relaxation retains presolve and LP for its choices.
    if len(problem.events) > 1:
        solver.parameters.cp_model_presolve = False
        solver.parameters.cp_model_probing_level = 0
        solver.parameters.linearization_level = 0
        solver.parameters.new_linear_propagation = False
    start = monotonic()
    class RequestedPeriod(cp_model.CpSolverSolutionCallback):
        def on_solution_callback(self):
            if self.value(period)<=limits.stop_at_period:
                self.stop_search()
    status = solver.solve(model,RequestedPeriod() if limits.stop_at_period is not None else None)
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
    option_penalties=sum(option.penalty*chosen[group,option.name]
                         for group,options in problem.choices.items() for option in options)
    has_penalties=any(option.penalty for options in problem.choices.values() for option in options)
    reached_target=limits.stop_at_period is not None and result.period is not None and result.period<=limits.stop_at_period
    if status == cp_model.OPTIMAL and not reached_target and (any(problem.resource_weights.values()) or has_penalties) and remaining > 0:
        model.add(period == result.period)
        model.minimize(option_penalties+sum(weight * resource_expressions[resource]
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
