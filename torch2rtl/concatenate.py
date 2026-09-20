"""Exact byte scale alignment and channel concatenation without multipliers."""

from pathlib import Path

import torch

from .convolution import packed
from .ranges import lane_cast, storage_bits


def emit(actor, lanes):
    if actor.operation != "quantized_concat" or actor.tensor.bits != 8 or lanes < 1:
        raise ValueError("Expected byte quantized concatenation and a positive vector width")
    inputs, multipliers, offset, shift, low, high = actor.args
    tables, channels, indices = [], [], []
    for value, coefficients in zip(inputs, multipliers):
        if value.tensor.bits != 8:
            raise ValueError("Scale alignment currently requires byte inputs")
        channels.append(value.tensor.shape[1])
        raw = torch.arange(256, dtype=torch.int64)
        values = torch.where(raw < 128, raw, raw-256) if value.tensor.signed else raw
        for multiplier in coefficients:
            # INT64 multiply/add wrapping and arithmetic shift are deliberately
            # evaluated before narrowing. This is a compile-time truth table.
            mapped = ((values * int(multiplier) + offset) >> shift).clamp(low, high)
            table = tuple(int(item) & 255 for item in mapped)
            if table not in tables:
                tables.append(table)
            indices.append(tables.index(table))
    index_bits = max(1, (len(tables)-1).bit_length())
    parameters = {"INPUTS": len(inputs), "LANES": lanes, "OUTPUT_CHANNELS": sum(channels),
                  "CHANNELS": packed(channels, 32), "TABLE_COUNT": len(tables),
                  "CHANNEL_TABLES": packed(indices, index_bits),
                  "TABLES": packed([item for table in tables for item in table], 8)}
    assignments = ", ".join(f".{key}({value})" for key, value in parameters.items())
    wiring = [f"wire [{len(inputs)*lanes*8-1}:0] bounded_input;"]
    for port, value in enumerate(inputs):
        bits = storage_bits(value)
        wiring += [f"wire [{lanes*8-1}:0] input_{port} = in_data[{port*lanes*8} +: {lanes*8}];",
                   f"wire [{lanes*bits-1}:0] packed_{port}; wire [{lanes*8-1}:0] bounded_{port};",
                   lane_cast(f"input_{port}", f"packed_{port}", lanes, 8, bits),
                   lane_cast(f"packed_{port}", f"bounded_{port}", lanes, bits, 8, value.tensor.signed),
                   f"assign bounded_input[{port*lanes*8} +: {lanes*8}] = bounded_{port};"]
    wrapper = f"""
module inference (
  input wire clk, input wire rst,
  input wire [{len(inputs)*lanes*8-1}:0] in_data,
  input wire [{len(inputs)-1}:0] in_valid, output wire [{len(inputs)-1}:0] in_ready,
  output wire [{lanes*8-1}:0] out_data, output wire out_valid, input wire out_ready
);
  {chr(10).join(wiring)}
  integer_concatenate #({assignments}) actor (.in_data(bounded_input), .*);
endmodule
"""
    return wrapper + (Path(__file__).parent / "templates/concatenate.sv").read_text()
