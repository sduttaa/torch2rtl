"""Check implemented clock connectivity and static dividers before packing."""

import math


def verify_clock(netlist,reference_hz,requested_hz,top="harness"):
    module=netlist["modules"][top]
    source=module["netnames"]["clk"]["bits"][0]
    output=module["netnames"].get("core_clock",module["netnames"].get("clock_source.clock_out",{})).get("bits",[None])[0]
    drivers={bit:(name,cell,port) for name,cell in module["cells"].items()
             for port,direction in cell["port_directions"].items() if direction=="output"
             for bit in cell["connections"][port] if isinstance(bit,int)}
    visited=set()
    evidence=[]
    def frequency(bit):
        if bit==source:
            return reference_hz
        if bit in visited or bit not in drivers:
            raise ValueError("Cannot prove the generated clock's source")
        visited.add(bit)
        name,cell,port=drivers[bit]
        kind=cell["type"]
        if kind in {"IBUF","BUFG","GBUF"} and port=="O":
            return frequency(cell["connections"]["I"][0])
        if kind!="rPLL" or port!="CLKOUT":
            raise ValueError(f"Unsupported generated clock mechanism: {kind}.{port}")
        parameters=cell["parameters"]
        for key in ("DYN_IDIV_SEL","DYN_FBDIV_SEL","CLKOUT_BYPASS"):
            if parameters.get(key,"false")!="false":
                raise ValueError("Dynamic or bypassed PLL clocks need an explicit clock verifier")
        if parameters.get("CLKFB_SEL","internal")!="internal":
            raise ValueError("Only static internal-feedback PLL clocks are supported")
        def integer(key):
            value=parameters.get(key,0)
            return int(value,2) if isinstance(value,str) else value
        reference=frequency(cell["connections"]["CLKIN"][0])
        if "FCLKIN" in parameters and not math.isclose(float(parameters["FCLKIN"])*1e6,reference,rel_tol=1e-8):
            raise ValueError("PLL input-frequency declaration differs from its reference clock")
        achieved=reference*(integer("FBDIV_SEL")+1)/(integer("IDIV_SEL")+1)
        evidence.append({"cell":name,"type":kind,"reference_hz":reference,"output_hz":achieved,
                         "input_divider":integer("IDIV_SEL")+1,"feedback_divider":integer("FBDIV_SEL")+1})
        return achieved
    implemented=frequency(output)
    if not math.isclose(implemented,requested_hz,rel_tol=1e-8):
        raise ValueError(f"Clock RTL implements {implemented:g} Hz, but the target requests {requested_hz:g} Hz")
    return {"matches":True,"reference_clock_hz":reference_hz,"implemented_clock_hz":implemented,
            "requested_clock_hz":requested_hz,"evidence":evidence,
            "scope":"Static divider and connectivity check; device operating ranges and timing are checked by the physical tools"}
