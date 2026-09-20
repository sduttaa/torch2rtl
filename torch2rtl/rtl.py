"""Parameterized elastic integer map/reduce actors with an explicit FIFO."""

from math import ceil

from .lower import Kernel


def emit(kernel: Kernel, lanes: int, depth: int):
    if lanes < 1 or depth < 1:
        raise ValueError("Lane count and FIFO depth must be positive")
    words = ceil(kernel.input.elements / lanes)
    input_bits = kernel.input.bits
    mapped_bits = kernel.mapped_type.bits
    output_bits = kernel.output.bits * (1 if kernel.reduction else lanes)
    lines = [f"""module inference (
  input wire clk, input wire rst,
  input wire [{input_bits * lanes - 1}:0] in_data,
  input wire in_valid, output wire in_ready,
  output wire [{output_bits - 1}:0] out_data,
  output wire out_valid, input wire out_ready
);
  localparam integer LANES = {lanes}, WORDS = {words}, ELEMENTS = {kernel.input.elements};
  localparam integer MAP_BITS = {mapped_bits}, DEPTH = {depth};
  localparam integer INDEX_BITS = (WORDS <= 1) ? 1 : $clog2(WORDS);
  reg [INDEX_BITS-1:0] input_index;
  wire [LANES*MAP_BITS-1:0] computed;
  wire [LANES*MAP_BITS-1:0] fifo_data;
  wire fifo_valid, fifo_ready, map_ready;
  reg [LANES*MAP_BITS-1:0] map_data;
  reg map_valid;
  assign in_ready = !map_valid || map_ready;
  always @(posedge clk) begin
    if (rst) begin
      map_valid <= 0;
      input_index <= 0;
    end else if (in_ready) begin
      map_valid <= in_valid;
      if (in_valid) begin
        map_data <= computed;
        input_index <= (input_index == INDEX_BITS'(WORDS-1)) ? '0 : input_index + 1'b1;
      end
    end
  end
  elastic_fifo #(.WIDTH(LANES*MAP_BITS), .DEPTH(DEPTH)) channel (
    .clk(clk), .rst(rst), .in_data(map_data), .in_valid(map_valid), .in_ready(map_ready),
    .out_data(fifo_data), .out_valid(fifo_valid), .out_ready(fifo_ready)
  );
  genvar lane;
  generate for (lane = 0; lane < LANES; lane = lane + 1) begin: mapping
"""]
    tensor_types = {"input_value": kernel.input}
    signed = "signed " if kernel.input.signed else ""
    lines.append(f"    wire {signed}[{input_bits-1}:0] input_value = in_data[lane*{input_bits} +: {input_bits}];")

    def operand(arg):
        if isinstance(arg, str):
            tensor = tensor_types[arg]
            signed_value = f"$signed({arg})" if tensor.signed else f"$signed({{1'b0, {arg}}})"
            return f"65'({signed_value})"
        if type(arg) is not int and type(arg) is not bool:
            raise ValueError(f"Unsupported scalar operand: {arg}")
        number = int(arg)
        width = max(65, number.bit_length() + 1)
        return f"-{width}'sd{abs(number)}" if number < 0 else f"{width}'sd{number}"

    for step in kernel.steps:
        a = operand(step.args[0])
        if step.operation == "cast":
            expression = f"({a} != 0)" if step.tensor.bits == 1 else a
        elif step.operation == "clamp":
            expression = a
            low, high = step.args[1:]
            if low is not None:
                expression = f"({a} < {operand(low)} ? {operand(low)} : {expression})"
            if high is not None:
                expression = f"({a} > {operand(high)} ? {operand(high)} : {expression})"
            if low is not None and high is not None and low > high:
                expression = operand(high)
        else:
            b = operand(step.args[1])
            alpha = step.args[2] if len(step.args) == 3 else 1
            if alpha != 1:
                b = f"({b} * {operand(alpha)})"
            symbol = {"add": "+", "sub": "-", "mul": "*"}[step.operation]
            expression = f"{a} {symbol} {b}"
        signed = "signed " if step.tensor.signed else ""
        lines.append(f"    wire {signed}[{step.tensor.bits-1}:0] {step.name} = {step.tensor.bits}'({expression});")
        tensor_types[step.name] = step.tensor
    lines += [f"    assign computed[lane*MAP_BITS +: MAP_BITS] = "
              f"(32'(input_index)*LANES + lane < ELEMENTS) ? MAP_BITS'({kernel.mapped}) : {{MAP_BITS{{1'b0}}}};",
              "  end endgenerate"]
    if kernel.reduction:
        width = kernel.output.bits
        if width <= mapped_bits:
            extension = f"fifo_data[lane_index*MAP_BITS +: {width}]"
        else:
            sign = "fifo_data[lane_index*MAP_BITS+MAP_BITS-1]" if kernel.mapped_type.signed else "1'b0"
            extension = f"{{{{{width-mapped_bits}{{{sign}}}}}, fifo_data[lane_index*MAP_BITS +: MAP_BITS]}}"
        lines.append(f"""
  reg [{width-1}:0] accumulator;
  reg [{width-1}:0] result_data;
  reg result_valid;
  reg [INDEX_BITS-1:0] reduce_index;
  reg [{width-1}:0] word_sum;
  integer lane_index;
  always @* begin
    word_sum = 0;
    for (lane_index = 0; lane_index < LANES; lane_index = lane_index + 1)
      word_sum = word_sum + {extension};
  end
  assign fifo_ready = !result_valid;
  assign out_valid = result_valid;
  assign out_data = result_data;
  always @(posedge clk) begin
    if (rst) begin
      accumulator <= 0;
      result_valid <= 0;
      reduce_index <= 0;
    end else begin
      if (out_valid && out_ready) begin
        result_valid <= 0;
        accumulator <= 0;
      end
      if (fifo_valid && fifo_ready) begin
        if (reduce_index == INDEX_BITS'(WORDS-1)) begin
          result_data <= accumulator + word_sum;
          result_valid <= 1;
          reduce_index <= 0;
        end else begin
          accumulator <= accumulator + word_sum;
          reduce_index <= reduce_index + 1'b1;
        end
      end
    end
  end
""")
    else:
        lines += ["  assign out_data = fifo_data;", "  assign out_valid = fifo_valid;",
                  "  assign fifo_ready = out_ready;"]
    lines.append("endmodule\n")
    return "\n".join(lines) + FIFO


FIFO = """
module elastic_fifo #(parameter integer WIDTH = 8, DEPTH = 2) (
  input wire clk, input wire rst,
  input wire [WIDTH-1:0] in_data, input wire in_valid, output wire in_ready,
  output wire [WIDTH-1:0] out_data, output wire out_valid, input wire out_ready
);
  localparam integer ADDRESS_BITS = DEPTH <= 1 ? 1 : $clog2(DEPTH);
  localparam integer COUNT_BITS = $clog2(DEPTH+1);
  reg [WIDTH-1:0] memory [0:DEPTH-1];
  reg [ADDRESS_BITS-1:0] write_index, read_index;
  reg [COUNT_BITS-1:0] count;
  wire pop = out_valid && out_ready;
  wire push = in_valid && in_ready;
  assign out_valid = count != 0;
  assign in_ready = (count < COUNT_BITS'(DEPTH)) || pop;
  assign out_data = memory[read_index];
  always @(posedge clk) begin
    if (rst) begin
      count <= 0;
      write_index <= 0;
      read_index <= 0;
    end else begin
      case ({push, pop})
        2'b10: count <= count + 1'b1;
        2'b01: count <= count - 1'b1;
        default: count <= count;
      endcase
      if (push) begin
        memory[write_index] <= in_data;
        write_index <= write_index == ADDRESS_BITS'(DEPTH-1) ? '0 : write_index + 1'b1;
      end
      if (pop) read_index <= read_index == ADDRESS_BITS'(DEPTH-1) ? '0 : read_index + 1'b1;
    end
  end
endmodule
"""
