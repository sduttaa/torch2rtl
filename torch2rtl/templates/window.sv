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
  reg [HORIZONTAL_BITS-1:0] horizontal_address;
  reg [ADDRESS_BITS-1:0] pending_address, address;
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
                   (PACKED_LINES != 0 && EFFECTIVE_H > 1 ? !pending : !(pending && pending_output) && !collision);
  assign issue = can_issue && (padding || in_valid);
  assign in_ready = can_issue && !padding;
  wire output_pixel = eligible_row && eligible_column &&
                      (32'(row) - EFFECTIVE_H + 1) % STRIDE_H == 0 &&
                      (32'(column) - EFFECTIVE_W + 1) % STRIDE_W == 0;
  wire [WORD_BITS-1:0] rows [0:EFFECTIVE_H-1];
  wire [WORD_BITS-1:0] issue_data;
  wire commit;
  assign rows[0] = pending_data;
  genvar delay_row, input_lane;
  generate for (input_lane = 0; input_lane < LANES; input_lane = input_lane + 1) begin: input_value
    assign issue_data[input_lane*BITS +: BITS] = 32'(channel_word)*LANES+input_lane >= CHANNELS ? BITS'(0) :
      padding ? PADDING_VALUE : in_data[input_lane*BITS +: BITS];
  end endgenerate
  generate if (PACKED_LINES != 0 && EFFECTIVE_H > 1) begin: packed_lines
    wire [(EFFECTIVE_H-1)*WORD_BITS-1:0] delayed;
    wire complete;
    packed_line_store #(.ROWS(EFFECTIVE_H-1), .LINE_WORDS(LINE_WORDS), .BITS(WORD_BITS), .MEMORY_STYLE(MEMORY_STYLE)) storage (
      .clk(clk), .rst(rst), .issue(issue && !column_padding), .address(address), .data(issue_data),
      .complete(complete), .delayed(delayed));
    assign commit = pending && (pending_column_padding || complete);
    for (delay_row = 1; delay_row < EFFECTIVE_H; delay_row = delay_row + 1) begin: row_value
      assign rows[delay_row] = pending_column_padding ? pending_data : delayed[(delay_row-1)*WORD_BITS +: WORD_BITS];
    end
  end else begin: parallel_lines
    assign commit = pending;
    for (delay_row = 1; delay_row < EFFECTIVE_H; delay_row = delay_row + 1) begin: line
    (* ram_style = MEMORY_STYLE *) reg [WORD_BITS-1:0] memory [0:LINE_WORDS-1];
    reg [WORD_BITS-1:0] read_data;
    assign rows[delay_row] = pending_column_padding ? pending_data : read_data;
    always @(posedge clk) begin
      if (issue && !column_padding) read_data <= memory[address];
      if (!rst && pending && !pending_column_padding) memory[pending_address] <= rows[delay_row-1];
    end
    end
  end endgenerate

  wire [WORD_BITS-1:0] horizontal [0:KERNEL_H-1];
  wire [ROW_BITS-1:0] selected_rows [0:WINDOW_WORDS-1];
  wire [HORIZONTAL_BITS-1:0] selected_offsets [0:WINDOW_WORDS-1];
  wire [HORIZONTAL_BITS-1:0] offset;
  wire [ROW_BITS-1:0] read_row;
  wire [HORIZONTAL_BITS:0] circular_address = {1'b0, horizontal_address} + {1'b0, offset};
  wire [HORIZONTAL_BITS-1:0] wrapped_address = HORIZONTAL_BITS'(
    circular_address >= (HORIZONTAL_BITS+1)'(HORIZONTAL_WORDS) ?
    circular_address - (HORIZONTAL_BITS+1)'(HORIZONTAL_WORDS) : circular_address);
  wire [HORIZONTAL_BITS-1:0] read_address;
  generate if (PIPELINED_READ != 0) begin: pipelined_read
    reg [HORIZONTAL_BITS-1:0] requested_offset, active_address;
    reg [ROW_BITS-1:0] requested_row, active_row;
    wire [ROW_BITS-1:0] next_row;
    wire [HORIZONTAL_BITS-1:0] main_offset;
    wire [ROW_BITS-1:0] main_row;
    always @(posedge clk) begin
      requested_offset <= selected_offsets[window_address];
      requested_row <= selected_rows[window_address];
      active_address <= wrapped_address;
      active_row <= next_row;
    end
    if (STARTUP_READ != 0) begin: startup
      reg [HORIZONTAL_BITS-1:0] first_offset;
      reg [ROW_BITS-1:0] first_row;
      reg selected;
      always @(posedge clk) begin
        first_offset <= selected_offsets[first_address];
        first_row <= selected_rows[first_address];
        selected <= select_first;
      end
      // Decode both coordinates before selecting startup. This keeps actor
      // state off the pooled/grouped address decoder without adding latency.
      assign main_offset = selected ? first_offset : requested_offset;
      assign main_row = selected ? first_row : requested_row;
    end else begin: continuous
      assign main_offset = requested_offset;
      assign main_row = requested_row;
    end
    if (ALTERNATE_READ != 0) begin: alternate
      reg [HORIZONTAL_BITS-1:0] alternate_offset;
      reg [ROW_BITS-1:0] alternate_row;
      reg selected;
      always @(posedge clk) begin
        alternate_offset <= selected_offsets[alternate_address];
        alternate_row <= selected_rows[alternate_address];
        selected <= select_alternate;
      end
      assign offset = selected ? alternate_offset : main_offset;
      assign next_row = selected ? alternate_row : main_row;
    end else begin: single
      assign offset = main_offset;
      assign next_row = main_row;
    end
    assign read_address = active_address;
    assign read_row = active_row;
  end else begin: direct_read
    assign offset = selected_offsets[window_address];
    assign read_address = wrapped_address;
    assign read_row = selected_rows[window_address];
  end endgenerate
  // One circular bank per selected row packs short channel vectors together.
  // The pointer after a complete pixel identifies the oldest horizontal tap.
  genvar ky, kx, word;
  generate for (ky = 0; ky < KERNEL_H; ky = ky + 1) begin: kernel_row
    reg [WORD_BITS-1:0] memory [0:HORIZONTAL_WORDS-1];
    assign horizontal[ky] = memory[read_address];
    always @(posedge clk)
      if (!rst && commit) memory[horizontal_address] <= rows[(KERNEL_H-1-ky)*DILATION_H];
  end endgenerate
  // Wire the static dilation pattern once. Runtime division/remainder would
  // unnecessarily implement index algebra as logic before this read mux.
  generate for (ky = 0; ky < KERNEL_H; ky = ky + 1) begin: selected_row
    for (kx = 0; kx < KERNEL_W; kx = kx + 1) begin: selected_column
      for (word = 0; word < CHANNEL_WORDS; word = word + 1) begin: selected_channel
        assign selected_rows[(ky*KERNEL_W+kx)*CHANNEL_WORDS+word] = ROW_BITS'(ky);
        assign selected_offsets[(ky*KERNEL_W+kx)*CHANNEL_WORDS+word] = HORIZONTAL_BITS'(kx*DILATION_W*CHANNEL_WORDS+word);
      end
    end
  end endgenerate
  assign window_data = horizontal[read_row];

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
      last_channel <= CHANNEL_WORDS == 1;
      last_column <= PADDED_W == 1;
    end else begin
      if (PACKED_LINES != 0 && EFFECTIVE_H > 1) begin
        if (commit) pending <= 0;
        if (issue) pending <= 1;
      end else pending <= issue;
      if (release_window) window_available <= 0;
      if (commit && pending_output) window_available <= 1;
      if (commit) horizontal_address <= horizontal_address == HORIZONTAL_BITS'(HORIZONTAL_WORDS-1) ?
        HORIZONTAL_BITS'(0) : horizontal_address + 1'b1;
      if (issue) begin
        if (!column_padding) address <= address == ADDRESS_BITS'(LINE_WORDS-1) ? ADDRESS_BITS'(0) : address + 1'b1;
        pending_address <= address;
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

// Pack several row delays into one addressed memory. Each accepted word
// visits the rows in order, reading the next row while writing the previous.
// This trades input bandwidth for fewer partially filled memory banks.
module packed_line_store #(
  parameter integer ROWS = 1, LINE_WORDS = 1, BITS = 8,
  parameter MEMORY_STYLE = "auto",
  localparam integer ADDRESS_BITS = LINE_WORDS <= 1 ? 1 : $clog2(LINE_WORDS),
  localparam integer MEMORY_BITS = ROWS*LINE_WORDS <= 1 ? 1 : $clog2(ROWS*LINE_WORDS),
  localparam integer ROW_BITS = ROWS <= 1 ? 1 : $clog2(ROWS)
) (
  input wire clk, input wire rst, input wire issue,
  input wire [ADDRESS_BITS-1:0] address, input wire [BITS-1:0] data,
  output wire complete, output wire [ROWS*BITS-1:0] delayed
);
  reg busy;
  reg [ROW_BITS-1:0] row;
  reg [MEMORY_BITS-1:0] location;
  reg [BITS-1:0] carry, read_data;
  // A transaction finishes before the next issue. While busy, the read is
  // one full row ahead of the write, so enabled accesses never collide.
  (* ram_style = MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:ROWS*LINE_WORDS-1];
  reg [BITS-1:0] saved [0:ROWS-1];
  wire [MEMORY_BITS-1:0] next_location = location + MEMORY_BITS'(LINE_WORDS);
  wire [MEMORY_BITS-1:0] read_location = issue ? MEMORY_BITS'(address) : next_location;
  assign complete = !rst && busy && row == ROW_BITS'(ROWS-1);
  genvar index;
  generate for (index = 0; index < ROWS; index = index + 1) begin: result
    assign delayed[index*BITS +: BITS] = index == ROWS-1 ? read_data : saved[index];
    always @(posedge clk)
      if (!rst && busy && row == ROW_BITS'(index)) saved[index] <= read_data;
  end endgenerate
  always @(posedge clk) begin
    if (!rst) begin
      if (issue || (busy && !complete)) read_data <= memory[read_location];
      if (busy) memory[location] <= carry;
    end
  end
  always @(posedge clk) begin
    if (rst) begin
      busy <= 0;
    end else begin
      if (issue) begin
        busy <= 1;
        row <= 0;
        location <= MEMORY_BITS'(address);
        carry <= data;
      end
      if (busy) begin
        carry <= read_data;
        if (complete) busy <= 0;
        else begin
          row <= row + 1'b1;
          location <= next_location;
        end
      end
    end
  end
endmodule
