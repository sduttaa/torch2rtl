"""Conservative mandatory Gowin LUT sites, before physical placement."""

from collections import Counter
import hashlib
import json
from pathlib import Path
import subprocess
from functools import lru_cache


@lru_cache(maxsize=8)
def tool_identity(executable,chipdb):
    return {"version":subprocess.check_output([executable,"--version"],text=True,stderr=subprocess.STDOUT).strip(),
            "chipdb_sha256":hashlib.sha256(Path(chipdb).read_bytes()).hexdigest() if chipdb else None}


def characterize(source,directory,target,resources):
    """Run the inexpensive packer: carry padding and RAM blockers consume sites."""
    config=target["place_route"]
    directory=Path(directory)
    command=[config["executable"],"--device",config["device"],"--vopt","family="+config["family"],
             "--json",str(Path(source).resolve()),"--pack-only","--write","packed.json","--report","packing.json"]
    # Isolated actor ports are internal network wires, not board pin requests.
    # Give their temporary pads distinct device sites solely for pack-only
    # accounting. These assignments are never used to place or route a design.
    (directory/"actor-ports.py").write_text(
        'sites=iter(sorted(b for b in ctx.getBels() if ctx.getBelType(b) == "IOB"))\n'
        'for name,cell in sorted((name,cell) for name,cell in ctx.cells):\n'
        '    if cell.type in ("IBUF","OBUF"):\n'
        '        cell.setAttr("BEL",next(sites))\n')
    command += ["--pre-pack",str((directory/"actor-ports.py").resolve())]
    if config.get("chipdb"):
        command += ["--chipdb",str(Path(config["chipdb"]).resolve())]
    with (directory/"packing.log").open("w") as log:
        subprocess.run(command,cwd=directory,stdout=log,stderr=subprocess.STDOUT,check=True,timeout=60)
    usage=json.loads((directory/"packing.json").read_text())["utilization"]
    unpaired,duplicates=additional_luts(json.loads((directory/"packed.json").read_text()))
    lut=usage["LUT4"]["used"]
    return {**resources,"lut":lut,"ff":usage["DFF"]["used"],
            "lut_sites":lut+sum(unpaired.values())+duplicates}


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
