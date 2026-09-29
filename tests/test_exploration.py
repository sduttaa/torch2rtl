from types import SimpleNamespace

from torch2rtl.exploration import refine


def test_refinement_is_globally_bounded_and_preserves_incumbent():
    def option(period,lut,measured=False):
        spec={"period_bound":period,"resources":{"lut":lut}}
        if measured:
            spec["measurement"]={"cache_hit":True}
        return spec
    measured={"actor_options":{name:{"old":option(period,10,True)} for name,period in (("fast",20),("slow",100))}}
    proposed={"actor_options":{name:{**options,"new":option(10,5),"other":option(30,8)}
                               for name,options in measured["actor_options"].items()}}
    incumbent=SimpleNamespace(period=100,selected={"actor:fast":"old","actor:slow":"old"},resources={"lut":20})
    proposal=SimpleNamespace(selected={"actor:fast":"new","actor:slow":"new"})
    result=refine(measured,proposed,incumbent,proposal,{"resources":{"lut":25}},1,3)
    assert set(result["actor_options"]["slow"])=={"old","new"}
    assert set(result["actor_options"]["fast"])=={"old"}
    assert all("new" not in options for options in measured["actor_options"].values())
