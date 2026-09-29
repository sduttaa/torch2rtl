"""Emit a folded integer convolution actor from a semantic graph node."""

from math import ceil
from pathlib import Path

import numpy as np

from .ranges import bounds, monotone_requantization, storage_bits


def signed_bits(low, high):
    return max(1, max(-int(low)-1, int(high), 0).bit_length() + 1)


def packed(values, bits):
    result = 0
    for index, value in enumerate(values):
        result |= (int(value) & ((1 << bits)-1)) << (index*bits)
    width = max(1, len(values)*bits)
    return f"{width}'h{result:x}"


def threshold_table(coefficients, offset, shift, low, high, accumulator_bits):
    """Exact inverse thresholds for a small monotone integer quantizer.

    Bounds include every INT32 value, so intermediate overflow cannot turn a
    monotone threshold into a different wrapped multiply/add result.
    """
    if not (0 <= shift < 64 and 0 <= high-low < 16):
        return None
    if any(int(coefficient) < 0 or
           not -(1 << 63) <= -(1 << 31)*int(coefficient)+int(offset) <=
           ((1 << 31)-1)*int(coefficient)+int(offset) < 1 << 63
           for coefficient in coefficients):
        return None
    bits=max(1,(high-low).bit_length())
    minimum=-(1 << (accumulator_bits-1))
    maximum=(1 << (accumulator_bits-1))-1
    result=[]
    for coefficient in coefficients:
        coefficient=int(coefficient)
        for index in range(1 << bits):
            if index > high-low:
                threshold=maximum+1
            elif coefficient == 0:
                threshold=minimum if (offset >> shift) >= low+index else maximum+1
            else:
                numerator=((low+index) << shift)-offset
                threshold=-((-numerator)//coefficient)
            result.append(min(maximum+1,max(minimum,threshold)))
    return bits,result


def configuration(actor, lanes, outputs, reduction_lanes=None, requantization="auto"):
    reduction_lanes = lanes if reduction_lanes is None else reduction_lanes
    if actor.operation not in ("quantized_convolution", "quantized_convolution_pool"):
        raise ValueError("A fused quantized convolution is required")
    data, weight, bias, stride, padding, dilation, groups, multiplier, offset, shift, low, high = actor.args[:12]
    pool = actor.args[12] if actor.operation == "quantized_convolution_pool" else (1, 1)
    if len(pool) != 2 or min(pool) < 1:
        raise ValueError("Invalid fused pool geometry")
    if actor.operation == "quantized_convolution_pool" and not monotone_requantization(actor):
        raise ValueError("Fused pooling requires provably monotone requantization")
    if data.tensor.bits != 8 or actor.tensor.bits != 8:
        raise ValueError("The convolution actor currently uses 8-bit input/output elements")
    if len(data.tensor.shape) != 4 or data.tensor.shape[0] != 1:
        raise ValueError("Convolution actors require static batch-one NCHW tensors")
    if lanes < 1 or outputs < 1 or min(stride + dilation) < 1 or min(padding) < 0:
        raise ValueError("Invalid convolution geometry or parallelism")
    if reduction_lanes < 1 or lanes % reduction_lanes:
        raise ValueError("Reduction parallelism must divide the stream vector width")
    batch, ci, height, width = data.tensor.shape
    co, per_group, kh, kw = weight.shape
    if groups < 1 or ci % groups or co % groups or per_group != ci // groups:
        raise ValueError("Inconsistent convolution groups")
    if groups > 1 and per_group % lanes:
        raise ValueError("Grouped convolution channel boundaries must align with the selected vector width")
    if outputs > co // groups:
        raise ValueError("Output lanes exceed the channels in a convolution group")
    if weight.min() < -128 or weight.max() > 127:
        raise ValueError("The convolution actor requires exactly representable signed 8-bit weights")
    expected = (batch, co, *((((size+2*pad-(kernel-1)*dil-1)//step+1)//extent)
                             for size, pad, kernel, dil, step, extent in zip((height, width), padding, (kh, kw), dilation, stride, pool)))
    if actor.tensor.shape != expected:
        raise ValueError("Convolution result shape disagrees with its geometry")
    tiles = ceil((co // groups) / outputs)
    weight_bits = signed_bits(weight.min(), weight.max())
    channel_words = ceil(per_group / reduction_lanes)
    weights, biases, multipliers = [], [], []
    for group in range(groups):
        for tile in range(tiles):
            channels = [group*(co//groups) + tile*outputs + lane for lane in range(outputs)]
            active = [tile*outputs + lane < co//groups for lane in range(outputs)]
            biases.extend(int(bias[channel]) if valid else 0 for channel, valid in zip(channels, active))
            multipliers.extend(int(multiplier[channel]) if valid else 0 for channel, valid in zip(channels, active))
            for y in range(kh):
                for x in range(kw):
                    for word in range(channel_words):
                        for channel, valid in zip(channels, active):
                            for lane in range(reduction_lanes):
                                input_channel = word*reduction_lanes + lane
                                weights.append(int(weight[channel, input_channel, y, x])
                                               if valid and input_channel < per_group else 0)
    input_low, input_high = bounds(data)
    # A padded convolution also consumes zero, even when the source is known
    # to be strictly positive or negative.
    input_low, input_high = min(input_low, 0), max(input_high, 0)
    positive = np.maximum(weight.astype(np.int64), 0).sum(axis=(1, 2, 3))
    negative = np.minimum(weight.astype(np.int64), 0).sum(axis=(1, 2, 3))
    minimum = positive*input_low + negative*input_high + bias
    maximum = positive*input_high + negative*input_low + bias
    accumulator_bits = min(32, signed_bits(minimum.min(), maximum.max()))
    accumulator_bytes = ceil(accumulator_bits / 8)
    multiplier_signed = int(min(multipliers) < 0)
    multiplier_bits = (signed_bits(min(multipliers), max(multipliers)) if multiplier_signed
                       else max(1, max(multipliers).bit_length()))
    multiplier_bytes = ceil(multiplier_bits / 8)
    padded_multiplier_bits = ceil(multiplier_bytes / reduction_lanes) * reduction_lanes * 8
    encoded_multipliers = [value & ((1 << (multiplier_bytes*8))-1) for value in multipliers]
    active_products = np.any(np.array(weights).reshape(-1, outputs, reduction_lanes) != 0, axis=0)
    thresholds=threshold_table(multipliers,offset,shift,low,high,accumulator_bits)
    shift_add=requantization in ("overlap_shift_add","overlap_folded")
    if requantization not in ("auto","multiply","threshold","overlap","overlap_shift_add","overlap_folded"):
        raise ValueError("Unknown requantization implementation")
    if requantization in ("threshold","overlap") and thresholds is None:
        raise ValueError("Threshold requantization requires a small monotone integer output range")
    if requantization == "multiply" or shift_add or (requantization == "auto" and thresholds is not None and
            thresholds[0]+1 > accumulator_bytes*ceil(multiplier_bytes/reduction_lanes)+3):
        thresholds=None
    # A dot-product lane needs a requantizer mux only if some coefficient uses it.
    requant_products = np.zeros_like(active_products)
    for index, coefficient in enumerate(encoded_multipliers):
        for byte in range(multiplier_bytes):
            if (coefficient >> (byte*8)) & 255:
                requant_products[index % outputs, byte % reduction_lanes] = True
    if thresholds is None and not shift_add:
        active_products |= requant_products
    else:
        requant_products[:]=False
    # Bound the final mathematical result before narrowing. If INT32 may wrap,
    # use its full range; if INT64 may wrap, retain all 64 bits. Intermediate
    # Horner additions may use modular arithmetic at the selected result width.
    products = []
    for lower, upper, coefficient in zip(minimum, maximum, multiplier):
        lower, upper, coefficient = int(lower), int(upper), int(coefficient)
        if lower < -(1 << 31) or upper >= 1 << 31:
            lower, upper = -(1 << 31), (1 << 31)-1
        products.extend((lower*coefficient + offset, upper*coefficient + offset))
    requant_bits = min(64, signed_bits(min(products), max(products)))
    byte_products = [byte*coefficient for byte in (-128, 255) for coefficient in multipliers]
    inner_bits = min(64, signed_bits(min(byte_products), max(byte_products)))
    parameters = {"HEIGHT": height, "WIDTH": width, "INPUT_CHANNELS": ci, "OUTPUT_CHANNELS": co,
                  "POOL_H": pool[0], "POOL_W": pool[1],
                  "KERNEL_H": kh, "KERNEL_W": kw, "STRIDE_H": stride[0], "STRIDE_W": stride[1],
                  "DILATION_H": dilation[0], "DILATION_W": dilation[1], "PAD_H": padding[0], "PAD_W": padding[1],
                  "GROUPS": groups, "LANES": lanes, "OUTPUT_LANES": outputs, "INPUT_SIGNED": int(data.tensor.signed),
                  "INPUT_BITS": storage_bits(data), "OUTPUT_ELEMENT_BITS": storage_bits(actor),
                  "WEIGHT_BITS": weight_bits,
                  "OUTPUT_SIGNED": int(actor.tensor.signed),
                  "REDUCTION_LANES": reduction_lanes,
                  "ACCUMULATOR_BYTES": accumulator_bytes, "MULTIPLIER_BYTES": multiplier_bytes,
                  "MULTIPLIER_BITS": multiplier_bits,
                  "ACCUMULATOR_BITS": accumulator_bits, "INNER_BITS": max(inner_bits, 9),
                  "MULTIPLIER_SIGNED": multiplier_signed, "REQUANT_BITS": max(requant_bits, 9),
                  "SHIFT": shift, "OFFSET": packed([offset], 64), "LOW": packed([low], 64), "HIGH": packed([high], 64),
                  "WEIGHTS": packed(weights, weight_bits), "BIASES": packed(biases, 32),
                  "MULTIPLIERS": packed(encoded_multipliers, padded_multiplier_bits),
                  "PRODUCT_MASK": packed(active_products.flatten().tolist(), 1),
                  "REQUANT_MASK": packed(requant_products.flatten().tolist(), 1)}
    parameters["PIPELINED_POOL"]=int(pool[0]*pool[1]>1 and kh*kw*channel_words>=4)
    if thresholds is not None:
        bits,table=thresholds
        parameters.update(THRESHOLD_BITS=bits,THRESHOLDS=packed(table,accumulator_bits+2))
    if requantization == "overlap" or shift_add:
        parameters["OVERLAP_QUANTIZER"] = 1
        if requantization == "overlap_folded":
            _,compute,service,_=timing(parameters)
            quantizers=min(count for count in range(1,outputs+1)
                           if outputs%count==0 and outputs//count*service<compute)
            if quantizers==outputs:
                raise ValueError("No quantizer sharing fits this compute tile")
            parameters["QUANTIZER_LANES"]=quantizers
        timing(parameters)
    return parameters


def timing(parameters):
    """Cycle constants shared by the geometry screen and event contract."""
    p=parameters
    blocks=p["GROUPS"]*ceil((p["OUTPUT_CHANNELS"]//p["GROUPS"])/p["OUTPUT_LANES"])
    dot=p["KERNEL_H"]*p["KERNEL_W"]*ceil((p["INPUT_CHANNELS"]//p["GROUPS"])/p["REDUCTION_LANES"])
    pool=p["POOL_H"]*p["POOL_W"]
    extra=int(p["REDUCTION_LANES"]>1)
    saved=(pool-1)*(1+extra) if p.get("PIPELINED_POOL") else 0
    release=pool*(dot+2)+(pool-1)*extra-2-saved
    if p.get("OVERLAP_QUANTIZER"):
        compute=pool*(dot+2+extra)+1+int(pool>1)-saved
        quantizer=p.get("THRESHOLD_BITS",0) or p.get("MULTIPLIER_BITS",8*p["MULTIPLIER_BYTES"])
        quantizer+=2
        quantizer*=p["OUTPUT_LANES"]//p.get("QUANTIZER_LANES",p["OUTPUT_LANES"])
        if compute<quantizer+1:
            raise ValueError("Overlapped quantization requires a compute tile at least as long as its quantizer service interval")
        return blocks,compute,quantizer,release
    quantizer=p["THRESHOLD_BITS"]+1 if p.get("THRESHOLD_BITS") else p["ACCUMULATOR_BYTES"]*ceil(p["MULTIPLIER_BYTES"]/p["REDUCTION_LANES"])+3
    return blocks,pool*(dot+2+extra)+quantizer+int(pool>1)-saved,0,release


def window_source(layout,bank_width=None):
    """Render only the selected address implementation; reuse identical RTL."""
    root=Path(__file__).parent/"templates"
    if bank_width is not None and (type(bank_width) is not int or bank_width<1 or layout not in ("ring","ring_compact","prefetch")):
        raise ValueError("Width banking requires a positive bank width and a ring window")
    if layout=="prefetch":
        return (root/"window_prefetch.sv").read_text().replace("@BANK_WIDTH@",str(bank_width or "STORAGE_BITS"))+(root/"window_storage.sv").read_text()
    if layout not in ("ring","ring_compact"):
        return (root/"window.sv").read_text()
    compact=layout=="ring_compact"
    next_index="write_index == INDEX_BITS'(DEPTH-1) ? INDEX_BITS'(0) : write_index+1'b1"
    def location(offset):
        if not compact:
            return f"wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+{offset};"
        # Two additions run in parallel. The registered biased origin avoids
        # an add/compare/subtract chain on the synchronous RAM address path.
        return f"""wire [INDEX_BITS:0] wrapped = origin_bias+{{1'b0,{offset}}};
      wire [INDEX_BITS-1:0] location = wrapped[INDEX_BITS] ? origin+{offset} : wrapped[INDEX_BITS-1:0];"""
    values={
        "DEPTH":"SPAN" if compact else "1 << $clog2(SPAN)",
        "ADDRESS_STATE":("\n    reg [INDEX_BITS:0] origin_bias;\n    wire [INDEX_BITS-1:0] next_index = "+next_index+";") if compact else "",
        "RESET":("if (rst) begin write_index <= 0; origin <= 0; origin_bias <= -(INDEX_BITS+1)'(SPAN); end"
                 if compact else "if (rst) begin write_index <= 0; origin <= 0; end"),
        "NEXT_INDEX":"next_index" if compact else "DEPTH == 1 ? INDEX_BITS'(0) : write_index+1'b1",
        "ORIGIN_UPDATE":("if (pending_output) begin origin <= next_index; origin_bias <= {1'b0,next_index}-(INDEX_BITS+1)'(SPAN); end"
                         if compact else "if (pending_output) origin <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+INDEX_BITS'(1-SPAN);"),
        "PIPELINED_LOCATION":location("offset"),
        "ASYNC_LOCATION":location("coordinates[window_address]"),
    }
    source=(root/"window_ring.sv").read_text()
    for name,value in values.items():
        source=source.replace("@"+name+"@",value)
    if bank_width is not None:
        replacements={
            '(* ram_style=MEMORY_STYLE, no_rw_check *) reg [WORD_BITS-1:0] memory [0:DEPTH-1];':f'''localparam integer STORAGE_BITS=(CHANNELS<LANES ? CHANNELS : LANES)*BITS;
    wire [STORAGE_BITS-1:0] banked_data;
    wire [WORD_BITS-1:0] stored_data=WORD_BITS'(banked_data);
    wire [INDEX_BITS-1:0] read_location;
    window_storage #(.WIDTH(STORAGE_BITS), .DEPTH(DEPTH), .BANK_WIDTH({bank_width}),
      .PIPELINED_READ(PIPELINED_READ), .MEMORY_STYLE(MEMORY_STYLE)) storage (
      .clk(clk), .write_enable(!rst && commit), .write_address(write_index),
      .write_data(pending_data[STORAGE_BITS-1:0]), .read_address(read_location), .read_data(banked_data));''',
            'if (!rst && commit) memory[write_index] <= pending_data;':'',
            'reg [WORD_BITS-1:0] data, forwarded_data;':'''wire [WORD_BITS-1:0] data=stored_data;
      reg [WORD_BITS-1:0] forwarded_data;
      assign read_location=location;''',
            'data <= memory[location];':'',
            'assign window_data = memory[location];':'assign read_location=location;\n      assign window_data=stored_data;',
        }
        for before,after in replacements.items():
            if source.count(before)!=1:
                raise ValueError("Window memory rendering contract changed")
            source=source.replace(before,after)
        source+=(root/"window_storage.sv").read_text()
    return source


def emit(actor, lanes, outputs, weight_memory="auto", line_memory="auto", line_layout="parallel", reduction_lanes=None, weight_block_depth=None, requantization="auto", line_bank_width=None):
    if weight_memory not in ("auto", "block", "distributed", "logic") or line_memory not in ("auto", "block", "distributed"):
        raise ValueError("Unknown memory mapping option")
    if line_layout not in ("parallel", "packed", "ring", "ring_compact", "prefetch"):
        raise ValueError("Unknown line memory layout")
    parameters = configuration(actor, lanes, outputs, reduction_lanes, requantization)
    if weight_block_depth is not None:
        if weight_memory not in ("auto","block"):
            raise ValueError("A block ROM prefix requires block weight memory")
        depth = parameters["GROUPS"]*((parameters["OUTPUT_CHANNELS"]//parameters["GROUPS"]+outputs-1)//outputs)*parameters["KERNEL_H"]*parameters["KERNEL_W"]*((parameters["INPUT_CHANNELS"]//parameters["GROUPS"]+parameters["REDUCTION_LANES"]-1)//parameters["REDUCTION_LANES"])
        if type(weight_block_depth) is not int or not 0 < weight_block_depth <= depth:
            raise ValueError("Weight block prefix must be within the ROM")
        parameters["WEIGHT_BLOCK_DEPTH"] = weight_block_depth
    assignments = [f".{key}({value})" for key, value in parameters.items()]
    assignments += [f'.WEIGHT_MEMORY("{weight_memory}")', f'.LINE_MEMORY("{line_memory}")']
    layout={"parallel":0,"packed":1,"ring":2,"ring_compact":2,"prefetch":3}[line_layout]
    assignments.append(f'.PACKED_LINES({layout})')
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{lanes*8-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #({', '.join(assignments)}) actor (
    .external_available(1'b0), .external_data({lanes*8}'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(),
    .external_request(), .external_next_request(), .external_first_request(), .external_select(), .external_active(), .*);
endmodule
"""
    root = Path(__file__).parent / "templates"
    return wrapper + (root / "convolution.sv").read_text() + window_source(line_layout,line_bank_width)
