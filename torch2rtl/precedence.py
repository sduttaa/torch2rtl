"""Implied event domains from unconditional within-frame precedence paths.

This is a relaxation used only to tighten domains. Conditional and frame-wrap
constraints remain in the solver, as do all constraints summarized here.
Cycles are left to the solver; acyclic paths need one forward/backward pass.
"""

from array import array
from .schedule import ChoiceDelay


def mandatory_edges(problem):
    varying = {name for name, options in problem.choices.items() if len(options) > 1}

    def unconditional(when):
        return all(choice not in varying for choice, _ in when)

    for edge in problem.dependencies:
        if edge.frames == 0 and unconditional(edge.when):
            delay=edge.delay
            if isinstance(delay,ChoiceDelay):
                if len(delay.values) != len(problem.choices[delay.choice]):
                    continue
                delay=min(value for _,value in delay.values)
            yield edge.before, edge.after, delay
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


def blocking_cycle(problem, rounds=8):
    """Explain a rejected fixed proposal with a positive dependency cycle.

    This returns only a directly checked infeasibility witness, never a valid
    schedule. CP-SAT still selects and verifies every accepted implementation.
    Within-frame DAG passes make the common periodic case inexpensive; failure
    to find a witness leaves the complete solver responsible for the problem.
    """
    if any(len(options)!=1 for options in problem.choices.values()):
        raise ValueError("Cycle explanations require fixed choices")
    selected={group:options[0].name for group,options in problem.choices.items()}
    index={name:position for position,name in enumerate(problem.events)}
    sources,targets,delays,frames,owners=(array("q") for _ in range(5))
    guards=[()]
    guard_ids={():0}

    def append(before,after,delay,advance,when):
        if any(selected[group]!=name for group,name in when):
            return
        if when not in guard_ids:
            guard_ids[when]=len(guards)
            guards.append(when)
        sources.append(index[before]);targets.append(index[after])
        delays.append(delay);frames.append(advance);owners.append(guard_ids[when])

    for edge in problem.dependencies:
        delay,when=edge.delay,edge.when
        if isinstance(delay,ChoiceDelay):
            value=dict(delay.values).get(selected[delay.choice])
            if value is None:
                continue
            when=when+((delay.choice,selected[delay.choice]),)
            delay=value
        append(edge.before,edge.after,delay,edge.frames,when)
    for fifo in problem.fifos:
        name=selected[fifo.choice]
        when=fifo.when+((fifo.choice,name),)
        if fifo.order_transfers:
            for stream in (fifo.writes,fifo.reads):
                for before,after in zip(stream,stream[1:]):
                    append(before,after,1,0,when)
                append(stream[-1],stream[0],1,1,when)
        count=len(fifo.writes)
        for position,(write,read) in enumerate(zip(fifo.writes,fifo.reads)):
            append(write,read,fifo.forward_delays.get(name,1),0,when)
            frame,word=divmod(position-fifo.depths[name],count)
            append(fifo.reads[word],write,fifo.replacement_delay,-frame,when)
    del index
    count=len(problem.events)
    degree,incoming=(array("q",[0])*count for _ in range(2))
    wrapped=array("q")
    for edge,(source,target,advance) in enumerate(zip(sources,targets,frames)):
        if advance:
            wrapped.append(edge)
        else:
            degree[source]+=1;incoming[target]+=1
    rows=array("q",[0])
    for size in degree:
        rows.append(rows[-1]+size)
    adjacency=array("q",[0])*rows[-1]
    cursor=rows[:-1]
    for edge,(source,advance) in enumerate(zip(sources,frames)):
        if not advance:
            adjacency[cursor[source]]=edge;cursor[source]+=1
    del degree,cursor
    order=array("q",(node for node,value in enumerate(incoming) if not value))
    for source in order:
        for position in range(rows[source],rows[source+1]):
            target=targets[adjacency[position]]
            incoming[target]-=1
            if not incoming[target]:
                order.append(target)
    acyclic=len(order)==count
    if not acyclic:
        order.extend(node for node,value in enumerate(incoming) if value)
    del incoming
    distance,previous=array("q",[0])*count,array("q",[-1])*count
    for _ in range(rounds):
        changed=False
        for source in order:
            for position in range(rows[source],rows[source+1]):
                edge=adjacency[position];target=targets[edge]
                value=distance[source]+delays[edge]
                if value>distance[target]:
                    distance[target]=value;previous[target]=edge
                    changed=changed or not acyclic
        for edge in wrapped:
            target=targets[edge]
            value=distance[sources[edge]]+delays[edge]-frames[edge]*problem.period_limit
            if value>distance[target]:
                changed=True;distance[target]=value;previous[target]=edge
        if not changed:
            return None
        marks=array("q",[0])*count
        for start in range(count):
            if marks[start] or previous[start]<0:
                continue
            node=start
            while previous[node]>=0 and not marks[node]:
                marks[node]=start+1;node=sources[previous[node]]
            if previous[node]<0 or marks[node]!=start+1:
                continue
            first=node;delay=advance=0;cause=set()
            while True:
                edge=previous[node]
                assert targets[edge]==node
                delay+=delays[edge];advance+=frames[edge]
                cause.update(guards[owners[edge]])
                node=sources[edge]
                if node==first:
                    break
            # Adding these closed-cycle inequalities cancels every event
            # offset. Keep a cut only when their exact integer sum conflicts.
            if delay>advance*problem.period_limit:
                return {"choices":tuple(sorted(cause)),"delay":delay,"frames":advance}
    return None
