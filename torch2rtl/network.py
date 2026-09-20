"""Connect actor RTL using explicit configurations and logical FIFO capacities.

This emitter does not choose parameters or assert resource/timing feasibility.
The same configuration interface can consume solver choices or test fixtures.
"""

from collections import defaultdict
from pathlib import Path
import re

from . import concatenate, convolution, spatial
from .graph import references
from .ranges import lane_cast, storage_bits


def edges(graph):
    return [(f"{source.name}->{value.name}:{port}", source, value, port)
            for value in graph.values if value is not graph.input
            for port, source in enumerate(references(value.args))]


def fifo_width(source, lanes):
    """Physical bits per word, omitting lanes absent from every tensor pixel."""
    return min(lanes, source.tensor.shape[1]) * storage_bits(source)


def actor_rtl(value, lanes, output_lanes=None, memories=None, reduction_lanes=None):
    memories = memories or {}
    convolution_actor = value.operation in ("quantized_convolution", "quantized_convolution_pool")
    allowed = {"weight", "line", "line_layout"} if convolution_actor else {"storage"}
    if not memories.keys() <= allowed:
        raise ValueError(f"Unknown memory mapping for {value.operation}")
    if convolution_actor:
        return convolution.emit(value, lanes, output_lanes, memories.get("weight", "auto"),
                                memories.get("line", "auto"), memories.get("line_layout", "parallel"), reduction_lanes)
    if reduction_lanes is not None:
        raise ValueError(f"No reduction parallelism for {value.operation}")
    if value.operation == "max_pool2d":
        return spatial.emit_pool(value, lanes, memories.get("storage", "auto"))
    if value.operation == "__interpolate.size_list_scale_list":
        return spatial.emit_resize(value, lanes, memories.get("storage", "auto"))
    if memories:
        raise ValueError(f"No memory mapping choices for {value.operation}")
    if value.operation == "quantized_concat":
        return concatenate.emit(value, lanes)
    if value.operation == "byte_lookup":
        parameters = {"CHANNELS": value.tensor.shape[1], "LANES": lanes,
                      "TABLE": convolution.packed(value.args[1], 8)}
        return spatial.wrapped("integer_lookup", parameters, lanes*8, ("lookup.sv",))
    raise ValueError(f"No RTL actor for {value.operation}")


def emit(graph, lanes, output_lanes, depths, memories=None, reduction_lanes=None):
    memories = memories or {}
    reduction_lanes = reduction_lanes or {}
    convolutions = {value.name for value in graph.values if value.operation in ("quantized_convolution", "quantized_convolution_pool")}
    if not reduction_lanes.keys() <= convolutions:
        raise ValueError("Reduction parallelism refers to an unknown convolution")
    if not memories.keys() <= {value.name for value in graph.values if value is not graph.input}:
        raise ValueError("Memory mapping refers to an unknown actor")
    if lanes < 1 or any(value.tensor.bits != 8 or len(value.tensor.shape) != 4 or value.tensor.shape[0] != 1
                        for value in graph.values):
        raise ValueError("The spatial network requires batch-one byte NCHW streams")
    channels = edges(graph)
    if set(depths) != {name for name, _, _, _ in channels} or any(type(depth) is not int or depth < 1 for depth in depths.values()):
        raise ValueError("Supply one positive logical FIFO depth for every graph edge")
    if set(output_lanes) != convolutions:
        raise ValueError("Supply output parallelism for every convolution")
    indices = {value: index for index, value in enumerate(graph.values)}
    outgoing, incoming = defaultdict(list), defaultdict(list)
    for edge_index, (_, source, destination, _) in enumerate(channels):
        outgoing[source].append(edge_index)
        incoming[destination].append(edge_index)
    modules = {}
    bits = lanes * 8
    top = [f"""module inference (
  input wire clk, input wire rst,
  input wire [{bits-1}:0] in_data, input wire in_valid, output wire in_ready,
  output wire [{bits-1}:0] out_data, output wire out_valid, input wire out_ready
);"""]
    for value, index in indices.items():
        top.append(f"wire [{bits-1}:0] data_{index}; wire valid_{index}, ready_{index};")
    source_index, output_index = indices[graph.input], indices[graph.output]
    top += [f"assign data_{source_index} = in_data; assign valid_{source_index} = in_valid; assign in_ready = ready_{source_index};",
            f"assign out_data = data_{output_index}; assign out_valid = valid_{output_index}; assign ready_{output_index} = out_ready;"]
    for edge_index, (name, source, _, _) in enumerate(channels):
        index = indices[source]
        element_bits = storage_bits(source)
        stored_lanes = min(lanes, source.tensor.shape[1])
        width = fifo_width(source, lanes)
        top += [f"wire [{bits-1}:0] edge_data_{edge_index}; wire edge_valid_{edge_index}, edge_ready_{edge_index}, space_{edge_index};",
                f"wire [{width-1}:0] packed_input_{edge_index}, packed_output_{edge_index};",
                lane_cast(f"data_{index}", f"packed_input_{edge_index}", stored_lanes, 8, element_bits),
                lane_cast(f"packed_output_{edge_index}", f"edge_data_{edge_index}", stored_lanes, element_bits, 8, source.tensor.signed)]
        if stored_lanes < lanes:
            top.append(f"assign edge_data_{edge_index}[{bits-1}:{stored_lanes*8}] = '0;")
        top += [f"stream_fifo #(.WIDTH({width}), .DEPTH({depths[name]})) fifo_{edge_index} (",
                f".clk(clk), .rst(rst), .in_data(packed_input_{edge_index}), .in_valid(valid_{index} && ready_{index}), .in_ready(space_{edge_index}),",
                f".out_data(packed_output_{edge_index}), .out_valid(edge_valid_{edge_index}), .out_ready(edge_ready_{edge_index}));"]
    for source, connections in outgoing.items():
        top.append(f"assign ready_{indices[source]} = " + " && ".join(f"space_{edge}" for edge in connections) + ";")
    for value, index in indices.items():
        if value is graph.input:
            continue
        rtl = actor_rtl(value, lanes, output_lanes.get(value.name), memories.get(value.name), reduction_lanes.get(value.name))
        rtl = rtl.replace("module inference (", f"module actor_{index} (", 1)
        # All sources here are compiler-owned templates, with ordinary module
        # declarations. Keep each shared template definition exactly once.
        for match in re.finditer(r"\bmodule\s+(\w+)\b.*?\bendmodule\b", rtl, flags=re.S):
            name, source = match.group(1), match.group(0)
            if name in modules and modules[name] != source:
                raise ValueError(f"Conflicting RTL template definitions: {name}")
            modules[name] = source
        connections = incoming[value]
        def port(kind):
            return "{" + ", ".join(f"edge_{kind}_{edge}" for edge in reversed(connections)) + "}"
        top += [f"actor_{index} node_{index} (.clk(clk), .rst(rst),",
                f".in_data({port('data')}), .in_valid({port('valid')}), .in_ready({port('ready')}),",
                f".out_data(data_{index}), .out_valid(valid_{index}), .out_ready(ready_{index}));"]
    top.append("endmodule")
    fifo = (Path(__file__).parent / "templates/fifo.sv").read_text()
    return "\n".join(top) + "\n" + "\n".join(modules.values()) + "\n" + fifo
