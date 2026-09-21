"""Solver-independent finite actor choices and periodic event contracts."""

from dataclasses import dataclass, field


@dataclass(frozen=True, slots=True)
class Option:
    name: str
    resources: dict[str, int] = field(default_factory=dict)
    penalty: int = 0


@dataclass(frozen=True, slots=True)
class ChoiceDelay:
    """An edge's delay, present only for the listed options of one choice."""
    choice: str
    values: tuple[tuple[str, int], ...]


@dataclass(frozen=True, slots=True)
class Dependency:
    before: str
    after: str
    delay: int | ChoiceDelay = 0
    frames: int = 0
    when: tuple[tuple[str, str], ...] = ()


@dataclass(frozen=True, slots=True)
class Fifo:
    writes: tuple[str, ...]
    reads: tuple[str, ...]
    choice: str
    depths: dict[str, int]
    when: tuple[tuple[str, str], ...] = ()
    replacement_delay: int = 0
    forward_delays: dict[str, int] = field(default_factory=dict)
    # False only when surrounding actor contracts already imply ordered
    # one-word-per-cycle transfers, including frame wrap.
    order_transfers: bool = True


@dataclass(frozen=True)
class Problem:
    events: tuple[str, ...]
    choices: dict[str, tuple[Option, ...]]
    dependencies: tuple[Dependency, ...]
    fifos: tuple[Fifo, ...]
    budgets: dict[str, int]
    # Bounds restrict the search and are reported; never silently claim physical
    # infeasibility from an arbitrary latency or period cap.
    period_limit: int
    offset_limit: int
    anchor: str
    fixed_resources: dict[str, int] = field(default_factory=dict)
    resource_weights: dict[str, int] = field(default_factory=dict)
    preferred_options: dict[str, str] = field(default_factory=dict)
    preferred_period: int | None = None
    preferred_offsets: dict[str, int] = field(default_factory=dict)


@dataclass(frozen=True)
class Limits:
    seconds: float = 30
    workers: int = 1
    seed: int = 0


@dataclass(frozen=True)
class Solution:
    status: str
    period: int | None
    offsets: dict[str, int]
    selected: dict[str, str]
    resources: dict[str, int]
    period_bound: float
    seconds: float
    period_limit: int
    offset_limit: int
    resource_optimal: bool = False


def validate(problem):
    names = set(problem.events)
    option_names = {choice: {option.name for option in options} for choice,options in problem.choices.items()}
    validated_delays=set()
    if len(names) != len(problem.events) or problem.anchor not in names:
        raise ValueError("Events must be unique and contain the anchor")
    if problem.period_limit < 1 or problem.offset_limit < 0:
        raise ValueError("Invalid schedule bounds")
    if problem.preferred_period is not None and (type(problem.preferred_period) is not int or
                                                not 1 <= problem.preferred_period <= problem.period_limit):
        raise ValueError("Preferred period must lie within the search bounds")
    if not problem.preferred_offsets.keys() <= names or any(type(value) is not int or not 0 <= value <= problem.offset_limit
                                                           for value in problem.preferred_offsets.values()):
        raise ValueError("Preferred event offsets must lie within the search bounds")
    for choice, options in problem.choices.items():
        if not options or len({o.name for o in options}) != len(options):
            raise ValueError(f"Empty or duplicate options: {choice}")
        for option in options:
            if type(option.penalty) is not int or option.penalty < 0:
                raise ValueError("Option penalties must be nonnegative integers")
            if any(type(v) is not int or v < 0 for v in option.resources.values()):
                raise ValueError("Resource costs must be nonnegative integers")
            if not option.resources.keys() <= problem.budgets.keys():
                raise ValueError("Every resource used must have an explicit budget")
    if not problem.fixed_resources.keys() <= problem.budgets.keys():
        raise ValueError("Fixed resources need explicit budgets")
    if not problem.resource_weights.keys() <= problem.budgets.keys():
        raise ValueError("Tie-break weights reference an unknown resource")
    if any(type(v) is not int or v < 0 for v in
           [*problem.budgets.values(), *problem.fixed_resources.values(), *problem.resource_weights.values()]):
        raise ValueError("Budgets and fixed resources must be nonnegative integers")

    def guard(when):
        for choice, option in when:
            if choice not in option_names or option not in option_names[choice]:
                raise ValueError(f"Unknown option guard: {choice}/{option}")

    guard(tuple(problem.preferred_options.items()))

    for dependency in problem.dependencies:
        if dependency.before not in names or dependency.after not in names:
            raise ValueError("Dependency references an unknown event")
        if dependency.frames < 0:
            raise ValueError("Monotone contracts require nonnegative delays and frame advances")
        if isinstance(dependency.delay,ChoiceDelay):
            value=dependency.delay
            if value not in validated_delays:
                if not value.values or len(dict(value.values)) != len(value.values):
                    raise ValueError("Choice delays must have distinct, nonempty options")
                if any(type(delay) is not int or delay < 0 for _,delay in value.values):
                    raise ValueError("Monotone contracts require nonnegative delays")
                guard(tuple((value.choice,option) for option,_ in value.values))
                validated_delays.add(value)
        elif type(dependency.delay) is not int or dependency.delay < 0:
            raise ValueError("Monotone contracts require nonnegative delays")
        guard(dependency.when)
    for fifo in problem.fifos:
        if type(fifo.order_transfers) is not bool:
            raise ValueError("FIFO transfer ordering must be explicitly boolean")
        if not fifo.writes or len(fifo.writes) != len(fifo.reads):
            raise ValueError("FIFO producer and consumer word counts must match")
        if not set(fifo.writes + fifo.reads) <= names:
            raise ValueError("FIFO references an unknown event")
        if fifo.choice not in problem.choices:
            raise ValueError("FIFO choice does not exist")
        if set(fifo.depths) != {o.name for o in problem.choices[fifo.choice]}:
            raise ValueError("Each FIFO option needs a depth")
        if any(type(d) is not int or d < 1 for d in fifo.depths.values()):
            raise ValueError("Registered FIFO depths must be positive integers")
        if fifo.replacement_delay < 0:
            raise ValueError("FIFO replacement delay must be nonnegative")
        if fifo.forward_delays and (set(fifo.forward_delays) != set(fifo.depths) or
                                   any(type(delay) is not int or delay < 1 for delay in fifo.forward_delays.values())):
            raise ValueError("Each FIFO option needs a positive forward latency")
        guard(fifo.when)


def resource_totals(problem, selected):
    """Recompute costs from the current catalogue, including reused schedules."""
    if set(selected) != set(problem.choices):
        raise ValueError("Solver returned missing choices")
    usage = dict(problem.fixed_resources)
    for name, options in problem.choices.items():
        matches = [option for option in options if option.name == selected[name]]
        if len(matches) != 1:
            raise ValueError("Solver returned an unknown choice")
        for resource, count in matches[0].resources.items():
            usage[resource] = usage.get(resource, 0)+count
    return {resource: usage.get(resource, 0) for resource in problem.budgets}


def validate_solution(problem, solution):
    """Check a complete schedule against the original solver-independent model."""
    if type(solution.period) is not int or not 1 <= solution.period <= problem.period_limit:
        raise ValueError("Solver returned an invalid period")
    if (len(solution.offsets) != len(problem.events) or any(name not in solution.offsets for name in problem.events)
            or solution.offsets[problem.anchor] != 0):
        raise ValueError("Solver returned missing events or a displaced anchor")
    if any(type(offset) is not int or not 0 <= offset <= problem.offset_limit for offset in solution.offsets.values()):
        raise ValueError("Solver returned an offset outside the search bounds")
    usage = resource_totals(problem, solution.selected)
    if any(usage.get(resource, 0) > budget for resource, budget in problem.budgets.items()):
        raise ValueError("Solver returned a resource overrun")
    if solution.resources != usage:
        raise ValueError("Solver resource totals disagree with selected choices")

    def active(when):
        return all(solution.selected[group] == option for group, option in when)

    def check(before, after, delay=0, frames=0):
        if solution.offsets[after]+frames*solution.period < solution.offsets[before]+delay:
            raise ValueError(f"Solver returned a violated dependency: {before} -> {after}")

    for edge in problem.dependencies:
        if active(edge.when):
            delay=edge.delay
            if isinstance(delay,ChoiceDelay):
                delay=dict(delay.values).get(solution.selected[delay.choice])
                if delay is None:
                    continue
            check(edge.before, edge.after, delay, edge.frames)
    for fifo in problem.fifos:
        if not active(fifo.when):
            continue
        option = solution.selected[fifo.choice]
        if fifo.order_transfers:
            for stream in (fifo.writes, fifo.reads):
                for before, after in zip(stream, stream[1:]):
                    check(before, after, 1)
                check(stream[-1], stream[0], 1, 1)
        delay = fifo.forward_delays.get(option, 1)
        depth, count = fifo.depths[option], len(fifo.writes)
        for index, (write, read) in enumerate(zip(fifo.writes, fifo.reads)):
            check(write, read, delay)
            frame, word = divmod(index-depth, count)
            check(fifo.reads[word], write, fifo.replacement_delay, -frame)


def fifo_occupancy(problem,solution):
    """Periodic payload occupancy, including values carried across inferences.

    Ordered slot-reuse constraints still govern registered replacement timing;
    this report explains storage use and does not replace those constraints.
    """
    result={}
    period=solution.period
    for fifo in problem.fifos:
        if any(solution.selected[group] != option for group,option in fifo.when):
            continue
        deltas={}
        live=0
        lifetime=0
        for write,read in zip(fifo.writes,fifo.reads):
            first,last=solution.offsets[write],solution.offsets[read]
            live+=last//period-first//period
            lifetime+=last-first
            deltas[first%period]=deltas.get(first%period,0)+1
            deltas[last%period]=deltas.get(last%period,0)-1
        peak=live
        for cycle,change in sorted(deltas.items()):
            live+=change
            peak=max(peak,live)
        depth=fifo.depths[solution.selected[fifo.choice]]
        if peak>depth:
            raise ValueError("Periodic FIFO occupancy exceeds selected storage")
        result[fifo.choice]={"depth":depth,"peak_live_words":peak,
                             "mean_live_words":lifetime/period}
    return result
