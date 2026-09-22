// Raster input consists of channel vectors, with zero padding in the final
// vector of each pixel. A completed window is retained until release_window.
// Read addresses enumerate kernel y, kernel x, then the channel vector.
// PIPELINED_READ accepts coordinates two edges before their data is consumed.
module raster_window #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer STRIDE_H = 1, STRIDE_W = 1,
  parameter integer DILATION_H = 1, DILATION_W = 1,
  parameter integer PAD_H = 0, PAD_W = 0,
  parameter integer LANES = 1, BITS = 8,
  parameter [BITS-1:0] PADDING_VALUE = 0,
  parameter MEMORY_STYLE = "auto",
  parameter integer PACKED_LINES = 0, PIPELINED_READ = 0, ALTERNATE_READ = 0, STARTUP_READ = 0,
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
  localparam integer ROW_BITS = KERNEL_H <= 1 ? 1 : $clog2(KERNEL_H),
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
  input wire [WINDOW_BITS-1:0] alternate_address, input wire select_alternate,
  input wire [WINDOW_BITS-1:0] first_address, input wire select_first,
  output wire [WORD_BITS-1:0] window_data
);
  reg [X_BITS-1:0] column;
  reg [Y_BITS-1:0] row;
  reg [CHANNEL_BITS-1:0] channel_word;
  reg [WORD_BITS-1:0] pending_data;
  reg pending, pending_output, pending_column_padding;
  reg last_channel, last_column;
  wire row_padding, column_padding, eligible_row, eligible_column;
  wire issue;
  generate
    if (PAD_H == 0) assign row_padding = 1'b0;
    else begin: padded_rows
      reg padding_row;
      assign row_padding = padding_row;
      always @(posedge clk) begin
        if (rst) padding_row <= 1;
        else if (issue && last_channel && last_column) begin
          if (row == Y_BITS'(PAD_H-1)) padding_row <= 0;
          else if (row == Y_BITS'(PAD_H+HEIGHT-1)) padding_row <= 1;
        end
      end
    end
    if (PAD_W == 0) assign column_padding = 1'b0;
    else begin: padded_columns
      reg padding_column;
      assign column_padding = padding_column;
      always @(posedge clk) begin
        if (rst) padding_column <= 1;
        else if (issue && last_channel) begin
          if (column == X_BITS'(PAD_W-1)) padding_column <= 0;
          else if (column == X_BITS'(PAD_W+WIDTH-1)) padding_column <= 1;
        end
      end
    end
    if (EFFECTIVE_H == 1) assign eligible_row = 1'b1;
    else assign eligible_row = 32'(row) >= EFFECTIVE_H-1;
    if (EFFECTIVE_W == 1) assign eligible_column = 1'b1;
    else assign eligible_column = 32'(column) >= EFFECTIVE_W-1;
  endgenerate
  wire padding = row_padding || column_padding;
  // A one-word row needs a bubble to avoid a same-address read/write hazard.
  // Every real-column issue advances the circular address. Only a one-word
  // row can reuse the pending write address on the following issue.
  wire collision = LINE_WORDS == 1 && pending && !pending_column_padding && !column_padding;
  wire can_issue = !rst && (!window_available || release_window) &&
                   !(pending && pending_output) && !collision;
  assign issue = can_issue && (padding || in_valid);
  assign in_ready = can_issue && !padding;
  wire output_pixel = eligible_row && eligible_column &&
                      (32'(row) - EFFECTIVE_H + 1) % STRIDE_H == 0 &&
                      (32'(column) - EFFECTIVE_W + 1) % STRIDE_W == 0;
  wire [WORD_BITS-1:0] issue_data;
  wire commit = pending;
  genvar input_lane;
  generate for (input_lane=0; input_lane<LANES; input_lane=input_lane+1) begin: input_value
    assign issue_data[input_lane*BITS +: BITS] = 32'(channel_word)*LANES+input_lane >= CHANNELS ? BITS'(0) :
      padding ? PADDING_VALUE : in_data[input_lane*BITS +: BITS];
  end endgenerate
  generate begin: ring_window
    // Retain exactly the raster span of the live window. Power-of-two storage
    // makes both the write cursor and every tap address wrap by truncation.
    localparam integer SPAN = ((EFFECTIVE_H-1)*PADDED_W+EFFECTIVE_W)*CHANNEL_WORDS;
    localparam integer INDEX_BITS = SPAN <= 1 ? 1 : $clog2(SPAN);
    localparam integer DEPTH = @DEPTH@;
    reg [INDEX_BITS-1:0] write_index, origin;@ADDRESS_STATE@
    wire [INDEX_BITS-1:0] coordinates [0:WINDOW_WORDS-1];
    genvar y, x, word;
    for (y=0; y<KERNEL_H; y=y+1) begin: row_coordinate
      for (x=0; x<KERNEL_W; x=x+1) begin: column_coordinate
        for (word=0; word<CHANNEL_WORDS; word=word+1) begin: channel_coordinate
          assign coordinates[(y*KERNEL_W+x)*CHANNEL_WORDS+word] =
            INDEX_BITS'((y*DILATION_H*PADDED_W+x*DILATION_W)*CHANNEL_WORDS+word);
        end
      end
    end
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [WORD_BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) begin
      @RESET@
      else if (commit) begin
        write_index <= @NEXT_INDEX@;
        @ORIGIN_UPDATE@
      end
      if (!rst && commit) memory[write_index] <= pending_data;
    end
    if (PIPELINED_READ != 0) begin: pipelined
      reg [INDEX_BITS-1:0] requested, first, alternate;
      reg use_first, use_alternate;
      wire [INDEX_BITS-1:0] offset = ALTERNATE_READ != 0 && use_alternate ? alternate :
        STARTUP_READ != 0 && use_first ? first : requested;
      @PIPELINED_LOCATION@
      reg [WORD_BITS-1:0] data, forwarded_data;
      reg forwarded;
      always @(posedge clk) begin
        requested <= coordinates[window_address];
        first <= coordinates[first_address];
        alternate <= coordinates[alternate_address];
        use_first <= select_first;
        use_alternate <= select_alternate;
        data <= memory[location];
        // Match the window's write-first visibility without depending on the
        // target RAM's read-during-write behavior for equal addresses.
        forwarded <= !rst && commit && write_index == location;
        forwarded_data <= pending_data;
      end
      assign window_data = forwarded ? forwarded_data : data;
    end else begin: asynchronous
      @ASYNC_LOCATION@
      assign window_data = memory[location];
    end
  end endgenerate
  always @(posedge clk) begin
    if (rst) begin
      column <= 0;
      row <= 0;
      channel_word <= 0;
      pending <= 0;
      pending_output <= 0;
      pending_column_padding <= 0;
      window_available <= 0;
      last_channel <= CHANNEL_WORDS == 1;
      last_column <= PADDED_W == 1;
    end else begin
      pending <= issue;
      if (release_window) window_available <= 0;
      if (commit && pending_output) window_available <= 1;
      if (issue) begin
        pending_column_padding <= column_padding;
        pending_output <= output_pixel && last_channel;
        pending_data <= issue_data;
        last_channel <= CHANNEL_WORDS == 1 || (!last_channel && channel_word == CHANNEL_BITS'(CHANNEL_WORDS-2));
        if (last_channel) begin
          channel_word <= 0;
          last_column <= PADDED_W == 1 || (!last_column && column == X_BITS'(PADDED_W-2));
          if (last_column) begin
            column <= 0;
            row <= row == Y_BITS'(PADDED_H-1) ? Y_BITS'(0) : row + 1'b1;
          end else column <= column + 1'b1;
        end else channel_word <= channel_word + 1'b1;
      end
    end
  end
endmodule
