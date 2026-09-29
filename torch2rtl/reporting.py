"""Distinguish measured performance shortfalls from invalid tool results."""

import math
import re


def frequency_miss_only(returncode, log):
    errors=re.findall(r"^ERROR: (.*)$",log,re.MULTILINE)
    return returncode==1 and bool(errors) and all(
        re.fullmatch(r"Max frequency for clock '.+': [0-9.]+ MHz \(FAIL at [0-9.]+ MHz\)",error)
        for error in errors)


def timing_checks_passed(fmax):
    if not isinstance(fmax,dict) or not fmax:
        raise ValueError("Missing routed clock timing")
    for clock,record in fmax.items():
        for field in ("achieved","constraint"):
            value=record.get(field)
            if isinstance(value,bool) or not isinstance(value,(int,float)) or not math.isfinite(value) or value<=0:
                raise ValueError(f"Invalid {field} frequency for {clock}")
    return all(record["achieved"]>record["constraint"] for record in fmax.values())


def reported_fps(clock_hz, period_cycles, achieved_mhz):
    if any(not math.isfinite(value) or value<=0 for value in (clock_hz,period_cycles,achieved_mhz)):
        raise ValueError("Clock, period and routed frequency must be positive and finite")
    return min(clock_hz,achieved_mhz*1e6)/period_cycles
