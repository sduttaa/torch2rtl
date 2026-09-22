// Independent raster writer and window reader share one bounded circular RAM.
// Spare capacity accepts future words while the actor computes its live window.
module raster_window #(
  parameter integer HEIGHT=1, WIDTH=1, CHANNELS=1,
  parameter integer KERNEL_H=1, KERNEL_W=1, STRIDE_H=1, STRIDE_W=1,
  parameter integer DILATION_H=1, DILATION_W=1, PAD_H=0, PAD_W=0,
  parameter integer LANES=1, BITS=8,
  parameter [BITS-1:0] PADDING_VALUE=0,
  parameter MEMORY_STYLE="auto",
  parameter integer PACKED_LINES=0, PIPELINED_READ=0, ALTERNATE_READ=0, STARTUP_READ=0,
  localparam integer CHANNEL_WORDS=(CHANNELS+LANES-1)/LANES,
  localparam integer WORD_BITS=LANES*BITS,
  localparam integer STORAGE_BITS=(CHANNELS<LANES ? CHANNELS : LANES)*BITS,
  localparam integer EFFECTIVE_H=(KERNEL_H-1)*DILATION_H+1,
  localparam integer EFFECTIVE_W=(KERNEL_W-1)*DILATION_W+1,
  localparam integer PADDED_H=HEIGHT+2*PAD_H, PADDED_W=WIDTH+2*PAD_W,
  localparam integer OUTPUT_H=(PADDED_H-EFFECTIVE_H)/STRIDE_H+1,
  localparam integer OUTPUT_W=(PADDED_W-EFFECTIVE_W)/STRIDE_W+1,
  localparam integer FRAME_WORDS=PADDED_H*PADDED_W*CHANNEL_WORDS,
  localparam integer SPAN=((EFFECTIVE_H-1)*PADDED_W+EFFECTIVE_W)*CHANNEL_WORDS,
  localparam integer DEPTH=1<<$clog2(SPAN),
  localparam integer INDEX_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH),
  localparam integer SEQUENCE_BITS=$clog2(FRAME_WORDS+DEPTH+1)+1,
  localparam integer WINDOW_WORDS=KERNEL_H*KERNEL_W*CHANNEL_WORDS,
  localparam integer WINDOW_BITS=WINDOW_WORDS<=1 ? 1 : $clog2(WINDOW_WORDS),
  localparam integer X_BITS=PADDED_W<=1 ? 1 : $clog2(PADDED_W),
  localparam integer Y_BITS=PADDED_H<=1 ? 1 : $clog2(PADDED_H),
  localparam integer CHANNEL_BITS=CHANNEL_WORDS<=1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer OUTPUT_X_BITS=OUTPUT_W<=1 ? 1 : $clog2(OUTPUT_W),
  localparam integer OUTPUT_Y_BITS=OUTPUT_H<=1 ? 1 : $clog2(OUTPUT_H)
) (
  input wire clk, rst,
  input wire [WORD_BITS-1:0] in_data, input wire in_valid, output wire in_ready,
  output wire window_available, input wire release_window,
  input wire [WINDOW_BITS-1:0] window_address, alternate_address, first_address,
  input wire select_alternate, select_first,
  output wire [WORD_BITS-1:0] window_data
);
  localparam signed [SEQUENCE_BITS-1:0] CAPACITY=SEQUENCE_BITS'(DEPTH), LIVE_WORDS=SEQUENCE_BITS'(SPAN);
  localparam integer COLUMN_STEP=STRIDE_W*CHANNEL_WORDS;
  localparam integer ROW_STEP=STRIDE_H*PADDED_W*CHANNEL_WORDS-(OUTPUT_W-1)*COLUMN_STEP;
  localparam integer FRAME_STEP=FRAME_WORDS-(OUTPUT_H-1)*STRIDE_H*PADDED_W*CHANNEL_WORDS-(OUTPUT_W-1)*COLUMN_STEP;
  reg [INDEX_BITS-1:0] written, origin;
  // Count issued words relative to the oldest live word directly. Computing
  // this from two pointers put subtraction, pending-write addition and a
  // comparison in series on upstream ready. The registered count removes
  // that arithmetic from both ready and window-availability paths.
  reg signed [SEQUENCE_BITS-1:0] reserved;
  reg [X_BITS-1:0] column;
  reg [Y_BITS-1:0] row;
  reg [CHANNEL_BITS-1:0] channel_word;
  reg [OUTPUT_X_BITS-1:0] output_column;
  reg [OUTPUT_Y_BITS-1:0] output_row;
  reg pending;
  reg [STORAGE_BITS-1:0] pending_data;
  wire last_column=output_column==OUTPUT_X_BITS'(OUTPUT_W-1);
  wire last_row=output_row==OUTPUT_Y_BITS'(OUTPUT_H-1);
  wire [INDEX_BITS-1:0] advance=last_column ?
    (last_row ? INDEX_BITS'(FRAME_STEP) : INDEX_BITS'(ROW_STEP)) : INDEX_BITS'(COLUMN_STEP);
  wire row_padding, column_padding;
  wire final_channel=channel_word==CHANNEL_BITS'(CHANNEL_WORDS-1);
  wire final_column=column==X_BITS'(PADDED_W-1);
  wire padding=row_padding || column_padding;
  wire can_issue=!rst && reserved<CAPACITY;
  wire issue=can_issue && (padding || in_valid);
  // Padding changes only at fixed raster boundaries. Remember the region
  // instead of putting relational counter comparisons on upstream ready.
  generate
    if(PAD_H==0) assign row_padding=1'b0;
    else begin: padded_rows
      reg active;
      assign row_padding=active;
      always @(posedge clk) begin
        if(rst) active<=1;
        else if(issue && final_channel && final_column) begin
          if(row==Y_BITS'(PAD_H-1)) active<=0;
          else if(row==Y_BITS'(PAD_H+HEIGHT-1)) active<=1;
        end
      end
    end
    if(PAD_W==0) assign column_padding=1'b0;
    else begin: padded_columns
      reg active;
      assign column_padding=active;
      always @(posedge clk) begin
        if(rst) active<=1;
        else if(issue && final_channel) begin
          if(column==X_BITS'(PAD_W-1)) active<=0;
          else if(column==X_BITS'(PAD_W+WIDTH-1)) active<=1;
        end
      end
    end
  endgenerate
  assign in_ready=can_issue && !padding;
  // Pending data has reserved its slot but reaches RAM on the next edge.
  // The count stays between -FRAME_WORDS and DEPTH under the release contract,
  // so these constant comparisons preserve the signed subtraction exactly.
  assign window_available=!rst && (reserved>LIVE_WORDS || (reserved==LIVE_WORDS && !pending));
  // Select constant increments before one adder; do not chain subtraction and
  // increment in the feedback path. Issuing and releasing may share an edge.
  wire signed [SEQUENCE_BITS-1:0] change=release_window ?
    (last_column ? (last_row ? (issue ? SEQUENCE_BITS'(1-FRAME_STEP) : SEQUENCE_BITS'(-FRAME_STEP)) :
                              (issue ? SEQUENCE_BITS'(1-ROW_STEP) : SEQUENCE_BITS'(-ROW_STEP))) :
                   (issue ? SEQUENCE_BITS'(1-COLUMN_STEP) : SEQUENCE_BITS'(-COLUMN_STEP))) : SEQUENCE_BITS'(issue);
  wire [STORAGE_BITS-1:0] issue_data;
  genvar lane;
  generate for(lane=0;lane<(CHANNELS<LANES ? CHANNELS : LANES);lane=lane+1) begin: input_lane
    assign issue_data[lane*BITS +: BITS]=32'(channel_word)*LANES+lane>=CHANNELS ? BITS'(0) :
      padding ? PADDING_VALUE : in_data[lane*BITS +: BITS];
  end endgenerate
  always @(posedge clk) begin
    if(rst) begin
      written<=0; origin<=0; pending<=0; reserved<=0;
      column<=0; row<=0; channel_word<=0;
      output_column<=0; output_row<=0;
    end else begin
      pending<=issue;
      reserved<=reserved+change;
      if(pending) written<=written+1'b1;
      if(issue) begin
        pending_data<=issue_data;
        if(final_channel) begin
          channel_word<=0;
          if(final_column) begin
            column<=0;
            row<=row==Y_BITS'(PADDED_H-1) ? Y_BITS'(0) : row+1'b1;
          end else column<=column+1'b1;
        end else channel_word<=channel_word+1'b1;
      end
      if(release_window) begin
        origin<=origin+advance;
        if(last_column) begin
          output_column<=0;
          if(last_row) begin
            output_row<=0;
          end else begin
            output_row<=output_row+1'b1;
          end
        end else begin
          output_column<=output_column+1'b1;
        end
      end
    end
  end
  wire [INDEX_BITS-1:0] write_location=DEPTH==1 ? INDEX_BITS'(0) : written[INDEX_BITS-1:0];
  wire [INDEX_BITS-1:0] read_origin=DEPTH==1 ? INDEX_BITS'(0) : origin[INDEX_BITS-1:0];
  wire [INDEX_BITS-1:0] coordinates [0:WINDOW_WORDS-1];
  genvar y,x,word;
  generate for(y=0;y<KERNEL_H;y=y+1) begin: row_coordinate
    for(x=0;x<KERNEL_W;x=x+1) begin: column_coordinate
      for(word=0;word<CHANNEL_WORDS;word=word+1) begin: channel_coordinate
        assign coordinates[(y*KERNEL_W+x)*CHANNEL_WORDS+word]=
          INDEX_BITS'((y*DILATION_H*PADDED_W+x*DILATION_W)*CHANNEL_WORDS+word);
      end
    end
  end endgenerate
  wire [INDEX_BITS-1:0] read_location;
  wire [STORAGE_BITS-1:0] stored_data;
  window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(@BANK_WIDTH@),
    .PIPELINED_READ(PIPELINED_READ),.MEMORY_STYLE(MEMORY_STYLE)) storage (
    .clk(clk),.write_enable(!rst && pending),.write_address(write_location),
    .write_data(pending_data),.read_address(read_location),.read_data(stored_data));
  generate if(PIPELINED_READ!=0) begin: pipelined
    reg [INDEX_BITS-1:0] requested,first,alternate;
    reg use_first,use_alternate,forwarded;
    reg [STORAGE_BITS-1:0] forwarded_data;
    wire [INDEX_BITS-1:0] offset=ALTERNATE_READ!=0 && use_alternate ? alternate :
      STARTUP_READ!=0 && use_first ? first : requested;
    assign read_location=DEPTH==1 ? INDEX_BITS'(0) : read_origin+offset;
    always @(posedge clk) begin
      requested<=coordinates[window_address];
      first<=coordinates[first_address];
      alternate<=coordinates[alternate_address];
      use_first<=select_first;
      use_alternate<=select_alternate;
      forwarded<=!rst && pending && write_location==read_location;
      forwarded_data<=pending_data;
    end
    assign window_data=WORD_BITS'(forwarded ? forwarded_data : stored_data);
  end else begin: asynchronous
    assign read_location=DEPTH==1 ? INDEX_BITS'(0) : read_origin+coordinates[window_address];
    assign window_data=WORD_BITS'(stored_data);
  end endgenerate
endmodule
