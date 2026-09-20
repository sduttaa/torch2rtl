module integer_lookup #(
  parameter integer CHANNELS = 1, LANES = 1,
  parameter [2047:0] TABLE = 0,
  localparam integer CHANNEL_WORDS = (CHANNELS+LANES-1) / LANES,
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS)
) (
  input wire clk, input wire rst,
  input wire [LANES*8-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*8-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg valid;
  reg [CHANNEL_BITS-1:0] channel_word;
  assign in_ready = !rst && (!valid || out_ready);
  assign out_valid = !rst && valid;
  integer lane;
  always @(posedge clk) begin
    if (rst) begin valid <= 0; channel_word <= 0; end
    else if (in_ready) begin
      valid <= in_valid;
      if (in_valid) begin
        for (lane = 0; lane < LANES; lane = lane + 1)
          out_data[lane*8 +: 8] <= 32'(channel_word)*LANES+lane < CHANNELS ?
            TABLE[32'(in_data[lane*8 +: 8])*8 +: 8] : 8'd0;
        channel_word <= channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1) ? CHANNEL_BITS'(0) : channel_word + 1'b1;
      end
    end
  end
endmodule
