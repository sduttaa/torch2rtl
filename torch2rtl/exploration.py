"""Bound additional measurements around bottlenecks and resource tradeoffs."""

from copy import deepcopy


def refine(measured, proposed, incumbent, proposal, target, budget, limit):
    """Keep the measured incumbent and spend a global budget on new options.

    This is a search heuristic, not a dominance proof: different buffering and
    burst contracts are retained even when their frame-period bounds coincide.
    """
    if type(budget) is not int or budget < 1:
        raise ValueError("refinement_options must be a positive integer")
    candidates=[]
    for actor,options in proposed["actor_options"].items():
        previous=measured["actor_options"][actor]
        selected=incumbent.selected.get("actor:"+actor) if incumbent.period is not None else None
        baseline=previous.get(selected)
        for name,spec in options.items():
            if name in previous or "measurement" in spec:
                continue
            # First test the new global relaxation's choices; then focus on
            # bottlenecks and savings in the resources under most pressure.
            gain=0
            if baseline is not None:
                gain=max(0,baseline["period_bound"]-spec["period_bound"])/max(1,incumbent.period)
                gain+=sum(max(0,baseline["resources"].get(key,0)-spec["resources"].get(key,0))/capacity
                          *incumbent.resources.get(key,0)/capacity
                          for key,capacity in target["resources"].items() if capacity)
            candidates.append((name!=proposal.selected.get("actor:"+actor),-gain,
                               -(baseline or spec)["period_bound"],actor,name))
    additions={}
    for *_,actor,name in sorted(candidates)[:budget]:
        additions.setdefault(actor,[]).append(name)
    result=deepcopy(measured)
    for actor,options in proposed["actor_options"].items():
        old=measured["actor_options"][actor]
        previous=incumbent.selected.get("actor:"+actor) if incumbent.period is not None else None
        new=additions.get(actor,[])
        known=[name for name,spec in options.items() if "measurement" in spec]
        order=list(dict.fromkeys(name for name in [previous,*new,*known,*old] if name is not None))
        result["actor_options"][actor]={name:deepcopy(options.get(name,old.get(name))) for name in order[:limit]}
    return result
