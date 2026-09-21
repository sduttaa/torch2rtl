from copy import deepcopy

import pytest

from torch2rtl.gowin import pack_product_registers


def design():
    cells = {
        "product": {"type": "MULT9X9", "parameters": {},
                    "port_directions": {"DOUT": "output", "A": "input", "B": "input"},
                    "connections": {"DOUT": [10, 11], "A": [1], "B": [2]}},
        "low": {"type": "DFFE", "port_directions": {"D": "input", "CLK": "input", "CE": "input", "Q": "output"},
                "connections": {"D": [10], "Q": [20], "CLK": [3], "CE": [4]}},
        "high": {"type": "DFFE", "port_directions": {"D": "input", "CLK": "input", "CE": "input", "Q": "output"},
                 "connections": {"D": [11], "Q": [21], "CLK": [3], "CE": [4]}},
    }
    return {"modules": {"arbitrary": {"cells": cells, "ports": {}, "netnames": {}}}}


def test_product_packing_preserves_clock_enable_and_observed_outputs():
    netlist = design()
    report = pack_product_registers(netlist)
    assert report["multipliers"] == 1 and report["removed_registers"] == 2
    cells = netlist["modules"]["arbitrary"]["cells"]
    assert set(cells) == {"product"}
    assert cells["product"]["connections"]["DOUT"] == [20, 21]
    assert cells["product"]["connections"]["CE"] == [4]
    assert cells["product"]["connections"]["CLK"] == [3]
    assert cells["product"]["parameters"]["OUT_REG"] == "1"


@pytest.mark.parametrize("reason", ["shared_product", "different_clock", "different_enable", "initialized", "already_registered"])
def test_product_packing_rejects_semantically_different_registers(reason):
    netlist = design()
    module = netlist["modules"]["arbitrary"]
    if reason == "shared_product":
        module["ports"]["observed"] = {"direction": "output", "bits": [10]}
    elif reason == "different_clock":
        module["cells"]["high"]["connections"]["CLK"] = [5]
    elif reason == "different_enable":
        module["cells"]["high"]["connections"]["CE"] = [5]
    elif reason == "initialized":
        module["netnames"]["held"] = {"bits": [20], "attributes": {"init": "0"}}
    else:
        module["cells"]["product"]["parameters"]["AREG"] = "1"
    original = deepcopy(netlist)
    assert pack_product_registers(netlist)["multipliers"] == 0
    assert netlist == original
def test_pack_cost_includes_distributed_memory_reservations(tmp_path):
    import json
    from pathlib import Path
    from collections import Counter
    from torch2rtl.flow import characterize,resource_usage
    from torch2rtl.spatial import wrapped
    target=json.loads((Path(__file__).parents[1]/"inputs/optimization-target.json").read_text())
    rtl=wrapped("stream_fifo",{"WIDTH":4,"DEPTH":17,"MEMORY_STYLE":'"distributed"'},4,("fifo.sv",))
    report=characterize(rtl,target,tmp_path/"cache")
    netlist=json.loads(Path(report["netlist_path"]).read_text())
    cells=Counter(cell["type"] for cell in netlist["modules"]["inference"]["cells"].values())
    assert cells["RAM16SDP4"] > 0
    assert report["resources"]["lut"] >= resource_usage(netlist,target)["lut"]+4*cells["RAM16SDP4"]
    assert report["resources"]["lut_sites"] >= report["resources"]["lut"]
    assert characterize(rtl,target,tmp_path/"cache")["cache_hit"]
