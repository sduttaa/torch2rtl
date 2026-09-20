// DEPTH counts all live words, including the output register. The memory has
// one spare slot, avoiding ambiguous same-address block-RAM reads and writes.
module stream_fifo #(
  parameter integer WIDTH = 8, DEPTH = 2,
  parameter MEMORY_STYLE = "auto"
) (
  input wire clk, input wire rst,
  input wire [WIDTH-1:0] in_data, input wire in_valid, output wire in_ready,
  output wire [WIDTH-1:0] out_data, output wire out_valid, input wire out_ready
);
  generate if (DEPTH == 1) begin: single
    reg [WIDTH-1:0] data;
    reg valid;
    assign in_ready = !rst && (!valid || out_ready);
    assign out_valid = !rst && valid;
    assign out_data = data;
    always @(posedge clk) begin
      if (rst) valid <= 0;
      else if (in_ready) begin
        valid <= in_valid;
        if (in_valid) data <= in_data;
      end
    end
  end else begin: buffered
    localparam integer ADDRESS_BITS = $clog2(DEPTH);
    localparam integer COUNT_BITS = $clog2(DEPTH+1);
    (* ram_style = MEMORY_STYLE *) reg [WIDTH-1:0] memory [0:DEPTH-1];
    reg [WIDTH-1:0] data;
    reg valid;
    reg [ADDRESS_BITS-1:0] read_index, write_index;
    reg [COUNT_BITS-1:0] count;
    wire pop = out_valid && out_ready;
    wire push = in_valid && in_ready;
    wire read_word = !rst && (!valid || out_ready) && count > COUNT_BITS'(valid);
    assign in_ready = !rst && (count < COUNT_BITS'(DEPTH) || pop);
    assign out_valid = !rst && valid;
    assign out_data = data;
    always @(posedge clk) begin
      if (push) memory[write_index] <= in_data;
      if (read_word) data <= memory[read_index];
    end
    always @(posedge clk) begin
      if (rst) begin
        valid <= 0;
        count <= 0;
        read_index <= 0;
        write_index <= 0;
      end else begin
        if (pop) valid <= 0;
        if (read_word) begin
          valid <= 1;
          read_index <= read_index == ADDRESS_BITS'(DEPTH-1) ? ADDRESS_BITS'(0) : read_index + 1'b1;
        end
        if (push) write_index <= write_index == ADDRESS_BITS'(DEPTH-1) ? ADDRESS_BITS'(0) : write_index + 1'b1;
        case ({push, pop})
          2'b10: count <= count + 1'b1;
          2'b01: count <= count - 1'b1;
          default: ;
        endcase
      end
    end
  end endgenerate
endmodule
