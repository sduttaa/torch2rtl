// Raster input consists of channel vectors, with zero padding in the final
// vector of each pixel. A completed window is retained until release_window.
// Read addresses enumerate kernel y, kernel x, then the channel vector.
module raster_window #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer STRIDE_H = 1, STRIDE_W = 1,
  parameter integer DILATION_H = 1, DILATION_W = 1,
  parameter integer PAD_H = 0, PAD_W = 0,
  parameter integer LANES = 1, BITS = 8,
  parameter [BITS-1:0] PADDING_VALUE = 0,
  parameter MEMORY_STYLE = "auto",
  localparam integer CHANNEL_WORDS = (CHANNELS + LANES - 1) / LANES,
  localparam integer WORD_BITS = LANES * BITS,
  localparam integer EFFECTIVE_H = (KERNEL_H - 1) * DILATION_H + 1,
  localparam integer EFFECTIVE_W = (KERNEL_W - 1) * DILATION_W + 1,
  localparam integer PADDED_H = HEIGHT + 2 * PAD_H,
  localparam integer PADDED_W = WIDTH + 2 * PAD_W,
  localparam integer LINE_WORDS = WIDTH * CHANNEL_WORDS,
  localparam integer HORIZONTAL_WORDS = EFFECTIVE_W * CHANNEL_WORDS,
  localparam integer HORIZONTAL_BITS = HORIZONTAL_WORDS <= 1 ? 1 : $clog2(HORIZONTAL_WORDS),
  localparam integer WINDOW_WORDS = KERNEL_H * KERNEL_W * CHANNEL_WORDS,
  localparam integer WINDOW_BITS = WINDOW_WORDS <= 1 ? 1 : $clog2(WINDOW_WORDS),
  localparam integer X_BITS = PADDED_W <= 1 ? 1 : $clog2(PADDED_W),
  localparam integer Y_BITS = PADDED_H <= 1 ? 1 : $clog2(PADDED_H),
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer ADDRESS_BITS = LINE_WORDS <= 1 ? 1 : $clog2(LINE_WORDS)
) (
  input wire clk, input wire rst,
  input wire [WORD_BITS-1:0] in_data,
  input wire in_valid, output wire in_ready,
  output reg window_available, input wire release_window,
  input wire [WINDOW_BITS-1:0] window_address,
  output wire [WORD_BITS-1:0] window_data
);
  reg [X_BITS-1:0] column;
  reg [Y_BITS-1:0] row;
  reg [CHANNEL_BITS-1:0] channel_word;
  reg [HORIZONTAL_BITS-1:0] horizontal_address;
  reg [ADDRESS_BITS-1:0] pending_address, address;
  reg [WORD_BITS-1:0] pending_data;
  reg pending, pending_output, pending_column_padding;
  wire row_padding, column_padding, eligible_row, eligible_column;
  generate
    if (PAD_H == 0) assign row_padding = 1'b0;
    else assign row_padding = 32'(row) < PAD_H || 32'(row) >= PAD_H + HEIGHT;
    if (PAD_W == 0) assign column_padding = 1'b0;
    else assign column_padding = 32'(column) < PAD_W || 32'(column) >= PAD_W + WIDTH;
    if (EFFECTIVE_H == 1) assign eligible_row = 1'b1;
    else assign eligible_row = 32'(row) >= EFFECTIVE_H-1;
    if (EFFECTIVE_W == 1) assign eligible_column = 1'b1;
    else assign eligible_column = 32'(column) >= EFFECTIVE_W-1;
  endgenerate
  wire padding = row_padding || column_padding;
  // A one-word row needs a bubble to avoid a same-address read/write hazard.
  wire collision = pending && !pending_column_padding && !column_padding && address == pending_address;
  wire can_issue = !rst && (!window_available || release_window) &&
                   !(pending && pending_output) && !collision;
  wire issue = can_issue && (padding || in_valid);
  assign in_ready = can_issue && !padding;
  wire output_pixel = eligible_row && eligible_column &&
                      (32'(row) - EFFECTIVE_H + 1) % STRIDE_H == 0 &&
                      (32'(column) - EFFECTIVE_W + 1) % STRIDE_W == 0;
  wire [WORD_BITS-1:0] rows [0:EFFECTIVE_H-1];
  assign rows[0] = pending_data;
  genvar delay_row;
  generate for (delay_row = 1; delay_row < EFFECTIVE_H; delay_row = delay_row + 1) begin: line
    (* ram_style = MEMORY_STYLE *) reg [WORD_BITS-1:0] memory [0:LINE_WORDS-1];
    reg [WORD_BITS-1:0] read_data;
    assign rows[delay_row] = pending_column_padding ? pending_data : read_data;
    always @(posedge clk) begin
      if (issue && !column_padding) read_data <= memory[address];
      if (!rst && pending && !pending_column_padding) memory[pending_address] <= rows[delay_row-1];
    end
  end endgenerate

  wire [WORD_BITS-1:0] horizontal [0:KERNEL_H-1];
  wire [WORD_BITS-1:0] selected_words [0:WINDOW_WORDS-1];
  wire [HORIZONTAL_BITS-1:0] selected_offsets [0:WINDOW_WORDS-1];
  wire [HORIZONTAL_BITS:0] circular_address = {1'b0, horizontal_address} + {1'b0, selected_offsets[window_address]};
  wire [HORIZONTAL_BITS-1:0] read_address = HORIZONTAL_BITS'(
    circular_address >= (HORIZONTAL_BITS+1)'(HORIZONTAL_WORDS) ?
    circular_address - (HORIZONTAL_BITS+1)'(HORIZONTAL_WORDS) : circular_address);
  // One circular bank per selected row packs short channel vectors together.
  // The pointer after a complete pixel identifies the oldest horizontal tap.
  genvar ky, kx, word;
  generate for (ky = 0; ky < KERNEL_H; ky = ky + 1) begin: kernel_row
    reg [WORD_BITS-1:0] memory [0:HORIZONTAL_WORDS-1];
    assign horizontal[ky] = memory[read_address];
    always @(posedge clk)
      if (!rst && pending) memory[horizontal_address] <= rows[(KERNEL_H-1-ky)*DILATION_H];
  end endgenerate
  // Wire the static dilation pattern once. Runtime division/remainder would
  // unnecessarily implement index algebra as logic before this read mux.
  generate for (ky = 0; ky < KERNEL_H; ky = ky + 1) begin: selected_row
    for (kx = 0; kx < KERNEL_W; kx = kx + 1) begin: selected_column
      for (word = 0; word < CHANNEL_WORDS; word = word + 1) begin: selected_channel
        assign selected_words[(ky*KERNEL_W+kx)*CHANNEL_WORDS+word] = horizontal[ky];
        assign selected_offsets[(ky*KERNEL_W+kx)*CHANNEL_WORDS+word] = HORIZONTAL_BITS'(kx*DILATION_W*CHANNEL_WORDS+word);
      end
    end
  end endgenerate
  assign window_data = selected_words[window_address];

  integer lane;
  always @(posedge clk) begin
    if (rst) begin
      column <= 0;
      row <= 0;
      channel_word <= 0;
      address <= 0;
      horizontal_address <= 0;
      pending <= 0;
      pending_output <= 0;
      pending_column_padding <= 0;
      window_available <= 0;
    end else begin
      pending <= issue;
      if (release_window) window_available <= 0;
      if (pending && pending_output) window_available <= 1;
      if (pending) horizontal_address <= horizontal_address == HORIZONTAL_BITS'(HORIZONTAL_WORDS-1) ?
        HORIZONTAL_BITS'(0) : horizontal_address + 1'b1;
      if (issue) begin
        if (!column_padding) address <= address == ADDRESS_BITS'(LINE_WORDS-1) ? ADDRESS_BITS'(0) : address + 1'b1;
        pending_address <= address;
        pending_column_padding <= column_padding;
        pending_output <= output_pixel && channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1);
        for (lane = 0; lane < LANES; lane = lane + 1)
          pending_data[lane*BITS +: BITS] <=
            32'(channel_word)*LANES+lane >= CHANNELS ? BITS'(0) :
            padding ? PADDING_VALUE : in_data[lane*BITS +: BITS];
        if (channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1)) begin
          channel_word <= 0;
          if (column == X_BITS'(PADDED_W-1)) begin
            column <= 0;
            row <= row == Y_BITS'(PADDED_H-1) ? Y_BITS'(0) : row + 1'b1;
          end else column <= column + 1'b1;
        end else channel_word <= channel_word + 1'b1;
      end
    end
  end
endmodule
