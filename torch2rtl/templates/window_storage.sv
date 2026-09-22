// Width banks expose the supplied memory aspect ratio to inference. Each
// independent array has the same address and preserves the requested latency.
module window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
