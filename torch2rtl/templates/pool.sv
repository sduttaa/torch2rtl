module integer_max_pool #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer STRIDE_H = 1, STRIDE_W = 1,
  parameter integer DILATION_H = 1, DILATION_W = 1,
  parameter integer PAD_H = 0, PAD_W = 0,
  parameter integer LANES = 1, BITS = 8, SIGNED = 0,
  parameter MEMORY_STYLE = "auto",
  localparam integer CHANNEL_WORDS = (CHANNELS + LANES - 1) / LANES,
  localparam integer KERNEL_WORDS = KERNEL_H * KERNEL_W,
  localparam integer WINDOW_WORDS = KERNEL_WORDS * CHANNEL_WORDS,
  localparam integer WINDOW_BITS = WINDOW_WORDS <= 1 ? 1 : $clog2(WINDOW_WORDS),
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer TAP_BITS = KERNEL_WORDS <= 1 ? 1 : $clog2(KERNEL_WORDS),
  localparam [BITS-1:0] MINIMUM = SIGNED != 0 ? BITS'(1) << (BITS-1) : BITS'(0)
) (
  input wire clk, input wire rst,
  input wire [LANES*BITS-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*BITS-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg active, output_pending;
  reg [CHANNEL_BITS-1:0] channel_word;
  reg [TAP_BITS-1:0] tap;
  reg [LANES*BITS-1:0] maximum;
  wire window_available;
  wire last_tap = tap == TAP_BITS'(KERNEL_WORDS-1);
  wire last_word = channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1);
  wire advance = active && (!last_tap || !output_pending || out_ready);
  wire release_window = advance && last_tap && last_word;
  wire [WINDOW_BITS-1:0] window_address = WINDOW_BITS'(32'(tap)*CHANNEL_WORDS + 32'(channel_word));
  wire [LANES*BITS-1:0] window_data;
  raster_window #(
    .HEIGHT(HEIGHT), .WIDTH(WIDTH), .CHANNELS(CHANNELS),
    .KERNEL_H(KERNEL_H), .KERNEL_W(KERNEL_W), .STRIDE_H(STRIDE_H), .STRIDE_W(STRIDE_W),
    .DILATION_H(DILATION_H), .DILATION_W(DILATION_W), .PAD_H(PAD_H), .PAD_W(PAD_W),
    .LANES(LANES), .BITS(BITS), .PADDING_VALUE(MINIMUM), .MEMORY_STYLE(MEMORY_STYLE)
  ) window (
    .clk(clk), .rst(rst), .in_data(in_data), .in_valid(in_valid), .in_ready(in_ready),
    .window_available(window_available), .release_window(release_window),
    .window_address(window_address), .window_data(window_data)
  );
  assign out_valid = output_pending && !rst;
  wire [LANES*BITS-1:0] next_maximum;
  genvar lane;
  generate for (lane = 0; lane < LANES; lane = lane + 1) begin: compare
    wire [BITS-1:0] value = window_data[lane*BITS +: BITS];
    wire [BITS-1:0] previous = maximum[lane*BITS +: BITS];
    wire greater = SIGNED != 0 ? $signed(value) > $signed(previous) : value > previous;
    assign next_maximum[lane*BITS +: BITS] = tap == 0 || greater ? value : previous;
  end endgenerate
  integer channel;
  always @(posedge clk) begin
    if (rst) begin
      active <= 0;
      output_pending <= 0;
      tap <= 0;
      channel_word <= 0;
    end else begin
      if (out_ready) output_pending <= 0;
      if (!active && window_available) begin
        active <= 1;
        tap <= 0;
        channel_word <= 0;
      end
      if (advance) begin
        maximum <= next_maximum;
        if (last_tap) begin
          output_pending <= 1;
          for (channel = 0; channel < LANES; channel = channel + 1)
            out_data[channel*BITS +: BITS] <= 32'(channel_word)*LANES+channel < CHANNELS ?
              next_maximum[channel*BITS +: BITS] : BITS'(0);
          tap <= 0;
          if (last_word) active <= 0;
          else channel_word <= channel_word + 1'b1;
        end else tap <= tap + 1'b1;
      end
    end
  end
endmodule
