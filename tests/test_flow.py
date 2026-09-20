import json

import pytest

from torch2rtl.flow import synthesis_command, synthesize


@pytest.mark.parametrize("flags", ["-noalu", ["-noalu; shell false"], ["-noalu\nclean"], [7]])
def test_synthesis_flags_are_options_not_commands(flags):
    with pytest.raises(ValueError, match="individual option names"):
        synthesis_command({"command": "synth_gowin", "flags": flags}, "inference")


def test_synthesis_uses_the_explicit_mapping_flag(tmp_path):
    rtl = "module inference(input [15:0] a, b, output [15:0] result); assign result = a+b; endmodule"
    target = {"synthesis": {"command": "synth_gowin", "family": "gw2a"}, "cell_costs": {"*": {"cells": 1}}}
    synthesize(rtl, tmp_path / "carry", target)
    target["synthesis"]["flags"] = ["-noalu"]
    synthesize(rtl, tmp_path / "logic", target)
    carry = json.loads((tmp_path / "carry/cells.json").read_text())
    logic = json.loads((tmp_path / "logic/cells.json").read_text())
    assert carry.get("ALU", 0) > 0
    assert logic.get("ALU", 0) == 0
