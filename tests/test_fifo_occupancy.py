from types import SimpleNamespace

from torch2rtl.schedule import Fifo, fifo_occupancy


def test_occupancy_counts_values_carried_across_multiple_inferences():
    fifo=Fifo(("write_a","write_b"),("read_a","read_b"),"queue",{"selected":3},replacement_delay=1)
    problem=SimpleNamespace(fifos=(fifo,))
    solution=SimpleNamespace(period=4,selected={"queue":"selected"},
        offsets={"write_a":0,"write_b":2,"read_a":5,"read_b":7})
    assert fifo_occupancy(problem,solution) == {"queue":{
        "depth":3,"peak_live_words":3,"mean_live_words":2.5}}
