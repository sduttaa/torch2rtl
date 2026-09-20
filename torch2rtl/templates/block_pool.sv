// Nonoverlapping max pooling. One reduced row accumulates each rectangular
// block; forwarding preserves consecutive updates to the same RAM address.
module integer_block_pool #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer LANES = 1, BITS = 8, SIGNED = 0,
  parameter MEMORY_STYLE = "auto",
  localparam integer CHANNEL_WORDS = (CHANNELS + LANES - 1) / LANES,
  localparam integer OUTPUT_WIDTH = WIDTH / KERNEL_W,
  localparam integer OUTPUT_HEIGHT = HEIGHT / KERNEL_H,
  localparam integer WORDS = OUTPUT_WIDTH * CHANNEL_WORDS,
  localparam integer ADDRESS_BITS = WORDS <= 1 ? 1 : $clog2(WORDS),
  localparam integer BASE_BITS = $clog2(WORDS+1),
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer ROW_BITS = HEIGHT <= 1 ? 1 : $clog2(HEIGHT),
  localparam integer COLUMN_BITS = WIDTH <= 1 ? 1 : $clog2(WIDTH),
  localparam integer Y_BITS = KERNEL_H <= 1 ? 1 : $clog2(KERNEL_H),
  localparam integer X_BITS = KERNEL_W <= 1 ? 1 : $clog2(KERNEL_W)
) (
  input wire clk, input wire rst,
  input wire [LANES*BITS-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*BITS-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg [ROW_BITS-1:0] row;
  reg [COLUMN_BITS-1:0] column;
  reg [Y_BITS-1:0] block_y;
  reg [X_BITS-1:0] block_x;
  reg [CHANNEL_BITS-1:0] channel_word, pending_channel;
  reg [BASE_BITS-1:0] column_base;
  wire included = 32'(row) < OUTPUT_HEIGHT*KERNEL_H && 32'(column) < OUTPUT_WIDTH*KERNEL_W;
  wire [ADDRESS_BITS-1:0] address = included ? ADDRESS_BITS'(column_base + channel_word) : 0;
  wire last_channel = channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1);
  wire last_x = block_x == X_BITS'(KERNEL_W-1);
  wire last_y = block_y == Y_BITS'(KERNEL_H-1);
  reg pending, pending_included, pending_first, pending_last, forwarded, output_pending;
  reg [ADDRESS_BITS-1:0] pending_address;
  reg [LANES*BITS-1:0] pending_data, memory_data, forwarded_data;
  (* ram_style = MEMORY_STYLE *) reg [LANES*BITS-1:0] memory [0:WORDS-1];
  wire advance = pending && (!pending_last || !output_pending || out_ready);
  assign in_ready = !rst && (!pending || advance);
  assign out_valid = !rst && output_pending;
  wire capture = in_valid && in_ready;
  wire [LANES*BITS-1:0] previous = forwarded ? forwarded_data : memory_data;
  wire [LANES*BITS-1:0] maximum;
  genvar lane;
  generate for (lane = 0; lane < LANES; lane = lane + 1) begin: compare
    wire [BITS-1:0] value = pending_data[lane*BITS +: BITS];
    wire [BITS-1:0] prior = previous[lane*BITS +: BITS];
    wire greater = SIGNED != 0 ? $signed(value) > $signed(prior) : value > prior;
    assign maximum[lane*BITS +: BITS] = pending_first || greater ? value : prior;
  end endgenerate
  always @(posedge clk) begin
    if (capture && included) memory_data <= memory[address];
    if (!rst && advance && pending_included) memory[pending_address] <= maximum;
  end
  integer channel;
  always @(posedge clk) begin
    if (rst) begin
      row <= 0;
      column <= 0;
      block_y <= 0;
      block_x <= 0;
      channel_word <= 0;
      column_base <= 0;
      pending <= 0;
      output_pending <= 0;
    end else begin
      if (out_ready) output_pending <= 0;
      if (advance) begin
        pending <= 0;
        if (pending_last) begin
          output_pending <= 1;
          for (channel = 0; channel < LANES; channel = channel + 1)
            out_data[channel*BITS +: BITS] <= 32'(pending_channel)*LANES+channel < CHANNELS ?
              maximum[channel*BITS +: BITS] : BITS'(0);
        end
      end
      if (capture) begin
        pending <= 1;
        pending_included <= included;
        pending_first <= block_y == 0 && block_x == 0;
        pending_last <= included && last_x && last_y;
        pending_data <= in_data;
        pending_address <= address;
        pending_channel <= channel_word;
        forwarded <= advance && pending_included && pending_address == address;
        forwarded_data <= maximum;
        if (last_channel) begin
          channel_word <= 0;
          block_x <= last_x ? X_BITS'(0) : block_x + 1'b1;
          if (last_x) column_base <= column_base + BASE_BITS'(CHANNEL_WORDS);
          if (column == COLUMN_BITS'(WIDTH-1)) begin
            column <= 0;
            column_base <= 0;
            block_x <= 0;
            row <= row == ROW_BITS'(HEIGHT-1) ? ROW_BITS'(0) : row + 1'b1;
            block_y <= row == ROW_BITS'(HEIGHT-1) || last_y ? Y_BITS'(0) : block_y + 1'b1;
          end else column <= column + 1'b1;
        end else channel_word <= channel_word + 1'b1;
      end
    end
  end
endmodule
