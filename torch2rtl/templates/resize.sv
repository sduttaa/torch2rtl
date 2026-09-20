// Nearest-neighbor resampling retains one source row. Static coordinate maps
// preserve the frontend's exact nearest/nearest-exact and scale-factor rules.
module integer_nearest #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer OUTPUT_HEIGHT = 1, OUTPUT_WIDTH = 1,
  parameter integer LANES = 1, BITS = 8,
  parameter MEMORY_STYLE = "auto",
  localparam integer ROW_BITS = HEIGHT <= 1 ? 1 : $clog2(HEIGHT),
  localparam integer COLUMN_BITS = WIDTH <= 1 ? 1 : $clog2(WIDTH),
  localparam integer OUTPUT_ROW_BITS = OUTPUT_HEIGHT <= 1 ? 1 : $clog2(OUTPUT_HEIGHT),
  localparam integer OUTPUT_COLUMN_BITS = OUTPUT_WIDTH <= 1 ? 1 : $clog2(OUTPUT_WIDTH),
  localparam integer CHANNEL_WORDS = (CHANNELS + LANES - 1) / LANES,
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer ROW_WORDS = WIDTH * CHANNEL_WORDS,
  localparam integer ADDRESS_BITS = ROW_WORDS <= 1 ? 1 : $clog2(ROW_WORDS),
  parameter [OUTPUT_HEIGHT*ROW_BITS-1:0] ROW_INDICES = 0,
  parameter [OUTPUT_WIDTH*COLUMN_BITS-1:0] COLUMN_INDICES = 0
) (
  input wire clk, input wire rst,
  input wire [LANES*BITS-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*BITS-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg reading, output_pending, frame_done;
  reg [ROW_BITS-1:0] input_row;
  reg [OUTPUT_ROW_BITS-1:0] output_row;
  reg [OUTPUT_COLUMN_BITS-1:0] output_column;
  reg [ADDRESS_BITS-1:0] write_address;
  reg [CHANNEL_BITS-1:0] write_channel, read_channel;
  wire [ROW_BITS-1:0] selected_row = ROW_INDICES[32'(output_row)*ROW_BITS +: ROW_BITS];
  wire [ROW_BITS-1:0] next_row = ROW_INDICES[(32'(output_row)+1)*ROW_BITS +: ROW_BITS];
  wire [COLUMN_BITS-1:0] selected_column = COLUMN_INDICES[32'(output_column)*COLUMN_BITS +: COLUMN_BITS];
  wire [ADDRESS_BITS-1:0] read_address = ADDRESS_BITS'(32'(selected_column)*CHANNEL_WORDS + 32'(read_channel));
  wire issue = !rst && reading && (!output_pending || out_ready);
  assign in_ready = !rst && !reading;
  assign out_valid = !rst && output_pending;
  reg [LANES*BITS-1:0] masked_input;
  integer lane;
  always @* begin
    masked_input = 0;
    for (lane = 0; lane < LANES; lane = lane + 1)
      if (32'(write_channel)*LANES+lane < CHANNELS)
        masked_input[lane*BITS +: BITS] = in_data[lane*BITS +: BITS];
  end
  (* ram_style = MEMORY_STYLE *) reg [LANES*BITS-1:0] memory [0:ROW_WORDS-1];
  always @(posedge clk) begin
    if (in_valid && in_ready) memory[write_address] <= masked_input;
    if (issue) out_data <= memory[read_address];
  end
  always @(posedge clk) begin
    if (rst) begin
      reading <= 0;
      output_pending <= 0;
      frame_done <= 0;
      input_row <= 0;
      output_row <= 0;
      output_column <= 0;
      write_address <= 0;
      write_channel <= 0;
      read_channel <= 0;
    end else begin
      if (out_ready) output_pending <= 0;
      if (in_valid && in_ready) begin
        write_channel <= write_channel == CHANNEL_BITS'(CHANNEL_WORDS-1) ? CHANNEL_BITS'(0) : write_channel + 1'b1;
        if (write_address == ADDRESS_BITS'(ROW_WORDS-1)) begin
          write_address <= 0;
          if (!frame_done && input_row == selected_row) reading <= 1;
          else if (input_row == ROW_BITS'(HEIGHT-1)) begin
            input_row <= 0;
            output_row <= 0;
            frame_done <= 0;
          end else input_row <= input_row + 1'b1;
        end else write_address <= write_address + 1'b1;
      end
      if (issue) begin
        output_pending <= 1;
        if (read_channel == CHANNEL_BITS'(CHANNEL_WORDS-1)) begin
          read_channel <= 0;
          if (output_column == OUTPUT_COLUMN_BITS'(OUTPUT_WIDTH-1)) begin
            output_column <= 0;
            if (output_row == OUTPUT_ROW_BITS'(OUTPUT_HEIGHT-1)) begin
              reading <= 0;
              output_row <= 0;
              if (input_row == ROW_BITS'(HEIGHT-1)) begin
                input_row <= 0;
                frame_done <= 0;
              end else begin
                input_row <= input_row + 1'b1;
                frame_done <= 1;
              end
            end else begin
              output_row <= output_row + 1'b1;
              if (next_row != input_row) begin
                reading <= 0;
                input_row <= input_row + 1'b1;
              end
            end
          end else output_column <= output_column + 1'b1;
        end else read_channel <= read_channel + 1'b1;
      end
    end
  end
endmodule
