"""Emit a folded integer convolution actor from a semantic graph node."""

from math import ceil
from pathlib import Path

import numpy as np

from .lower import integer_range


def signed_bits(low, high):
    return max(1, max(-int(low)-1, int(high), 0).bit_length() + 1)


def packed(values, bits):
    result = 0
    for index, value in enumerate(values):
        result |= (int(value) & ((1 << bits)-1)) << (index*bits)
    width = max(1, len(values)*bits)
    return f"{width}'h{result:x}"


def configuration(actor, lanes, outputs):
    if actor.operation != "quantized_convolution":
        raise ValueError("A fused quantized convolution is required")
    data, weight, bias, stride, padding, dilation, groups, multiplier, offset, shift, low, high = actor.args
    if data.tensor.bits != 8 or actor.tensor.bits != 8:
        raise ValueError("The convolution actor currently uses 8-bit input/output elements")
    if len(data.tensor.shape) != 4 or data.tensor.shape[0] != 1:
        raise ValueError("Convolution actors require static batch-one NCHW tensors")
    if lanes < 1 or outputs < 1 or min(stride + dilation) < 1 or min(padding) < 0:
        raise ValueError("Invalid convolution geometry or parallelism")
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
    expected = (batch, co, *((size+2*pad-(kernel-1)*dil-1)//step+1
                             for size, pad, kernel, dil, step in zip((height, width), padding, (kh, kw), dilation, stride)))
    if actor.tensor.shape != expected:
        raise ValueError("Convolution result shape disagrees with its geometry")
    tiles = ceil((co // groups) / outputs)
    channel_words = ceil(per_group / lanes)
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
                            for lane in range(lanes):
                                input_channel = word*lanes + lane
                                weights.append(int(weight[channel, input_channel, y, x])
                                               if valid and input_channel < per_group else 0)
    input_low, input_high = integer_range(data.tensor)
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
    padded_multiplier_bits = ceil(multiplier_bytes / lanes) * lanes * 8
    encoded_multipliers = [value & ((1 << (multiplier_bytes*8))-1) for value in multipliers]
    active_products = np.any(np.array(weights).reshape(-1, outputs, lanes) != 0, axis=0)
    for index, coefficient in enumerate(encoded_multipliers):
        for byte in range(multiplier_bytes):
            if (coefficient >> (byte*8)) & 255:
                active_products[index % outputs, byte % lanes] = True
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
                  "KERNEL_H": kh, "KERNEL_W": kw, "STRIDE_H": stride[0], "STRIDE_W": stride[1],
                  "DILATION_H": dilation[0], "DILATION_W": dilation[1], "PAD_H": padding[0], "PAD_W": padding[1],
                  "GROUPS": groups, "LANES": lanes, "OUTPUT_LANES": outputs, "INPUT_SIGNED": int(data.tensor.signed),
                  "ACCUMULATOR_BYTES": accumulator_bytes, "MULTIPLIER_BYTES": multiplier_bytes,
                  "ACCUMULATOR_BITS": accumulator_bits, "INNER_BITS": max(inner_bits, 9),
                  "MULTIPLIER_SIGNED": multiplier_signed, "REQUANT_BITS": max(requant_bits, 9),
                  "SHIFT": shift, "OFFSET": packed([offset], 64), "LOW": packed([low], 64), "HIGH": packed([high], 64),
                  "WEIGHTS": packed(weights, 8), "BIASES": packed(biases, 32),
                  "MULTIPLIERS": packed(encoded_multipliers, padded_multiplier_bits),
                  "PRODUCT_MASK": packed(active_products.flatten().tolist(), 1)}
    return parameters


def emit(actor, lanes, outputs, weight_memory="auto", line_memory="auto"):
    if weight_memory not in ("auto", "block", "distributed") or line_memory not in ("auto", "block", "distributed"):
        raise ValueError("Unknown memory mapping option")
    parameters = configuration(actor, lanes, outputs)
    assignments = [f".{key}({value})" for key, value in parameters.items()]
    assignments += [f'.WEIGHT_MEMORY("{weight_memory}")', f'.LINE_MEMORY("{line_memory}")']
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{lanes*8-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #({', '.join(assignments)}) actor (.*);
endmodule
"""
    root = Path(__file__).parent / "templates"
    return wrapper + (root / "convolution.sv").read_text() + (root / "window.sv").read_text()
