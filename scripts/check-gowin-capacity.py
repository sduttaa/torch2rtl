"""Reject packed designs whose mandatory LUT sites already exceed capacity.

Gowin slice legality requires an adjacent LUT F or ALU SUM to drive its FF D.
Otherwise nextpnr creates a pass-through LUT after placement. Packing statistics
omit those LUTs. This is a necessary lower bound, not a placement guarantee.
"""

import argparse
import hashlib
import json
from pathlib import Path
import re
import sys

sys.path.insert(0,str(Path(__file__).resolve().parents[1]))
from torch2rtl.packing import additional_luts


def routed_sites(design):
    """Count occupied slice positions, including placement-added pass LUTs.

    Gowin LUT/ALU/FF BELs with the same tile and index share one position.
    A distributed RAM reserves all eight positions, including its four
    blocker LUTs, which nextpnr removes from the final netlist.
    """
    occupied=set()
    for module in design["modules"].values():
        for cell in module.get("cells",{}).values():
            bel=cell.get("attributes",{}).get("NEXTPNR_BEL","")
            if "/" not in bel:
                raise ValueError("Routed cell has no physical BEL")
            tile,site=bel.rsplit("/",1)
            match=re.fullmatch(r"(?:LUT|ALU|DFF)(\d+)",site)
            if match:
                occupied.add((tile,int(match[1])))
            elif site=="RAM16SDP4":
                occupied.update((tile,index) for index in range(8))
    return len(occupied)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--netlist", type=Path, required=True)
    parser.add_argument("--packing-report", type=Path, required=True)
    parser.add_argument("--output", type=Path, required=True)
    parser.add_argument("--routed-netlist", type=Path)
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
    if args.routed_netlist:
        routed=args.routed_netlist.read_bytes()
        used=routed_sites(json.loads(routed))
        report.update(routed_netlist_sha256=hashlib.sha256(routed).hexdigest(),
                      routed_logic_sites=used,routed_logic_sites_free=lut["available"]-used,
                      placement_verified=True)
        fits=fits and used<=lut["available"]
        report["necessary_capacity_check_passes"]=fits
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print(json.dumps(report), flush=True)
    if not fits:
        raise SystemExit("Mandatory physical sites exceed capacity; do not run placement")
