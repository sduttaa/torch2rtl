"""Check generated LUT/RAM timing arcs for every supplied device speed grade.

Run with the toolchain Python and nextpnr himbaechel on PYTHONPATH.
The family and generator paths are required inputs.
"""
import argparse
import importlib.resources
import importlib.util
import json
from pathlib import Path
import sys

from apycula import chipdb

parser = argparse.ArgumentParser(description=__doc__)
parser.add_argument("--generator", type=Path, required=True)
parser.add_argument("--family", required=True)
parser.add_argument("--output", type=Path, required=True)
args = parser.parse_args()
spec = importlib.util.spec_from_file_location("patched", args.generator)
generator = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = generator
spec.loader.exec_module(generator)
resource = importlib.resources.files("apycula").joinpath(args.family + ".msgpack.xz")
with importlib.resources.as_file(resource) as path:
    database = chipdb.load_chipdb(path)
chip = generator.Chip("gowin", args.family, 1, 1)
generator.create_timing_info(chip, database)
strings = {value: name for name, value in chip.strs.strs.items()}
checks = []
for speed in chip.timing.speed_grades:
    cells = {strings[cell.type_variant.index]: cell for cell in speed.cell_types}
    for width in range(1, 5):
        arcs = cells[f"LUT{width}"].pin_data["F"].comb_arcs
        assert len(arcs) == width
        for arc in arcs:
            index = int(strings[arc.from_pin.index][1:])
            baseline = cells["LUT4"].pin_data["F"].comb_arcs[index]
            assert arc.from_pin.index == baseline.from_pin.index
            assert vars(arc.delay) == vars(baseline.delay)
    ram = cells["RAM16SDP4"]
    assert all(len(ram.pin_data[f"DI[{bit}]"].reg_arcs) == 1 for bit in range(4))
    assert all(f"DI[{bit}" not in ram.pin_data for bit in range(4))
    expected = [int(value * 1000) for value in
                database.timing[strings[speed.name.index]]["bram"]["clkb_dob_bypass"]]
    for name in ("DP", "DPX9", "DPB", "DPX9B"):
        cell = cells[name]
        width = 36
        for bit in range(width):
            pin = cell.pin_data[f"DOB{bit}"]
            assert len(pin.reg_arcs) == 1
            arc = pin.reg_arcs[0]
            assert strings[arc.clock.index] == "CLKB"
            assert arc.clk_q.fast_min == min(expected)
            assert arc.clk_q.slow_max == max(expected)
            assert f"DO{bit}" not in cell.pin_data
    for name, clock, delay_key in (("SP", "CLK", "clk_do_bypass"),
                                    ("SPX9", "CLK", "clk_do_bypass"),
                                    ("SDP", "CLKB", "clkb_do_bypass"),
                                    ("SDPX9", "CLKB", "clkb_do_bypass"),
                                    ("SDPB", "CLKB", "clkb_do_bypass"),
                                    ("SDPX9B", "CLKB", "clkb_do_bypass")):
        expected = [int(value * 1000) for value in
                    database.timing[strings[speed.name.index]]["bram"][delay_key]]
        for bit in range(36):
            arc = cells[name].pin_data[f"DO{bit}"].reg_arcs[0]
            assert strings[arc.clock.index] == clock
            assert arc.clk_q.fast_min == min(expected)
            assert arc.clk_q.slow_max == max(expected)
    for name in ("SP", "SPX9"):
        for pin in [*(f"ADB{bit}" for bit in range(14)),
                    *(f"BLKSELB{bit}" for bit in range(3)), "CEB", "OCEB", "WREB", "RESETB"]:
            arcs = cells[name].pin_data[pin].reg_arcs
            assert len(arcs) == 1 and strings[arcs[0].clock.index] == "CLKB"
    checks.append({"speed": strings[speed.name.index], "lut_variants_verified": 4,
                   "ram_data_input_arcs_verified": 4, "bram_b_output_variants_verified": 4,
                   "normalized_bram_width_verified": 36, "wide_sp_b_port_variants_verified": 2})
args.output.write_text(json.dumps({"passed": True, "checks": checks}, indent=2) + "\n")
print("timing regression passed", len(checks), "speed grades")
