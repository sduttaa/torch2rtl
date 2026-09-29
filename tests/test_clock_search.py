from copy import deepcopy
import json
from pathlib import Path

import pytest

from torch2rtl.implementation import implement_clocks
from torch2rtl.optimize import clock_plans, finish
from torch2rtl.graph import Graph, Value
from torch2rtl.lower import Tensor
from torch2rtl.schedule import Limits


def test_clock_plans_share_catalogue_and_do_not_mutate_inputs(tmp_path,monkeypatch):
    catalogue={"actor_options":{"actor":{"selected":{"resources":{"lut":7}}}}}
    saved=deepcopy(catalogue)
    calls=[]
    def schedule(graph,candidate,target,search,directory,*args):
        calls.append(target["clock_hz"])
        candidate.clear()
        return {"solver_verified":True,"scheduled_fps":target["clock_hz"]/10,"solution":{"resources":{"lut":7}}}
    monkeypatch.setattr("torch2rtl.optimize.finish",schedule)
    result=clock_plans(None,catalogue,{"clock_hz":100},{"clock_candidates_hz":[100,80]},tmp_path,tmp_path,Limits(),lambda text:None)
    assert calls==[100,80] and catalogue==saved
    assert len(result["clock_plans"])==2
    assert json.loads((tmp_path/"clock-80/target.json").read_text())["clock_hz"]==80


def test_missed_throughput_still_emits_verified_slower_design(tmp_path):
    source=Value("input","input",(),Tensor((1,1,2,3),8,False))
    output=Value("lookup","byte_lookup",(source,tuple(range(256))),source.tensor)
    graph=Graph(source,output,(source,output))
    catalogue={"model":"user.pt2","model_sha256":"test","lanes":1,
               "period_limit":100,"offset_limit":200,"screen":{},
               "actor_options":{"lookup":{"table":{"period_bound":6,"resources":{"lut":3}}}},
               "fifo_options":{"input->lookup:0":{"two":{"depth":2,"memory":"distributed","resources":{"lut":2}}}}}
    target={"clock_hz":100,"required_fps":100,"resources":{"lut":10}}
    result=finish(graph,catalogue,target,{"stop_at_required_fps":True},tmp_path,tmp_path,Limits(seconds=2),lambda text:None)
    assert result["solver_verified"] and not result["required_fps_met"]
    assert result["scheduled_fps"]<=100/6
    assert (tmp_path/"schedule/inference.sv").exists()


@pytest.mark.parametrize("search,period",[({},6),({"stop_at_required_fps":False},6),
                                          ({"stop_at_required_fps":True},20)])
@pytest.mark.parametrize("joint_limit",[None,1])
def test_target_does_not_stop_period_optimization_unless_requested(tmp_path,search,period,joint_limit):
    if joint_limit is not None:
        search={**search,"joint_event_limit":joint_limit}
    source=Value("input","input",(),Tensor((1,1,2,3),8,False))
    output=Value("lookup","byte_lookup",(source,tuple(range(256))),source.tensor)
    graph=Graph(source,output,(source,output))
    catalogue={"model":"user.pt2","model_sha256":"test","lanes":1,
               "period_limit":100,"offset_limit":200,"screen":{},
               "preferred_options":{"actor:lookup":"table","fifo:input->lookup:0":"two"},
               "actor_options":{"lookup":{"table":{"period_bound":6,"resources":{"lut":3}}}},
               "fifo_options":{"input->lookup:0":{
                   "one":{"depth":1,"memory":"distributed","resources":{"lut":1}},
                   "two":{"depth":2,"memory":"distributed","resources":{"lut":2}}}}}
    target={"clock_hz":100,"required_fps":5,"resources":{"lut":10}}
    result=finish(graph,catalogue,target,search,tmp_path,tmp_path,Limits(seconds=2),lambda text:None)
    assert result["solver_verified"] and result["required_fps_met"]
    assert result["incumbent_search"]["period"]==20
    assert result["solution"]["period"]==period
    assert ("objective_search_stopped" in result)==search.get("stop_at_required_fps",False)


def test_bounded_joint_search_optimizes_automatic_proposal(tmp_path,monkeypatch):
    from torch2rtl.spatial_compile import compile_network
    from torch2rtl.cp_sat import solve
    source=Value("input","input",(),Tensor((1,1,2,3),8,False))
    output=Value("lookup","byte_lookup",(source,tuple(range(256))),source.tensor)
    graph=Graph(source,output,(source,output))
    catalogue={"model":"user.pt2","model_sha256":"test","lanes":1,
               "period_limit":100,"offset_limit":200,"joint_event_limit":1,
               "preferred_options":{"actor:lookup":"table","fifo:input->lookup:0":"two"},
               "actor_options":{"lookup":{"table":{"resources":{"lut":3}}}},
               "fifo_options":{"input->lookup:0":{
                   "one":{"depth":1,"resources":{"lut":1}},
                   "two":{"depth":2,"resources":{"lut":2}}}}}
    def bounded(problem,limits):
        # Resource proposals stay small; every expanded solve must have
        # fixed choices when the supplied joint event budget is exceeded.
        assert len(problem.events)==1 or all(len(options)==1 for options in problem.choices.values())
        return solve(problem,limits)
    monkeypatch.setattr("torch2rtl.spatial_compile.solve",bounded)
    result=compile_network(graph,catalogue,{"resources":{"lut":10}},tmp_path,Limits(seconds=2))
    assert result["solver_verified"]
    assert result["incumbent_search"]["period"]==100
    assert result["proposal_period_search"]["period"]==6
    assert result["solution"]["period"]==6
    assert result["solution"]["status"]=="FEASIBLE"
    assert result["solution"]["period_bound"]==0
    assert result["joint_search_limited"]["event_limit"]==1


def test_implementation_retries_match_clock_rtl_and_keep_safe_result(tmp_path):
    target={"clock_hz":120,"resources":{"lut":100}}
    for name,data in (("target.json",target),("search.json",{})):
        (tmp_path/name).write_text(json.dumps(data))
    for hz in (120,90,80):
        (tmp_path/f"clock-{hz}.sv").write_text(f"clock {hz}")
    job={"target":"target.json","search":"search.json","model":"model.pt2","cache":"cache","clock_net":"core",
         "clock_candidates":[{"clock_hz":hz,"clock_rtl":f"clock-{hz}.sv"} for hz in (120,90,80)],"implementation_attempts":2}
    calls=[]
    def run(name,command):
        calls.append(name)
        if name=="compile":
            plans=[]
            for hz,fps in ((120,40),(90,38),(80,37)):
                directory=tmp_path/f"clock-{hz}"
                directory.mkdir()
                plans.append({"clock_hz":hz,"scheduled_fps":fps,"solver_verified":True,"directory":str(directory)})
            (tmp_path/"clock-plans.json").write_text(json.dumps({"clock_plans":plans}))
        else:
            location=Path(command[command.index("--build")+1])
            resolved=json.loads((location/"verification-job.json").read_text())
            hz=int(location.name.split("-")[-1])
            assert resolved["clock_rtl"]==f"clock-{hz}.sv"
            assert "clock_candidates" not in resolved
            result=location/"result"
            result.mkdir()
            data={"reported_fmax":{"core":{"achieved":100/1e6}},"reported_fps":38 if hz==90 else 33,
                  "bitstream_ready":hz<=100,"performance_target_met":hz<=100}
            (result/"result.json").write_text(json.dumps(data))
            (result/"summary.txt").write_text("verified\n")
    implement_clocks(job,tmp_path,tmp_path,tmp_path/"result",1,1,run)
    report=json.loads((tmp_path/"implementation-search.json").read_text())
    assert report["selected"]["clock_hz"]==90
    assert calls==["compile","implementation-1","implementation-2"]
    assert json.loads((tmp_path/"result/result.json").read_text())["bitstream_ready"]


@pytest.mark.parametrize("search,selected_clock,attempt_count",[
    ({},100,3),({"stop_at_required_fps":False},100,3),({"stop_at_required_fps":True},90,2)])
def test_clock_search_can_improve_a_safe_result_above_the_target(tmp_path,search,selected_clock,attempt_count):
    target={"clock_hz":120,"required_fps":35,"resources":{"lut":100}}
    for name,data in (("target.json",target),("search.json",search)):
        (tmp_path/name).write_text(json.dumps(data))
    for hz in (120,100,90):
        (tmp_path/f"clock-{hz}.sv").write_text(f"clock {hz}")
    job={"target":"target.json","search":"search.json","model":"model.pt2","cache":"cache","clock_net":"core",
         "clock_candidates":[{"clock_hz":hz,"clock_rtl":f"clock-{hz}.sv"} for hz in (120,100,90)],"implementation_attempts":3}
    predictions={120:40,100:39,90:38}
    visited=[]
    def run(name,command):
        if name=="compile":
            plans=[]
            for hz,fps in predictions.items():
                directory=tmp_path/f"clock-{hz}"
                directory.mkdir()
                plans.append({"clock_hz":hz,"scheduled_fps":fps,"solver_verified":True,"directory":str(directory)})
            (tmp_path/"clock-plans.json").write_text(json.dumps({"clock_plans":plans}))
        else:
            location=Path(command[command.index("--build")+1])
            hz=int(location.name.split("-")[-1])
            visited.append(hz)
            result=location/"result"
            result.mkdir()
            safe=hz<=100
            data={"reported_fmax":{"core":{"achieved":100/1e6}},
                  "reported_fps":predictions[hz]*min(1,100/hz),
                  "bitstream_ready":safe,"performance_target_met":safe}
            (result/"result.json").write_text(json.dumps(data))
            (result/"summary.txt").write_text("verified\n")
    implement_clocks(job,tmp_path,tmp_path,tmp_path/"result",1,1,run)
    report=json.loads((tmp_path/"implementation-search.json").read_text())
    assert report["selected"]["clock_hz"]==selected_clock
    assert len(report["attempts"])==attempt_count
    assert visited==[120,90,100][:attempt_count]


def test_supplied_jobs_search_beyond_the_requested_fps():
    root=Path(__file__).resolve().parents[1]
    for filename in ("automatic-search.json","demo-fast-search.json"):
        search=json.loads((root/"inputs"/filename).read_text())
        assert search.get("stop_at_required_fps") is False
