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


def configuration(actor, lanes, outputs, reduction_lanes=None):
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
    # A dot-product lane needs a requantizer mux only if some coefficient uses it.
    requant_products = np.zeros_like(active_products)
    for index, coefficient in enumerate(encoded_multipliers):
        for byte in range(multiplier_bytes):
            if (coefficient >> (byte*8)) & 255:
                requant_products[index % outputs, byte % reduction_lanes] = True
    active_products |= requant_products
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
                  "ACCUMULATOR_BITS": accumulator_bits, "INNER_BITS": max(inner_bits, 9),
                  "MULTIPLIER_SIGNED": multiplier_signed, "REQUANT_BITS": max(requant_bits, 9),
                  "SHIFT": shift, "OFFSET": packed([offset], 64), "LOW": packed([low], 64), "HIGH": packed([high], 64),
                  "WEIGHTS": packed(weights, weight_bits), "BIASES": packed(biases, 32),
                  "MULTIPLIERS": packed(encoded_multipliers, padded_multiplier_bits),
                  "PRODUCT_MASK": packed(active_products.flatten().tolist(), 1),
                  "REQUANT_MASK": packed(requant_products.flatten().tolist(), 1)}
    return parameters


def emit(actor, lanes, outputs, weight_memory="auto", line_memory="auto", line_layout="parallel", reduction_lanes=None, weight_block_depth=None):
    if weight_memory not in ("auto", "block", "distributed", "logic") or line_memory not in ("auto", "block", "distributed"):
        raise ValueError("Unknown memory mapping option")
    if line_layout not in ("parallel", "packed"):
        raise ValueError("Unknown line memory layout")
    parameters = configuration(actor, lanes, outputs, reduction_lanes)
    if weight_block_depth is not None:
        if weight_memory not in ("auto","block"):
            raise ValueError("A block ROM prefix requires block weight memory")
        depth = parameters["GROUPS"]*((parameters["OUTPUT_CHANNELS"]//parameters["GROUPS"]+outputs-1)//outputs)*parameters["KERNEL_H"]*parameters["KERNEL_W"]*((parameters["INPUT_CHANNELS"]//parameters["GROUPS"]+parameters["REDUCTION_LANES"]-1)//parameters["REDUCTION_LANES"])
        if type(weight_block_depth) is not int or not 0 < weight_block_depth <= depth:
            raise ValueError("Weight block prefix must be within the ROM")
        parameters["WEIGHT_BLOCK_DEPTH"] = weight_block_depth
    assignments = [f".{key}({value})" for key, value in parameters.items()]
    assignments += [f'.WEIGHT_MEMORY("{weight_memory}")', f'.LINE_MEMORY("{line_memory}")']
    assignments.append(f'.PACKED_LINES({int(line_layout == "packed")})')
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{lanes*8-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #({', '.join(assignments)}) actor (
    .external_available(1'b0), .external_data({lanes*8}'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
"""
    root = Path(__file__).parent / "templates"
    return wrapper + (root / "convolution.sv").read_text() + (root / "window.sv").read_text()
