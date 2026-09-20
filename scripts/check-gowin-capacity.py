"""Reject packed designs whose mandatory LUT sites already exceed capacity.

Gowin slice legality requires an adjacent LUT F or ALU SUM to drive its FF D.
Otherwise nextpnr creates a pass-through LUT after placement. Packing statistics
omit those LUTs. This is a necessary lower bound, not a placement guarantee.
"""

import argparse
from collections import Counter
import hashlib
import json
from pathlib import Path


def additional_luts(design):
    unpaired = Counter()
    duplicates = 0
    for module in design["modules"].values():
        cells = module.get("cells", {})
        drivers = {}
        for name, cell in cells.items():
            for port, bits in cell["connections"].items():
                if cell["port_directions"].get(port) == "output":
                    for bit in bits:
                        drivers[bit] = (name, port, cell["type"])
        shared = Counter()
        for cell in cells.values():
            if not cell["type"].startswith("DFF"):
                continue
            bit = cell["connections"]["D"][0]
            name, port, kind = drivers.get(bit, (None, None, "undriven_or_constant"))
            if (kind in {"LUT1", "LUT2", "LUT3", "LUT4"} and port == "F") or (kind == "ALU" and port == "SUM"):
                shared[name, port] += 1
            else:
                unpaired[kind] += 1
        # One physical LUT/ALU output can share its site with only one FF.
        duplicates += sum(max(0, count - 1) for count in shared.values())
    return dict(unpaired), duplicates


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--netlist", type=Path, required=True)
    parser.add_argument("--packing-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    args = parser.parse_args()
    data = args.netlist.read_bytes()
    unpaired, duplicates = additional_luts(json.loads(data))
    utilization = json.loads(args.packing_report.read_text())["utilization"]
    lut = utilization["LUT4"]
    required = lut["used"] + sum(unpaired.values()) + duplicates
    exceeded = {name: row for name, row in utilization.items()
                if row["available"] > 0 and row["used"] > row["available"]}
    fits = required <= lut["available"] and not exceeded
    report = {
        "netlist_sha256": hashlib.sha256(data).hexdigest(),
        "packed_luts": lut["used"], "unpaired_ff_drivers": unpaired,
        "duplicate_ff_consumers": duplicates, "lut_site_lower_bound": required,
        "lut_sites_available": lut["available"], "other_exceeded_resources": exceeded,
        "necessary_capacity_check_passes": fits, "placement_verified": False,
    }
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report), flush=True)
    if not fits:
        raise SystemExit("Mandatory physical sites exceed capacity; do not run placement")
