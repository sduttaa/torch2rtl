module integer_concatenate #(
  parameter integer INPUTS = 1, LANES = 1, OUTPUT_CHANNELS = 1, TABLE_COUNT = 1,
  parameter [INPUTS*32-1:0] CHANNELS = 1,
  localparam integer TABLE_BITS = TABLE_COUNT <= 1 ? 1 : $clog2(TABLE_COUNT),
  parameter [OUTPUT_CHANNELS*TABLE_BITS-1:0] CHANNEL_TABLES = 0,
  parameter [TABLE_COUNT*256*8-1:0] TABLES = 0,
  localparam integer PORT_BITS = INPUTS <= 1 ? 1 : $clog2(INPUTS),
  localparam integer OUTPUT_WORDS = (OUTPUT_CHANNELS + LANES - 1) / LANES,
  localparam integer WORD_BITS = OUTPUT_WORDS <= 1 ? 1 : $clog2(OUTPUT_WORDS),
  localparam integer CHANNEL_BITS = OUTPUT_CHANNELS <= 1 ? 1 : $clog2(OUTPUT_CHANNELS)
) (
  input wire clk, input wire rst,
  input wire [INPUTS*LANES*8-1:0] in_data,
  input wire [INPUTS-1:0] in_valid, output wire [INPUTS-1:0] in_ready,
  output reg [LANES*8-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg sending;
  reg [PORT_BITS-1:0] port;
  reg [WORD_BITS-1:0] input_word, output_word;
  reg [CHANNEL_BITS-1:0] channel_offset;
  reg [7:0] pixel [0:OUTPUT_CHANNELS-1];
  wire [31:0] channel_count = CHANNELS[32'(port)*32 +: 32];
  wire [31:0] input_words = (channel_count + LANES-1) / LANES;
  wire capture = !rst && !sending && in_valid[port];
  wire [LANES*8-1:0] mapped_ports [0:INPUTS-1];
  wire [LANES*8-1:0] selected_data = mapped_ports[port];
  assign in_ready = !rst && !sending ? INPUTS'(1) << port : INPUTS'(0);
  assign out_valid = !rst && sending;
  reg [7:0] lookup [0:TABLE_COUNT*256-1];
  integer address;
  initial for (address = 0; address < TABLE_COUNT*256; address = address + 1)
    lookup[address] = TABLES[address*8 +: 8];
  function integer offset_for(input integer selected_port);
    integer preceding;
    begin
      offset_for = 0;
      for (preceding = 0; preceding < selected_port; preceding = preceding + 1)
        offset_for = offset_for + 32'(CHANNELS[preceding*32 +: 32]);
    end
  endfunction
  genvar input_port, lane;
  generate for (input_port = 0; input_port < INPUTS; input_port = input_port + 1) begin: scale
    localparam integer PORT_CHANNELS = 32'(CHANNELS[input_port*32 +: 32]);
    localparam [PORT_CHANNELS*TABLE_BITS-1:0] PORT_TABLES =
      CHANNEL_TABLES[offset_for(input_port)*TABLE_BITS +: PORT_CHANNELS*TABLE_BITS];
    for (lane = 0; lane < LANES; lane = lane + 1) begin: map
      wire [TABLE_BITS-1:0] table_index = PORT_TABLES[(32'(input_word)*LANES+lane)*TABLE_BITS +: TABLE_BITS];
      wire [7:0] value = in_data[(input_port*LANES+lane)*8 +: 8];
      assign mapped_ports[input_port][lane*8 +: 8] = lookup[32'(table_index)*256 + 32'(value)];
    end
  end
  for (lane = 0; lane < LANES; lane = lane + 1) begin: store
    wire [31:0] channel = 32'(channel_offset) + 32'(input_word)*LANES + lane;
    always @(posedge clk)
      if (capture && 32'(input_word)*LANES+lane < channel_count) pixel[channel] <= selected_data[lane*8 +: 8];
  end endgenerate
  integer output_lane;
  always @* begin
    out_data = 0;
    for (output_lane = 0; output_lane < LANES; output_lane = output_lane + 1)
      if (32'(output_word)*LANES+output_lane < OUTPUT_CHANNELS)
        out_data[output_lane*8 +: 8] = pixel[32'(output_word)*LANES+output_lane];
  end
  always @(posedge clk) begin
    if (rst) begin
      sending <= 0;
      port <= 0;
      input_word <= 0;
      output_word <= 0;
      channel_offset <= 0;
    end else begin
      if (capture) begin
        if (32'(input_word) == input_words-1) begin
          input_word <= 0;
          if (port == PORT_BITS'(INPUTS-1)) begin
            port <= 0;
            channel_offset <= 0;
            sending <= 1;
          end else begin
            port <= port + 1'b1;
            channel_offset <= channel_offset + CHANNEL_BITS'(channel_count);
          end
        end else input_word <= input_word + 1'b1;
      end
      if (sending && out_ready) begin
        if (output_word == WORD_BITS'(OUTPUT_WORDS-1)) begin
          output_word <= 0;
          sending <= 0;
        end else output_word <= output_word + 1'b1;
      end
    end
  end
endmodule
