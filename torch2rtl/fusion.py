"""Exact spatial views feeding a convolution, with compact source-row storage."""

from dataclasses import dataclass
from math import ceil
from pathlib import Path
from functools import lru_cache

import torch

from .graph import Value, references, replace
from .ranges import bounds, storage_bits


@dataclass(frozen=True)
class View:
    tensor: object
    rows: tuple
    columns: tuple
    multipliers: tuple
    offset: int
    shift: int
    low: int
    high: int


def indices(value):
    """Retain ATen's distinction between explicit sizes and scale factors."""
    data, size, scale, mode, align, recompute, antialias = value.args
    if mode not in ("nearest", "nearest-exact") or align is not None or antialias:
        raise ValueError("Spatial view fusion requires exact nearest coordinate maps")
    result = []
    for axis, length in enumerate(data.tensor.shape[2:]):
        coordinates = torch.arange(length, dtype=torch.float64).reshape(1, 1, length)
        mapped = torch.nn.functional.interpolate(coordinates,
            size=None if size is None else (size[axis],),
            scale_factor=None if scale is None else (scale[axis],),
            mode=mode, recompute_scale_factor=recompute).to(torch.int64).flatten().tolist()
        if len(mapped) != value.tensor.shape[axis+2] or mapped != sorted(mapped):
            raise ValueError("Spatial view map disagrees with its static shape")
        result.append(tuple(mapped))
    return tuple(result)


def fuse(graph, lanes):
    users = {value: 0 for value in graph.values}
    for value in graph.values:
        for source in references(value.args):
            users[source] += 1
    replacements = {}
    for value in graph.values:
        if value.operation != "quantized_convolution":
            continue
        join = value.args[0]
        if join.operation != "quantized_concat" or users[join] != 1:
            continue
        inputs, multipliers, offset, shift, low, high = join.args
        # One word belongs to one source. Unsupported ragged vector boundaries
        # keep the existing actors; scalar lanes always satisfy this condition.
        if any(source.tensor.shape[1] % lanes for source in inputs[:-1]):
            continue
        sources, rows, columns = [], [], []
        resized = False
        for source in inputs:
            if source.operation == "__interpolate.size_list_scale_list" and users[source] == 1:
                try:
                    row, column = indices(source)
                except ValueError:
                    break
                source = source.args[0]
                resized = True
            else:
                row, column = (tuple(range(length)) for length in source.tensor.shape[2:])
            sources.append(source)
            rows.append(row)
            columns.append(column)
        if len(sources) != len(inputs) or not resized:
            continue
        view = View(join.tensor, tuple(rows), tuple(columns), multipliers, offset, shift, low, high)
        replacements[value] = Value(value.name, "quantized_view_convolution",
                                   (tuple(sources), view, *value.args[1:]), value.tensor)
    return replace(graph, replacements)


def materialized(value):
    sources, view, *tail = value.args
    join = Value(value.name+"_view", "quantized_concat",
                 (sources, view.multipliers, view.offset, view.shift, view.low, view.high), view.tensor)
    return Value(value.name, "quantized_convolution", (join, *tail), value.tensor)


def evaluate_view(inputs, view):
    pieces = []
    for data, rows, columns, coefficients in zip(inputs, view.rows, view.columns, view.multipliers):
        expanded = data.index_select(2, torch.tensor(rows)).index_select(3, torch.tensor(columns))
        pieces.append(expanded.to(torch.int64)*torch.as_tensor(coefficients)[None, :, None, None])
    result = ((torch.cat(pieces, dim=1)+view.offset) >> view.shift).clamp(view.low, view.high)
    return result.to(torch.int8 if view.tensor.signed else torch.uint8)


@lru_cache(maxsize=128)
def branch_tables(value,port):
    from .convolution import signed_bits
    sources,view=value.args[:2]
    source=sources[port]
    raw=torch.arange(256,dtype=torch.int64)
    if source.tensor.signed:
        raw=torch.where(raw<128,raw,raw-256)
    tables=[]
    indices=[]
    lower,upper=bounds(source)
    reachable=[index & 255 for index in range(lower,upper+1)]
    outputs=[]
    for coefficient in view.multipliers[port]:
        table=tuple(int(item) for item in ((raw*int(coefficient)+view.offset) >> view.shift).clamp(view.low,view.high))
        outputs.extend(table[index] for index in reachable)
        if table not in tables:
            tables.append(table)
        indices.append(tables.index(table))
    bits=signed_bits(min(outputs),max(outputs)) if view.tensor.signed else max(1,max(outputs).bit_length())
    return bits,tuple(indices),tuple(tuple(item & ((1 << bits)-1) for item in table) for table in tables)


def geometry(value, lanes, extra_rows=0):
    """Storage and exact row lifetimes shared by RTL, costs, and scheduling."""
    if type(extra_rows) is not int or extra_rows < 0:
        raise ValueError("Extra source rows must be a nonnegative integer")
    sources, view = value.args[:2]
    conv = materialized(value)
    _, weight, _, stride, padding, dilation, *_ = conv.args
    oh, ow = value.tensor.shape[2:]
    kh, kw = weight.shape[2:]
    if any(source.tensor.shape[1] % lanes for source in sources[:-1]):
        raise ValueError("Fused view source boundaries must align with stream lanes")
    result = []
    for port,(source, rows, columns) in enumerate(zip(sources, view.rows, view.columns)):
        channel_words = ceil(source.tensor.shape[1]/lanes)
        row_words = source.tensor.shape[3]*channel_words
        row_map = [rows[y] if 0 <= y < len(rows) else -1
                   for out in range(oh) for tap in range(kh)
                   for y in (out*stride[0]-padding[0]+tap*dilation[0],)]
        column_map = [columns[x] if 0 <= x < len(columns) else -1
                      for out in range(ow) for tap in range(kw)
                      for x in (out*stride[1]-padding[1]+tap*dilation[1],)]
        first, required_rows, spans = [], [], []
        valid_rows=[]
        for y in range(oh):
            used = [row for row in row_map[y*kh:(y+1)*kh] if row >= 0]
            # Empty padded rows retain the earliest row of any future window.
            future = [row for row in row_map[y*kh:] if row >= 0]
            first.append(min(future) if future else source.tensor.shape[2])
            required_rows.append(max(used)*row_words if used else 0)
            valid_rows.append(bool(used))
            spans.append(max(used)-min(used)+1 if used else 1)
        count = min(source.tensor.shape[2], max(spans)+extra_rows)
        output_bits=branch_tables(value,port)[0]
        bits=min(output_bits,storage_bits(source))
        required_columns=[]
        valid_columns=[]
        for x in range(ow):
            used=[column for column in column_map[x*kw:(x+1)*kw] if column >= 0]
            required_columns.append((max(used)+1)*channel_words if used else 0)
            valid_columns.append(bool(used))
        result.append({"rows": count, "row_words": row_words,"bits":bits,
            "output_bits":output_bits,"quantize_on_read":bits < output_bits,
            "width": min(lanes, source.tensor.shape[1])*bits,
            "depth": count*row_words, "words": source.tensor.shape[2]*row_words,
            "row_map": row_map, "column_map": column_map, "first": first,
            "required_rows":required_rows,"required_columns":required_columns,
            "valid_rows":valid_rows,"valid_columns":valid_columns,
            "limits": [min(source.tensor.shape[2], row+count)*row_words for row in first]})
    return result


def affine_table(values,valid):
    """Factor exact power-of-two-period affine tables; ignore masked entries."""
    for shift in range(5):
        period=1 << shift
        if period*2 > len(values):
            break
        differences={values[i]-values[i-period] for i in range(period,len(values))
                     if valid[i] and valid[i-period]}
        if len(differences) != 1:
            continue
        step=next(iter(differences))
        bases=[None]*period
        for i,(value,included) in enumerate(zip(values,valid)):
            if included:
                base=value-(i >> shift)*step
                if bases[i%period] not in (None,base):
                    break
                bases[i%period]=base
        else:
            return shift,step,tuple(base or 0 for base in bases)
    return None


def emit(value, lanes, outputs, memories, reduction_lanes):
    from .convolution import configuration, packed
    sources, view = value.args[:2]
    if memories.get("weight","auto") not in ("auto","block","distributed","logic") or memories.get("line","auto") not in ("auto","block","distributed"):
        raise ValueError("Unknown fused memory mapping option")
    conv = materialized(value)
    parameters = configuration(conv, lanes, outputs, reduction_lanes)
    parameters["EXTERNAL_WINDOW"] = 1
    parameters["WEIGHT_MEMORY"] = '"'+memories.get("weight", "auto")+'"'
    if "weight_block_depth" in memories:
        if memories.get("weight","auto") not in ("auto","block"):
            raise ValueError("A block ROM prefix requires block weight memory")
        depth=parameters["GROUPS"]*ceil((parameters["OUTPUT_CHANNELS"]//parameters["GROUPS"])/outputs)*parameters["KERNEL_H"]*parameters["KERNEL_W"]*ceil((parameters["INPUT_CHANNELS"]//parameters["GROUPS"])/parameters["REDUCTION_LANES"])
        prefix=memories["weight_block_depth"]
        if type(prefix) is not int or not 0 < prefix <= depth:
            raise ValueError("Weight block prefix must be within the ROM")
        parameters["WEIGHT_BLOCK_DEPTH"]=prefix
    ports = len(sources)
    bits = lanes*8
    window_words = parameters["KERNEL_H"]*parameters["KERNEL_W"]*ceil(view.tensor.shape[1]/lanes)
    address_bits = max(1, (window_words-1).bit_length())
    oh, ow = value.tensor.shape[2:]
    lines = [f"""module inference (
input wire clk, rst,
input wire [{ports*bits-1}:0] in_data,
input wire [{ports-1}:0] in_valid, output wire [{ports-1}:0] in_ready,
output wire [{bits-1}:0] out_data, output wire out_valid, input wire out_ready);
wire available, release_window, select_alternate, active_dot;
wire [{address_bits-1}:0] window_address, alternate_address, first_address;
wire [{bits-1}:0] window_data;
wire [{ports-1}:0] ready, finished;
reg done;
reg [{max(1,(oh-1).bit_length())-1}:0] output_row;
reg [{max(1,(ow-1).bit_length())-1}:0] output_column;
wire advance_frame = done && (&finished);
assign available = !rst && !done && (&ready);
always @(posedge clk) begin
  if (rst || advance_frame) begin output_row <= 0; output_column <= 0; done <= 0; end
  else if (release_window) begin
    if (output_column == {ow-1}) begin
      output_column <= 0;
      if (output_row == {oh-1}) done <= 1;
      else output_row <= output_row + 1'b1;
    end else output_column <= output_column + 1'b1;
  end
end
wire [{ports*bits-1}:0] branch_data;
"""]
    word_offset = 0
    geo = geometry(value, lanes, memories.get("extra_rows", 0))
    for port, (source, g, coefficients) in enumerate(zip(sources, geo, view.multipliers)):
        channels = source.tensor.shape[1]
        source_words = ceil(channels/lanes)
        source_bits=storage_bits(source)
        lines.append(f"wire [{bits-1}:0] bounded_input_{port};")
        for lane in range(lanes):
            item=f"in_data[{port*bits+lane*8} +: {source_bits}]"
            if source.tensor.signed:
                item='$signed('+item+')'
            lines.append(f"assign bounded_input_{port}[{lane*8} +: 8] = "+
                         (f"8'({item});" if lane < channels else "8'd0;"))
        branch_bits,table_indices,tables=branch_tables(value,port)
        row_addresses = [(row % g["rows"])*g["row_words"] if row >= 0 else 0 for row in g["row_map"]]
        column_addresses = [column*source_words if column >= 0 else 0 for column in g["column_map"]]
        address_bits=max(1,(g["depth"]-1).bit_length())
        compressed=[affine_table(column_addresses[tap::parameters["KERNEL_W"]],
                                [column >= 0 for column in g["column_map"][tap::parameters["KERNEL_W"]]])
                    for tap in range(parameters["KERNEL_W"])]
        params = {"OUTPUT_HEIGHT": oh, "OUTPUT_WIDTH": ow, "KERNEL_H": parameters["KERNEL_H"],
            "KERNEL_W": parameters["KERNEL_W"], "LANES": lanes, "BITS": g["bits"],
            "OUTPUT_BITS":branch_bits,"QUANTIZE_ON_READ":int(g["quantize_on_read"]),
            "SOURCE_SIGNED":int(source.tensor.signed),
            "CHANNELS": channels, "TOTAL_CHANNEL_WORDS": ceil(view.tensor.shape[1]/lanes),
            "WORD_OFFSET": word_offset, "WORDS": g["words"], "DEPTH": g["depth"],
            "MEMORY_STYLE": '"'+memories.get("line", "auto")+'"',
            "ROW_ADDRESSES": packed(row_addresses, max(1,(g["depth"]-1).bit_length())),
            "COLUMN_ADDRESSES": packed(column_addresses, max(1,(g["depth"]-1).bit_length())),
            "COLUMN_AFFINE":packed([item is not None for item in compressed],1),
            "COLUMN_SHIFTS":packed([item[0] if item else 0 for item in compressed],3),
            "COLUMN_STEPS":packed([item[1] if item else 0 for item in compressed],address_bits),
            "COLUMN_BASES":packed([base for item in compressed for base in
                                   ((list(item[2])+[0]*16)[:16] if item else [0]*16)],address_bits),
            "ROW_VALID": packed([row >= 0 for row in g["row_map"]],1),
            "COLUMN_VALID": packed([column >= 0 for column in g["column_map"]],1),
            "REQUIRED_ROWS": packed(g["required_rows"],max(1,g["words"].bit_length())),
            "VALID_ROWS": packed(g["valid_rows"],1),
            "LIMITS": packed(g["limits"],max(1,g["words"].bit_length())),
            "TABLE_COUNT":len(tables),"CHANNEL_TABLES":packed(table_indices,max(1,(len(tables)-1).bit_length())),
            "TABLES": packed([item for table in tables for item in table], branch_bits)}
        assignments = ', '.join(f'.{key}({item})' for key,item in params.items())
        lines.append(f"""wire [{lanes*branch_bits-1}:0] stored_{port};
view_rows #({assignments}) rows_{port} (
.clk(clk), .rst(rst), .advance_frame(advance_frame), .done(done), .release_window(release_window),
.output_row(output_row), .output_column(output_column),
.in_data(bounded_input_{port}), .in_valid(in_valid[{port}]), .in_ready(in_ready[{port}]),
.ready(ready[{port}]), .finished(finished[{port}]),
.window_address(window_address), .alternate_address(alternate_address), .first_address(first_address),
.select_alternate(select_alternate), .active_dot(active_dot),
.window_data(stored_{port}));""")
        for lane in range(lanes):
            item = f"stored_{port}[{lane*branch_bits} +: {branch_bits}]"
            if view.tensor.signed:
                item = '$signed('+item+')'
            lines.append(f"assign branch_data[{port*bits+lane*8} +: 8] = 8'({item});")
        word_offset += source_words
    lines.append("assign window_data = " + ' | '.join(f'branch_data[{port*bits} +: {bits}]' for port in range(ports))+';')
    assignments = ', '.join(f'.{key}({item})' for key,item in parameters.items())
    lines.append(f"""integer_convolution #({assignments}) actor (
.clk(clk), .rst(rst), .in_data({bits}'(0)), .in_valid(1'b0), .in_ready(),
.out_data(out_data), .out_valid(out_valid), .out_ready(out_ready),
.external_available(available), .external_data(window_data), .external_release(release_window),
.external_address(window_address), .external_alternate(alternate_address), .external_first(first_address),
.external_select(select_alternate), .external_active(active_dot));
endmodule""")
    root = Path(__file__).parent/'templates'
    return '\n'.join(lines) + '\n' + ''.join((root/name).read_text() for name in ('convolution.sv','window.sv','view.sv'))
