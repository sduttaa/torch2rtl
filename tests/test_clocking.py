import pytest

from torch2rtl.clocking import verify_clock
from torch2rtl.implementation import rank_plans, clock_choices


def netlist():
    return {"modules":{"harness":{"netnames":{"clk":{"bits":[1]},"core_clock":{"bits":[2]}},
        "cells":{"pll":{"type":"rPLL","parameters":{"IDIV_SEL":"0","FBDIV_SEL":"11","FCLKIN":"12.0"},
        "connections":{"CLKIN":[1],"CLKOUT":[2]},"port_directions":{"CLKIN":"input","CLKOUT":"output"}}}}}}


def test_clock_dividers_match_target_not_just_timing_constraint():
    assert verify_clock(netlist(),12_000_000,48_000_000)["matches"]
    with pytest.raises(ValueError,match="implements"):
        verify_clock(netlist(),12_000_000,36_000_000)
    with pytest.raises(ValueError,match="reference clock"):
        verify_clock(netlist(),10_000_000,40_000_000)
    design=netlist()
    design["modules"]["harness"]["cells"]["pll"]["parameters"]["DYN_IDIV_SEL"]="true"
    with pytest.raises(ValueError,match="Dynamic"):
        verify_clock(design,12_000_000,48_000_000)


def test_route_feedback_prefers_legal_clock_with_headroom():
    plans=[{"clock_hz":hz,"scheduled_fps":fps,"solver_verified":True,"resources":{"lut":sites}}
           for hz,fps,sites in ((120,40,100),(90,39,90),(80,37,80))]
    assert rank_plans(plans,{"lut":100})[0]["clock_hz"]==120
    assert rank_plans(plans,{"lut":100},95)[0]["clock_hz"]==90
    assert rank_plans(plans,{"lut":100},85)[0]["clock_hz"]==80
    # Timing-derived throughput cannot beat a slower, clock-safe bitstream by
    # pretending the faster configured clock can be used on hardware.
    plans[0]["solver_verified"]=False
    assert all(p["clock_hz"]!=120 for p in rank_plans(plans,{"lut":100}))


def test_clock_candidates_require_rtl_and_bounded_attempts(tmp_path):
    (tmp_path/"clock.sv").write_text("clock definition")
    job={"clock_candidates":[{"clock_hz":48,"clock_rtl":"clock.sv"}]}
    choices,attempts,margin=clock_choices(job,tmp_path)
    assert list(choices)==[48] and attempts==1 and 0<=margin<1
    with pytest.raises(ValueError,match="attempts"):
        clock_choices({**job,"implementation_attempts":2},tmp_path)
