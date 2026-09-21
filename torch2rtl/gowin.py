"""Model-independent Gowin netlist mapping, selected by target inputs."""

from collections import defaultdict
import hashlib
import json
from pathlib import Path
import subprocess


def pack_product_registers(design):
    """Absorb exclusive, uninitialized product DFFs into multiplier outputs."""
    changes = []
    for module_name, module in design["modules"].items():
        cells = module.get("cells", {})
        users = defaultdict(list)
        initialized = {bit for net in module.get("netnames", {}).values()
                       if "init" in net.get("attributes", {}) for bit in net["bits"]}
        for name, cell in cells.items():
            for port, bits in cell["connections"].items():
                if cell["port_directions"].get(port) == "input":
                    for bit in bits:
                        users[bit].append((name, port))
        for name, port in module.get("ports", {}).items():
            if port["direction"] != "input":
                for bit in port["bits"]:
                    users[bit].append((name, "top"))
        for name, cell in list(cells.items()):
            if cell["type"] != "MULT9X9":
                continue
            if any(int(cell["parameters"].get(key, "0"), 2) for key in
                   ("AREG", "BREG", "OUT_REG", "PIPE_REG", "ASIGN_REG", "BSIGN_REG", "SOA_REG")):
                continue
            replacements, controls, registers = {}, set(), set()
            valid = True
            for bit in cell["connections"]["DOUT"]:
                for user, port in users[bit]:
                    register = cells.get(user, {})
                    if port != "D" or register.get("type") not in ("DFF", "DFFE"):
                        valid = False
                        break
                    connections = register["connections"]
                    output = connections["Q"][0]
                    if output in initialized or bit in replacements:
                        valid = False
                        break
                    controls.add((tuple(connections["CLK"]), tuple(connections.get("CE", ["1"]))))
                    replacements[bit] = output
                    registers.add(user)
                if not valid:
                    break
            if not valid or len(controls) != 1 or not registers:
                continue
            clock, enable = next(iter(controls))
            cell["parameters"]["OUT_REG"] = "1"
            cell["connections"].update(CLK=list(clock), CE=list(enable), RESET=["0"])
            cell["connections"]["DOUT"] = [replacements.get(bit, bit) for bit in cell["connections"]["DOUT"]]
            for register in registers:
                del cells[register]
            changes.append({"module": module_name, "multiplier": name,
                            "removed_registers": sorted(registers), "clock": clock,
                            "enable": enable, "replacements": replacements})
    return {"changes": changes, "multipliers": len(changes),
            "removed_registers": sum(len(change["removed_registers"]) for change in changes)}


def map_netlist(source, directory, target):
    """Apply requested whole-design mapping; retain each intermediate for proof."""
    settings = target.get("netlist_mapping", {})
    if not settings:
        return Path(source)
    if target["synthesis"]["command"] != "synth_gowin":
        raise ValueError("These netlist mappings require the Gowin family")
    directory = Path(directory)
    directory.mkdir(parents=True, exist_ok=True)
    data = Path(source).read_bytes()
    design = json.loads(data)
    report = {"input_sha256": hashlib.sha256(data).hexdigest()}
    if settings.get("pack_product_registers"):
        report.update(pack_product_registers(design))
    registered = json.dumps(design) + "\n"
    report["output_sha256"] = hashlib.sha256(registered.encode()).hexdigest()
    (directory / "registered.json").write_text(registered)
    (directory / "register-packing.json").write_text(json.dumps(report, indent=2) + "\n")
    mapping = settings.get("lut_mapping")
    if mapping is None:
        return directory / "registered.json"
    if mapping not in ("classic", "area"):
        raise ValueError("LUT mapping must be classic or area")
    tops = [name for name, module in design["modules"].items()
            if module.get("attributes", {}).get("top") in ("1", "00000000000000000000000000000001")]
    if len(tops) != 1:
        raise ValueError("Netlist must identify exactly one top module")
    (directory / "source.json").write_text(json.dumps({"modules": {tops[0]: design["modules"][tops[0]]}}))
    unmap = []
    for width in range(1, 5):
        inputs = ", ".join("I" + str(index) for index in range(width))
        selector = ", ".join("I" + str(index) for index in reversed(range(width)))
        unmap.append(f"module LUT{width}(output F, input {inputs}); "
                     f"parameter [{(1 << width)-1}:0] INIT=0; assign F=INIT[{{{selector}}}]; endmodule")
    (directory / "lut-unmap.v").write_text("\n".join(unmap) + "\n")
    (directory / "area.abc").write_text(
        "strash\n&get -n\n&fraig -x\n&put\nscorr\ndc2\ndretime\nstrash\ndch -f\nif -a\nmfs2\nlutpack -S 1\n")
    family = target["synthesis"].get("family")
    if not family or not family.isalnum():
        raise ValueError("Supply an alphanumeric Gowin synthesis family")
    script = f"""read_verilog -lib -specify +/gowin/cells_sim.v
read_verilog -lib -specify +/gowin/cells_xtra_{family}.v
read_json source.json
hierarchy -check -top {tops[0]}
techmap -map lut-unmap.v
techmap
opt_clean
abc -lut 4 {"-script area.abc" if mapping == "area" else ""}
techmap -map +/gowin/cells_map.v
opt_lut_ins -tech gowin
hilomap -singleton -hicell VCC V -locell GND G
bufnorm -conn
clean
check
blackbox =A:whitebox
write_json netlist.json
"""
    (directory / "remap.ys").write_text(script)
    with (directory / "mapping.log").open("w") as log:
        subprocess.run(["yosys", "-Q", "-T", "-s", "remap.ys"], cwd=directory,
                       stdout=log, stderr=subprocess.STDOUT, check=True,
                       timeout=settings.get("timeout_seconds"))
    return directory / "netlist.json"
