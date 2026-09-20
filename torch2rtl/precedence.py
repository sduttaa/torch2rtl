"""Implied event domains from unconditional within-frame precedence paths.

This is a relaxation used only to tighten domains. Conditional and frame-wrap
constraints remain in the solver, as do all constraints summarized here.
Cycles are left to the solver; acyclic paths need one forward/backward pass.
"""

from array import array


def mandatory_edges(problem):
    varying = {name for name, options in problem.choices.items() if len(options) > 1}

    def unconditional(when):
        return all(choice not in varying for choice, _ in when)

    for edge in problem.dependencies:
        if edge.frames == 0 and unconditional(edge.when):
            yield edge.before, edge.after, edge.delay
    for fifo in problem.fifos:
        if not unconditional(fifo.when):
            continue
        if fifo.order_transfers:
            for stream in (fifo.writes, fifo.reads):
                for before, after in zip(stream, stream[1:]):
                    yield before, after, 1
        delay = min(fifo.forward_delays.values()) if fifo.forward_delays else 1
        for write, read in zip(fifo.writes, fifo.reads):
            yield write, read, delay
        depths = set(fifo.depths.values())
        if len(depths) == 1:
            depth = next(iter(depths))
            for index in range(depth, len(fifo.writes)):
                yield fifo.reads[index-depth], fifo.writes[index], fifo.replacement_delay


def domains(problem):
    """Return arrays of lower bounds and distances below the common upper bound.

    Call after schedule.validate. Values saturate one beyond offset_limit;
    that sentinel proves an empty domain without large path-sum arithmetic.
    Compact adjacency arrays avoid millions of Python adjacency-list objects.
    """
    count = len(problem.events)
    index = {name: position for position, name in enumerate(problem.events)}
    degree, incoming = array("Q", [0])*count, array("Q", [0])*count
    for before, after, _ in mandatory_edges(problem):
        degree[index[before]] += 1
        incoming[index[after]] += 1
    rows = array("Q", [0])
    for size in degree:
        rows.append(rows[-1]+size)
    targets, delays = array("Q", [0])*rows[-1], array("Q", [0])*rows[-1]
    cursor = rows[:-1]
    ceiling = problem.offset_limit+1
    for before, after, delay in mandatory_edges(problem):
        source = index[before]
        position = cursor[source]
        targets[position], delays[position] = index[after], min(delay, ceiling)
        cursor[source] += 1
    anchor = index[problem.anchor]
    del index, degree, cursor
    lower, distance = array("Q", [0])*count, array("Q", [0])*count
    distance[anchor] = problem.offset_limit
    order = array("Q", (position for position, degree in enumerate(incoming) if degree == 0))
    head = 0
    while head < len(order):
        source = order[head]
        head += 1
        for position in range(rows[source], rows[source+1]):
            target = targets[position]
            lower[target] = max(lower[target], min(ceiling, lower[source]+delays[position]))
            incoming[target] -= 1
            if incoming[target] == 0:
                order.append(target)
    for source in reversed(order):
        for position in range(rows[source], rows[source+1]):
            distance[source] = max(distance[source], min(ceiling, distance[targets[position]]+delays[position]))
    return lower, distance
