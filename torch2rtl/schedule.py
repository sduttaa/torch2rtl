"""Solver-independent finite actor choices and periodic event contracts."""

from dataclasses import dataclass, field


@dataclass(frozen=True)
class Option:
    name: str
    resources: dict[str, int] = field(default_factory=dict)


@dataclass(frozen=True)
class Dependency:
    before: str
    after: str
    delay: int = 0
    frames: int = 0
    when: tuple[tuple[str, str], ...] = ()


@dataclass(frozen=True)
class Fifo:
    writes: tuple[str, ...]
    reads: tuple[str, ...]
    choice: str
    depths: dict[str, int]
    when: tuple[tuple[str, str], ...] = ()
    replacement_delay: int = 0
    forward_delays: dict[str, int] = field(default_factory=dict)


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
    if len(names) != len(problem.events) or problem.anchor not in names:
        raise ValueError("Events must be unique and contain the anchor")
    if problem.period_limit < 1 or problem.offset_limit < 0:
        raise ValueError("Invalid schedule bounds")
    for choice, options in problem.choices.items():
        if not options or len({o.name for o in options}) != len(options):
            raise ValueError(f"Empty or duplicate options: {choice}")
        for option in options:
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
            if choice not in problem.choices or option not in {o.name for o in problem.choices[choice]}:
                raise ValueError(f"Unknown option guard: {choice}/{option}")

    for dependency in problem.dependencies:
        if dependency.before not in names or dependency.after not in names:
            raise ValueError("Dependency references an unknown event")
        if dependency.delay < 0 or dependency.frames < 0:
            raise ValueError("Monotone contracts require nonnegative delays and frame advances")
        guard(dependency.when)
    for fifo in problem.fifos:
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
