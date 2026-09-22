// DEPTH counts all live words, including the output register. The memory has
// one spare slot, avoiding ambiguous same-address block-RAM reads and writes.
// Readiness depends only on registered occupancy: a retired slot is reusable
// on the following edge, breaking combinational backpressure across actors.
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
    assign in_ready = !rst && !valid;
    assign out_valid = !rst && valid;
    assign out_data = data;
    always @(posedge clk) begin
      if (rst) valid <= 0;
      else begin
        if (out_ready) valid <= 0;
        if (in_valid && in_ready) begin
          valid <= 1;
          data <= in_data;
        end
      end
    end
  end else if (DEPTH == 2) begin: pair
    // Two registers sustain one transfer per edge without a RAM read stage.
    // Ready depends only on occupancy; downstream ready does not propagate
    // combinationally across the FIFO. A full queue releases credit next edge.
    reg [WIDTH-1:0] head, tail;
    reg head_valid, tail_valid;
    wire push=in_valid && in_ready;
    assign in_ready=!rst && !tail_valid;
    assign out_valid=!rst && head_valid;
    assign out_data=head;
    always @(posedge clk) begin
      if (rst) begin head_valid <= 0; tail_valid <= 0; end
      else begin
        // The three reachable states are empty, head only, and head+tail.
        // Direct next-state equations avoid cascaded pop/push priority muxes.
        head_valid <= in_valid || tail_valid || (head_valid && !out_ready);
        tail_valid <= !out_ready && (tail_valid || (in_valid && head_valid));
        // Select data using registered occupancy. Downstream ready controls
        // only the enable, keeping it off the data mux and its fanout.
        if ((out_ready && tail_valid) || (push && (!head_valid || out_ready)))
          head <= tail_valid ? tail : in_data;
        if (push && head_valid && !out_ready) tail <= in_data;
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
    assign in_ready = !rst && count < COUNT_BITS'(DEPTH);
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
