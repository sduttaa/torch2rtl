"""Reject packed designs whose mandatory LUT sites already exceed capacity.

Gowin slice legality requires an adjacent LUT F or ALU SUM to drive its FF D.
Otherwise nextpnr creates a pass-through LUT after placement. Packing statistics
omit those LUTs. This is a necessary lower bound, not a placement guarantee.
"""

import argparse
import hashlib
import json
from pathlib import Path
import sys

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from torch2rtl.packing import additional_luts




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
