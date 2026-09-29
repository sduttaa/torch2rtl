// Compact source rows for an exact static resize/concatenate view. Data is
// stored at the smaller proven width. Exact scale alignment happens on write
// or read; row lifetimes prevent overwriting values still used by a window.
module view_rows #(
  parameter integer OUTPUT_HEIGHT=1, OUTPUT_WIDTH=1, KERNEL_H=1, KERNEL_W=1,
  parameter integer LANES=1, BITS=8, CHANNELS=1, TOTAL_CHANNEL_WORDS=1, WORD_OFFSET=0,
  parameter integer OUTPUT_BITS=BITS, QUANTIZE_ON_READ=0, SOURCE_SIGNED=0,
  parameter integer WORDS=1, DEPTH=1,
  parameter MEMORY_STYLE="auto",
  localparam integer CHANNEL_WORDS=(CHANNELS+LANES-1)/LANES,
  localparam integer STORED_LANES=CHANNELS < LANES ? CHANNELS : LANES,
  localparam integer ADDRESS_BITS=DEPTH <= 1 ? 1 : $clog2(DEPTH),
  parameter integer CROSS_FRAME=0,
  localparam integer COUNT_BITS=$clog2(WORDS+(CROSS_FRAME != 0 ? DEPTH : 0)+1),
  localparam integer CHANNEL_BITS=CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer Y_BITS=OUTPUT_HEIGHT <= 1 ? 1 : $clog2(OUTPUT_HEIGHT),
  localparam integer X_BITS=OUTPUT_WIDTH <= 1 ? 1 : $clog2(OUTPUT_WIDTH),
  localparam integer WINDOW_WORDS=KERNEL_H*KERNEL_W*TOTAL_CHANNEL_WORDS,
  localparam integer WINDOW_BITS=WINDOW_WORDS <= 1 ? 1 : $clog2(WINDOW_WORDS),
  parameter integer GROUP_INPUTS=LANES, GROUP_WORDS=1, SUBWORDS=1, TILES=1, BLOCKS=1,
  localparam integer DOT_STEPS=KERNEL_H*KERNEL_W*GROUP_WORDS,
  localparam integer STEP_BITS=DOT_STEPS <= 1 ? 1 : $clog2(DOT_STEPS),
  localparam integer BLOCK_BITS=BLOCKS <= 1 ? 1 : $clog2(BLOCKS),
  localparam integer REQUEST_BITS=STEP_BITS+(BLOCKS == TILES ? 0 : BLOCK_BITS),
  localparam integer REQUESTS=1 << REQUEST_BITS,
  parameter integer TABLE_COUNT=1,
  parameter integer ROW_WORDS=1, LAST_USED_COLUMN=OUTPUT_WIDTH-1, FIRST_COLUMN=0,
  localparam integer TABLE_BITS=TABLE_COUNT <= 1 ? 1 : $clog2(TABLE_COUNT),
  localparam integer TABLE_INDEX_BITS=$clog2(TABLE_COUNT*256),
  parameter [OUTPUT_HEIGHT*KERNEL_H*ADDRESS_BITS-1:0] ROW_ADDRESSES=0,
  parameter [OUTPUT_WIDTH*KERNEL_W*ADDRESS_BITS-1:0] COLUMN_ADDRESSES=0,
  parameter [KERNEL_W-1:0] COLUMN_AFFINE=0,
  parameter [KERNEL_W*3-1:0] COLUMN_SHIFTS=0,
  parameter [KERNEL_W*ADDRESS_BITS-1:0] COLUMN_STEPS=0,
  parameter [16*KERNEL_W*ADDRESS_BITS-1:0] COLUMN_BASES=0,
  parameter [OUTPUT_HEIGHT*KERNEL_H-1:0] ROW_VALID=0,
  parameter [OUTPUT_WIDTH*KERNEL_W-1:0] COLUMN_VALID=0,
  parameter [OUTPUT_HEIGHT*COUNT_BITS-1:0] REQUIRED_ROWS=0, LIMITS=0,
  parameter [OUTPUT_HEIGHT-1:0] RELEASE_COLUMNS=0,
  parameter [OUTPUT_HEIGHT-1:0] VALID_ROWS=0,
  parameter [CHANNELS*TABLE_BITS-1:0] CHANNEL_TABLES=0,
  parameter [TABLE_COUNT*256*OUTPUT_BITS-1:0] TABLES=0
) (
  input wire clk, rst, advance_frame, done,
  input wire release_window,
  input wire [Y_BITS-1:0] output_row,
  input wire [X_BITS-1:0] output_column,
  input wire [LANES*8-1:0] in_data, input wire in_valid, output wire in_ready,
  output wire ready, finished,
  input wire [REQUEST_BITS-1:0] request, alternate_request, first_request,
  input wire select_alternate, active_dot,
  output wire [LANES*OUTPUT_BITS-1:0] window_data
);
  reg [COUNT_BITS-1:0] written;
  reg [ADDRESS_BITS-1:0] write_address;
  reg [CHANNEL_BITS-1:0] write_channel;
  wire [KERNEL_W-1:0] column_included;
  wire [KERNEL_H-1:0] row_included;
  // Control tables must remain combinational logic. Inferring block ROMs here
  // consumes data-storage blocks without increasing the actor's bandwidth.
  (* rom_style="logic" *) reg [2*COUNT_BITS:0] row_contract [0:OUTPUT_HEIGHT-1];
  integer position;
  initial begin
    for (position=0; position<OUTPUT_HEIGHT; position=position+1)
      row_contract[position]={RELEASE_COLUMNS[position],LIMITS[position*COUNT_BITS +: COUNT_BITS],REQUIRED_ROWS[position*COUNT_BITS +: COUNT_BITS]};
  end
  reg [2*COUNT_BITS:0] row_state;
  // The output-row register resets at frame advance. The existing validity
  // pipeline masks the old row while this ROM settles, keeping frame-complete
  // comparisons and cross-input advance control off the lookup address path.
  reg [ADDRESS_BITS-1:0] last_column;
  reg [COUNT_BITS-1:0] required_words;
  reg source_needed;
  reg [1:0] coordinates_valid;
  reg [1:0] frame_valid;
  reg [COUNT_BITS:0] allowed_words;
  reg [COUNT_BITS-1:0] first_column;
  assign ready=coordinates_valid[1] && (!source_needed || written >= required_words);
  always @(posedge clk) begin
    row_state <= row_contract[output_row];
    required_words <= row_state[0 +: COUNT_BITS]+COUNT_BITS'(last_column)+COUNT_BITS'(CHANNEL_WORDS);
    source_needed <= (|row_included) && (|column_included);
    if (CROSS_FRAME != 0 && (rst || advance_frame)) allowed_words <= (COUNT_BITS+1)'(DEPTH);
    else if (CROSS_FRAME != 0 && done) allowed_words <= (COUNT_BITS+1)'(WORDS+DEPTH);
    else if (CROSS_FRAME == 0 || frame_valid[1])
      allowed_words <= {1'b0,row_state[COUNT_BITS +: COUNT_BITS]}+
                       (row_state[2*COUNT_BITS] ? {1'b0,first_column} : (COUNT_BITS+1)'(0));
    if (rst || advance_frame) frame_valid <= 0;
    else frame_valid <= {frame_valid[0],1'b1};
    if (rst || advance_frame || release_window) coordinates_valid <= 0;
    else coordinates_valid <= {coordinates_valid[0],1'b1};
  end
  assign finished=written >= COUNT_BITS'(WORDS);
  assign in_ready=!rst && (CROSS_FRAME != 0 ? {1'b0,written} < allowed_words :
                          frame_valid[1] && !finished && (done || {1'b0,written} < allowed_words));
  wire capture=in_valid && in_ready;
  (* rom_style="logic" *) reg [OUTPUT_BITS-1:0] lookup [0:TABLE_COUNT*256-1];
  wire [TABLE_BITS-1:0] channel_tables [0:CHANNELS-1];
  integer entry;
  initial for (entry=0; entry<TABLE_COUNT*256; entry=entry+1)
    lookup[entry]=TABLES[entry*OUTPUT_BITS +: OUTPUT_BITS];
  genvar table_channel;
  generate for (table_channel=0; table_channel<CHANNELS; table_channel=table_channel+1) begin: channel_table
    assign channel_tables[table_channel]=CHANNEL_TABLES[table_channel*TABLE_BITS +: TABLE_BITS];
  end endgenerate
  reg [STORED_LANES*BITS-1:0] mapped_data;
  integer lane, channel;
  always @* begin
    mapped_data=0;
    for (lane=0; lane<STORED_LANES; lane=lane+1) begin
      channel=32'(write_channel)*LANES+lane;
      if (channel < CHANNELS)
        mapped_data[lane*BITS +: BITS]=QUANTIZE_ON_READ != 0 ? in_data[lane*8 +: BITS] :
                                      BITS'(lookup[TABLE_INDEX_BITS'({channel_tables[channel],in_data[lane*8 +: 8]})]);
    end
  end
  // All divisions and coordinate factoring occur at elaboration. Runtime
  // address algebra previously inferred wide divider/multiplier networks.
  wire [ADDRESS_BITS-1:0] row_taps [0:KERNEL_H-1], column_taps [0:KERNEL_W-1];
  // Coordinate maps are monotone. The last included tap is also the last
  // required source word, so readiness can reuse the address computation.
  integer tap;
  always @* begin
    last_column=0;
    for (tap=0; tap<KERNEL_W; tap=tap+1)
      if (column_included[tap]) last_column=column_taps[tap];
  end
  integer first_tap;
  always @* begin
    first_column=32'(output_column) > LAST_USED_COLUMN ? COUNT_BITS'(ROW_WORDS) : COUNT_BITS'(FIRST_COLUMN);
    for (first_tap=KERNEL_W-1; first_tap>=0; first_tap=first_tap-1)
      if (column_included[first_tap]) first_column=COUNT_BITS'(column_taps[first_tap]);
  end
  localparam integer COORD_BITS=2*ADDRESS_BITS+CHANNEL_BITS+1;
  wire [COORD_BITS-2:0] coordinates [0:REQUESTS-1];
  wire [REQUESTS-1:0] included_rows, included_columns, included_channels;
  genvar ky,kx,y,x,word;
  generate
    for (ky=0; ky<KERNEL_H; ky=ky+1) begin: row_tap
      wire [ADDRESS_BITS-1:0] locations [0:OUTPUT_HEIGHT-1];
      wire [OUTPUT_HEIGHT-1:0] included;
      for (y=0; y<OUTPUT_HEIGHT; y=y+1) begin: coordinate
        assign locations[y]=ROW_ADDRESSES[(y*KERNEL_H+ky)*ADDRESS_BITS +: ADDRESS_BITS];
        assign included[y]=ROW_VALID[y*KERNEL_H+ky];
      end
      reg [ADDRESS_BITS-1:0] location;
      reg present;
      always @(posedge clk) begin
        location <= locations[output_row];
        present <= included[output_row];
      end
      assign row_taps[ky]=location;
      assign row_included[ky]=present;
    end
    for (kx=0; kx<KERNEL_W; kx=kx+1) begin: column_tap
      wire [ADDRESS_BITS-1:0] locations [0:OUTPUT_WIDTH-1];
      wire [OUTPUT_WIDTH-1:0] included;
      reg [ADDRESS_BITS-1:0] location;
      reg present;
      for (x=0; x<OUTPUT_WIDTH; x=x+1) begin: coordinate
        assign locations[x]=COLUMN_ADDRESSES[(x*KERNEL_W+kx)*ADDRESS_BITS +: ADDRESS_BITS];
        assign included[x]=COLUMN_VALID[x*KERNEL_W+kx];
      end
      if (COLUMN_AFFINE[kx]) begin: affine
        localparam integer SHIFT=32'(COLUMN_SHIFTS[kx*3 +: 3]);
        localparam [ADDRESS_BITS-1:0] STEP=COLUMN_STEPS[kx*ADDRESS_BITS +: ADDRESS_BITS];
        wire [ADDRESS_BITS-1:0] bases [0:(1<<SHIFT)-1];
        for (x=0; x<(1<<SHIFT); x=x+1) begin: base
          assign bases[x]=COLUMN_BASES[(kx*16+x)*ADDRESS_BITS +: ADDRESS_BITS];
        end
        always @(posedge clk) location <= ADDRESS_BITS'((32'(output_column)>>SHIFT)*32'(STEP))+
                                             bases[32'(output_column)% (1<<SHIFT)];
      end else always @(posedge clk) location <= locations[output_column];
      always @(posedge clk) present <= included[output_column];
      assign column_taps[kx]=location;
      assign column_included[kx]=present;
    end
    // Compose both constant maps. Padding unreachable requests to powers of
    // two makes the runtime index a concatenation of existing registers.
    for (word=0; word<REQUESTS; word=word+1) begin: coordinate
      localparam integer BLOCK=BLOCKS == TILES ? 0 : word >> STEP_BITS;
      localparam integer STEP=word % (1 << STEP_BITS);
      localparam integer WINDOW=(STEP/GROUP_WORDS)*TOTAL_CHANNEL_WORDS+
                                (STEP%GROUP_WORDS)/SUBWORDS+(BLOCK/TILES)*(GROUP_INPUTS/LANES);
      localparam integer Y=WINDOW/(KERNEL_W*TOTAL_CHANNEL_WORDS);
      localparam integer X=(WINDOW/TOTAL_CHANNEL_WORDS)%KERNEL_W;
      localparam integer CHANNEL=WINDOW%TOTAL_CHANNEL_WORDS;
      // Out-of-range requests have the same undefined value as the original
      // array reads. They must not add validity logic to reachable requests.
      if (BLOCK >= BLOCKS || STEP >= DOT_STEPS) begin: unused
        assign coordinates[word]='x;
        assign included_rows[word]=1'bx;
        assign included_columns[word]=1'bx;
        assign included_channels[word]=1'bx;
      end else begin: present
        // Only validity depends on which concatenated branch owns a word.
        // Invalid coordinates never read RAM and their output is masked to
        // zero, so gating every address bit adds needless decode depth.
        localparam INCLUDED=CHANNEL >= WORD_OFFSET && CHANNEL < WORD_OFFSET+CHANNEL_WORDS;
        assign coordinates[word]={CHANNEL_BITS'(CHANNEL-WORD_OFFSET),row_taps[Y],column_taps[X]};
        assign included_rows[word]=row_included[Y];
        assign included_columns[word]=column_included[X];
        assign included_channels[word]=INCLUDED;
      end
    end
  endgenerate
  function automatic [COORD_BITS-1:0] select_coordinates(input [REQUEST_BITS-1:0] address);
    // Factor validity after coordinate selection instead of distributing its
    // three-way conjunction across every entry in the address multiplexer.
    select_coordinates={included_rows[address] && included_columns[address] && included_channels[address],coordinates[address]};
  endfunction
  reg [COORD_BITS-1:0] requested, alternate;
  reg selected, valid;
  reg [CHANNEL_BITS-1:0] read_channel;
  wire [COORD_BITS-1:0] active=selected ? alternate : requested;
  // Select and register coordinates first, then add at the RAM address.
  // This preserves the two-edge contract and avoids an adder before a large
  // window-word mux on the same combinational path as the coordinate tables.
  wire [ADDRESS_BITS-1:0] read_location=active[0 +: ADDRESS_BITS]+active[ADDRESS_BITS +: ADDRESS_BITS]+
                                      ADDRESS_BITS'(active[2*ADDRESS_BITS +: CHANNEL_BITS]);
  (* ram_style=MEMORY_STYLE, no_rw_check *) reg [STORED_LANES*BITS-1:0] memory [0:DEPTH-1];
  reg [STORED_LANES*BITS-1:0] read_data;
  always @(posedge clk) begin
    // Select startup after decoding, keeping the actor-state signal out of
    // the prefetch address and its large coordinate multiplexer.
    requested <= active_dot ? select_coordinates(request) : select_coordinates(first_request);
    alternate <= select_coordinates(alternate_request);
    selected <= select_alternate;
    valid <= active[COORD_BITS-1];
    read_channel <= active[2*ADDRESS_BITS +: CHANNEL_BITS];
    if (active[COORD_BITS-1]) read_data <= memory[read_location];
    if (capture) memory[write_address] <= mapped_data;
  end
  genvar output_lane;
  generate for (output_lane=0; output_lane<LANES; output_lane=output_lane+1) begin: output_value
    if (output_lane < STORED_LANES) begin: present
      wire [7:0] raw_value=SOURCE_SIGNED != 0 ? 8'($signed(read_data[output_lane*BITS +: BITS])) :
                                             8'(read_data[output_lane*BITS +: BITS]);
      wire [31:0] channel=32'(read_channel)*LANES+output_lane;
      wire [OUTPUT_BITS-1:0] result=QUANTIZE_ON_READ != 0 ? lookup[TABLE_INDEX_BITS'({channel_tables[channel],raw_value})] :
                                      OUTPUT_BITS'(read_data[output_lane*BITS +: BITS]);
      assign window_data[output_lane*OUTPUT_BITS +: OUTPUT_BITS]=valid && (QUANTIZE_ON_READ == 0 || channel < CHANNELS) ? result : OUTPUT_BITS'(0);
    end else assign window_data[output_lane*OUTPUT_BITS +: OUTPUT_BITS]=0;
  end endgenerate
  always @(posedge clk) begin
    if (rst) begin
      written <= 0;
      write_address <= 0;
      write_channel <= 0;
    end else begin
      if (advance_frame)
        written <= CROSS_FRAME != 0 ? written-COUNT_BITS'(WORDS)+COUNT_BITS'(capture) : COUNT_BITS'(0);
      else if (capture) written <= written+1'b1;
      if (advance_frame && CROSS_FRAME == 0) begin
        write_address <= 0;
        write_channel <= 0;
      end else if (capture) begin
        write_address <= write_address == ADDRESS_BITS'(DEPTH-1) ? ADDRESS_BITS'(0) : write_address+1'b1;
        write_channel <= write_channel == CHANNEL_BITS'(CHANNEL_WORDS-1) ? CHANNEL_BITS'(0) : write_channel+1'b1;
      end
    end
  end
endmodule
