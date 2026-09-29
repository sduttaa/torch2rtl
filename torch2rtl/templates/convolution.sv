// Folded integer convolution. Quantization either reuses dot multipliers,
// searches exact thresholds, or runs in an independent overlapping stage.
module integer_convolution #(
  parameter integer HEIGHT = 1, WIDTH = 1,
  parameter integer INPUT_CHANNELS = 1, OUTPUT_CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer POOL_H = 1, POOL_W = 1,
  parameter integer STRIDE_H = 1, STRIDE_W = 1,
  parameter integer DILATION_H = 1, DILATION_W = 1,
  parameter integer PAD_H = 0, PAD_W = 0, GROUPS = 1,
  parameter integer LANES = 1, OUTPUT_LANES = 1, INPUT_SIGNED = 0,
  parameter integer INPUT_BITS = 8, OUTPUT_ELEMENT_BITS = 8, OUTPUT_SIGNED = 0,
  parameter integer WEIGHT_BITS = 8,
  parameter integer REDUCTION_LANES = LANES,
  parameter integer ACCUMULATOR_BYTES = 4, MULTIPLIER_BYTES = 8,
  parameter integer MULTIPLIER_BITS = MULTIPLIER_BYTES * 8,
  parameter integer ACCUMULATOR_BITS = ACCUMULATOR_BYTES * 8,
  parameter integer INNER_BITS = MULTIPLIER_BYTES * 8 + 9 > 64 ? 64 : MULTIPLIER_BYTES * 8 + 9,
  parameter integer MULTIPLIER_SIGNED = 1, REQUANT_BITS = 64,
  parameter integer THRESHOLD_BITS = 0,
  parameter integer OVERLAP_QUANTIZER = 0,
  parameter integer QUANTIZER_LANES = OUTPUT_LANES,
  parameter integer SHIFT = 0,
  parameter [63:0] OFFSET = 0, LOW = 0, HIGH = 255,
  parameter WEIGHT_MEMORY = "auto", LINE_MEMORY = "auto",
  parameter integer PACKED_LINES = 0, EXTERNAL_WINDOW = 0,
  localparam integer GROUP_INPUTS = INPUT_CHANNELS / GROUPS,
  localparam integer GROUP_OUTPUTS = OUTPUT_CHANNELS / GROUPS,
  localparam integer CHANNEL_WORDS = (INPUT_CHANNELS + LANES - 1) / LANES,
  localparam integer GROUP_WORDS = (GROUP_INPUTS + REDUCTION_LANES - 1) / REDUCTION_LANES,
  localparam integer SUBWORDS = LANES / REDUCTION_LANES,
  localparam integer SUBWORD_BITS = SUBWORDS <= 1 ? 1 : $clog2(SUBWORDS),
  localparam integer OUTPUT_WORDS = (OUTPUT_CHANNELS + LANES - 1) / LANES,
  localparam integer TILES = (GROUP_OUTPUTS + OUTPUT_LANES - 1) / OUTPUT_LANES,
  localparam integer BLOCKS = GROUPS * TILES,
  localparam integer DOT_STEPS = KERNEL_H * KERNEL_W * GROUP_WORDS,
  parameter integer PIPELINED_POOL = POOL_H*POOL_W > 1 && DOT_STEPS >= 4,
  localparam integer ROM_WIDTH = OUTPUT_LANES * REDUCTION_LANES * WEIGHT_BITS,
  localparam integer ROM_DEPTH = BLOCKS * DOT_STEPS,
  parameter integer WEIGHT_BLOCK_DEPTH = ROM_DEPTH,
  parameter integer LOGIC_WEIGHT_BANK_DEPTH = 64,
  localparam integer MULTIPLIER_GROUPS = (MULTIPLIER_BYTES + REDUCTION_LANES - 1) / REDUCTION_LANES,
  localparam integer COEFFICIENT_BITS = MULTIPLIER_GROUPS * REDUCTION_LANES * 8,
  localparam integer PADDED_ACCUMULATOR_BITS = ACCUMULATOR_BYTES * 8,
  parameter [ROM_WIDTH*ROM_DEPTH-1:0] WEIGHTS = 0,
  parameter [BLOCKS*OUTPUT_LANES*32-1:0] BIASES = 0,
  parameter [BLOCKS*OUTPUT_LANES*COEFFICIENT_BITS-1:0] MULTIPLIERS = 0,
  parameter [BLOCKS*OUTPUT_LANES*(1<<THRESHOLD_BITS)*(ACCUMULATOR_BITS+2)-1:0] THRESHOLDS = 0,
  parameter [OUTPUT_LANES*REDUCTION_LANES-1:0] PRODUCT_MASK = {OUTPUT_LANES*REDUCTION_LANES{1'b1}},
  parameter [OUTPUT_LANES*REDUCTION_LANES-1:0] REQUANT_MASK = {OUTPUT_LANES*REDUCTION_LANES{1'b1}},
  localparam integer BLOCK_BITS = BLOCKS <= 1 ? 1 : $clog2(BLOCKS),
  localparam integer STEP_BITS = DOT_STEPS <= 1 ? 1 : $clog2(DOT_STEPS),
  localparam integer ROM_ADDRESS_BITS = ROM_DEPTH <= 1 ? 1 : $clog2(ROM_DEPTH),
  localparam integer OUTPUT_BITS = OUTPUT_WORDS <= 1 ? 1 : $clog2(OUTPUT_WORDS),
  localparam integer BYTE_BITS = ACCUMULATOR_BYTES <= 1 ? 1 : $clog2(ACCUMULATOR_BYTES),
  localparam integer GROUP_BITS = MULTIPLIER_GROUPS <= 1 ? 1 : $clog2(MULTIPLIER_GROUPS),
  localparam integer POOL_ITEMS = POOL_H * POOL_W,
  localparam integer POOL_BITS = POOL_ITEMS <= 1 ? 1 : $clog2(POOL_ITEMS),
  localparam integer WINDOW_H = POOL_ITEMS == 1 ? KERNEL_H : (KERNEL_H-1)*DILATION_H+1+(POOL_H-1)*STRIDE_H,
  localparam integer WINDOW_W = POOL_ITEMS == 1 ? KERNEL_W : (KERNEL_W-1)*DILATION_W+1+(POOL_W-1)*STRIDE_W,
  localparam integer WINDOW_WORDS = WINDOW_H * WINDOW_W * CHANNEL_WORDS,
  localparam integer WINDOW_BITS = WINDOW_WORDS <= 1 ? 1 : $clog2(WINDOW_WORDS)
) (
  input wire clk, input wire rst,
  input wire [LANES*8-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*8-1:0] out_data, output wire out_valid, input wire out_ready,
  input wire external_available, input wire [LANES*8-1:0] external_data,
  output wire external_release,
  output wire [WINDOW_BITS-1:0] external_address, external_alternate, external_first,
  output wire [BLOCK_BITS+STEP_BITS-1:0] external_request, external_next_request, external_first_request,
  output wire external_select, external_active
);
  localparam [2:0] IDLE = 0, DOT = 1, DOT_DRAIN = 2, RQ = 3, RQ_DRAIN = 4, POST = 5, POOL_WAIT = 6;
  reg [2:0] state;
  reg [BLOCK_BITS-1:0] block;
  reg [STEP_BITS-1:0] dot_step;
  reg [POOL_BITS-1:0] pool_item;
  reg dot_bubble, prefetch_bubble;
  reg [ROM_ADDRESS_BITS-1:0] weight_address;
  reg [BYTE_BITS-1:0] accumulator_byte;
  reg [GROUP_BITS-1:0] multiplier_group;
  wire window_available;
  reg dot_last, release_after_dot;
  reg release_window;
  // Issue read coordinates two edges ahead. The existing IDLE, drain and
  // requantization cycles prime the pipeline without adding actor cycles.
  reg [BLOCK_BITS-1:0] read_block;
  reg [POOL_BITS-1:0] read_pool;
  wire starting_dot;
  // Advance before drain/requantization, keeping control off the decoder.
  reg [STEP_BITS-1:0] prefetch_step;
  always @(posedge clk) begin
    // Prepare the release pulse one edge ahead. Window readiness sees a
    // register directly, without a dot-state decoder on its control path.
    if (rst) release_window <= 0;
    else release_window <=
      (starting_dot && DOT_STEPS == 1 && read_block == BLOCK_BITS'(BLOCKS-1) && read_pool == POOL_BITS'(POOL_ITEMS-1)) ||
      (state == DOT && !dot_last && dot_step == STEP_BITS'(DOT_STEPS-2) &&
       (PIPELINED_POOL != 0 ? block == BLOCK_BITS'(BLOCKS-1) && pool_item == POOL_BITS'(POOL_ITEMS-1) : release_after_dot));
    if (rst) begin
      read_block <= 0;
      read_pool <= 0;
    end else if (state == DOT && (PIPELINED_POOL != 0 ? !prefetch_bubble && prefetch_step == STEP_BITS'(DOT_STEPS-1) : dot_last)) begin
      read_pool <= read_pool == POOL_BITS'(POOL_ITEMS-1) ? POOL_BITS'(0) : read_pool + 1'b1;
      if (read_pool == POOL_BITS'(POOL_ITEMS-1))
        read_block <= read_block == BLOCK_BITS'(BLOCKS-1) ? BLOCK_BITS'(0) : read_block + 1'b1;
    end
    if (starting_dot) begin
      dot_last <= DOT_STEPS == 1;
      release_after_dot <= read_block == BLOCK_BITS'(BLOCKS-1) && read_pool == POOL_BITS'(POOL_ITEMS-1);
    end else if (state == DOT) dot_last <= dot_step == STEP_BITS'(DOT_STEPS-2);
    // Prime the counter during every non-dot phase. The window selects its
    // separately decoded first coordinate then, so startup does not feed the
    // counter through window/ready/reset logic. Extra final increments are idle.
    if (rst || state != DOT) prefetch_bubble <= 0;
    else prefetch_bubble <= PIPELINED_POOL != 0 && !prefetch_bubble &&
      prefetch_step == STEP_BITS'(DOT_STEPS-1) && read_pool != POOL_BITS'(POOL_ITEMS-1);
    if (state == DOT) begin
      if (!prefetch_bubble)
        prefetch_step <= prefetch_step == STEP_BITS'(DOT_STEPS-1) ? STEP_BITS'(0) : prefetch_step + 1'b1;
    end else prefetch_step <= STEP_BITS'(DOT_STEPS > 2 ? 2 : 0);
  end
  wire [STEP_BITS-1:0] read_step = prefetch_step;
  // Select the second startup word after coordinate decoding is registered.
  localparam integer SECOND_STEP = DOT_STEPS > 1 ? 1 : 0;
  wire [WINDOW_BITS-1:0] window_address, alternate_address, first_address;
  wire [SUBWORD_BITS-1:0] subword;
  generate if (POOL_ITEMS > 1) begin: pooled_window
    wire [WINDOW_BITS-1:0] addresses [0:POOL_ITEMS*DOT_STEPS-1];
    wire [SUBWORD_BITS-1:0] parts [0:DOT_STEPS-1];
    genvar item, step;
    for (item = 0; item < POOL_ITEMS; item = item + 1) begin: position
      for (step = 0; step < DOT_STEPS; step = step + 1) begin: coordinate
        localparam integer Y = (item / POOL_W)*STRIDE_H + (step / (GROUP_WORDS*KERNEL_W))*DILATION_H;
        localparam integer X = (item % POOL_W)*STRIDE_W + ((step / GROUP_WORDS) % KERNEL_W)*DILATION_W;
        assign addresses[item*DOT_STEPS+step] = WINDOW_BITS'((Y*WINDOW_W+X)*CHANNEL_WORDS + (step % GROUP_WORDS)/SUBWORDS);
      end
    end
    for (step = 0; step < DOT_STEPS; step = step + 1) begin: subchannel
      assign parts[step] = SUBWORD_BITS'((step % GROUP_WORDS) % SUBWORDS);
    end
    assign window_address = addresses[32'(read_pool)*DOT_STEPS+32'(read_step)] +
      WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign alternate_address = addresses[32'(read_pool)*DOT_STEPS+SECOND_STEP] +
      WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign first_address = addresses[32'(read_pool)*DOT_STEPS] +
      WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign subword = parts[dot_step];
  end else if (GROUPS == 1 && REDUCTION_LANES == LANES) begin: full_channel_window
    assign window_address = WINDOW_BITS'(read_step);
    assign alternate_address = WINDOW_BITS'(SECOND_STEP);
    assign first_address = 0;
    assign subword = 0;
  end else begin: grouped_window
    wire [WINDOW_BITS-1:0] addresses [0:DOT_STEPS-1];
    wire [SUBWORD_BITS-1:0] parts [0:DOT_STEPS-1];
    genvar step;
    for (step = 0; step < DOT_STEPS; step = step + 1) begin: coordinate
      assign addresses[step] = WINDOW_BITS'((step / GROUP_WORDS)*CHANNEL_WORDS + (step % GROUP_WORDS)/SUBWORDS);
      assign parts[step] = SUBWORD_BITS'((step % GROUP_WORDS) % SUBWORDS);
    end
    assign window_address = addresses[read_step] + WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign alternate_address = addresses[SECOND_STEP] + WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign first_address = addresses[0] + WINDOW_BITS'(GROUPS == 1 ? 0 : (32'(read_block)/TILES) * (GROUP_INPUTS/LANES));
    assign subword = parts[dot_step];
  end endgenerate
  wire [LANES*8-1:0] window_data;
  wire [LANES*INPUT_BITS-1:0] stored_input, stored_window;
  genvar storage_lane;
  generate for (storage_lane = 0; storage_lane < LANES; storage_lane = storage_lane + 1) begin: storage_width
    assign stored_input[storage_lane*INPUT_BITS +: INPUT_BITS] = in_data[storage_lane*8 +: INPUT_BITS];
    assign window_data[storage_lane*8 +: 8] = EXTERNAL_WINDOW != 0 ? external_data[storage_lane*8 +: 8] : INPUT_SIGNED != 0 ?
      8'($signed(stored_window[storage_lane*INPUT_BITS +: INPUT_BITS])) :
      8'(stored_window[storage_lane*INPUT_BITS +: INPUT_BITS]);
  end endgenerate
  assign external_release = release_window;
  // The fused view composes step-to-word and word-to-coordinate maps at
  // elaboration. Export the registers directly, avoiding cascaded ROM muxes.
  assign external_request = {read_block,read_step};
  assign external_next_request = {read_block,STEP_BITS'(SECOND_STEP)};
  assign external_first_request = {read_block,{STEP_BITS{1'b0}}};
  assign external_address = window_address;
  assign external_alternate = alternate_address;
  assign external_first = first_address;
  assign external_active = state == DOT;
  assign external_select = starting_dot && DOT_STEPS > 1;
  generate if (EXTERNAL_WINDOW != 0) begin: shared_window
    assign in_ready = 1'b0;
    assign window_available = external_available;
    assign stored_window = '0;
  end else begin: local_window
  raster_window #(
    .HEIGHT(HEIGHT), .WIDTH(WIDTH), .CHANNELS(INPUT_CHANNELS),
    .KERNEL_H(WINDOW_H), .KERNEL_W(WINDOW_W), .STRIDE_H(STRIDE_H*POOL_H), .STRIDE_W(STRIDE_W*POOL_W),
    .DILATION_H(POOL_ITEMS == 1 ? DILATION_H : 1), .DILATION_W(POOL_ITEMS == 1 ? DILATION_W : 1), .PAD_H(PAD_H), .PAD_W(PAD_W),
    .LANES(LANES), .BITS(INPUT_BITS), .MEMORY_STYLE(LINE_MEMORY), .PACKED_LINES(PACKED_LINES),
    .PIPELINED_READ(1), .ALTERNATE_READ(1), .STARTUP_READ(1)
  ) window (
    .clk(clk), .rst(rst), .in_data(stored_input), .in_valid(in_valid), .in_ready(in_ready),
    .window_available(window_available), .release_window(release_window),
    .window_address(window_address), .alternate_address(alternate_address),
    .first_address(first_address), .select_first(state != DOT),
    .select_alternate(starting_dot && DOT_STEPS > 1), .window_data(stored_window)
  );
  end endgenerate

  reg [ROM_WIDTH-1:0] weight_word;
  generate if (88'(WEIGHT_MEMORY) == 88'("logic") && ROM_DEPTH > LOGIC_WEIGHT_BANK_DEPTH) begin: banked_weights
    localparam integer BANKS = (ROM_DEPTH+LOGIC_WEIGHT_BANK_DEPTH-1)/LOGIC_WEIGHT_BANK_DEPTH;
    localparam integer BANK_BITS = BANKS <= 1 ? 1 : $clog2(BANKS);
    localparam integer ADDRESS_BITS = $clog2(LOGIC_WEIGHT_BANK_DEPTH);
    wire [ROM_WIDTH-1:0] words [0:BANKS-1];
    reg [BANK_BITS-1:0] selected;
    always @(posedge clk) if (state == DOT)
      selected <= BANK_BITS'(weight_address/LOGIC_WEIGHT_BANK_DEPTH);
    genvar bank;
    for (bank=0; bank<BANKS; bank=bank+1) begin: bank_storage
      (* rom_style="logic" *) reg [ROM_WIDTH-1:0] memory [0:LOGIC_WEIGHT_BANK_DEPTH-1];
      reg [ROM_WIDTH-1:0] word;
      integer address;
      initial for (address=0; address<LOGIC_WEIGHT_BANK_DEPTH; address=address+1)
        memory[address] = bank*LOGIC_WEIGHT_BANK_DEPTH+address < ROM_DEPTH ?
          WEIGHTS[(bank*LOGIC_WEIGHT_BANK_DEPTH+address)*ROM_WIDTH +: ROM_WIDTH] : {ROM_WIDTH{1'b0}};
      always @(posedge clk) if (state == DOT) word <= memory[weight_address[ADDRESS_BITS-1:0]];
      assign words[bank]=word;
    end
    // The registered bank outputs share the operand capture edge. Their final
    // mux uses the existing multiplier-input stage, preserving read latency.
    always @* weight_word=words[selected];
  end else if (WEIGHT_BLOCK_DEPTH == ROM_DEPTH) begin: uniform_weights
    (* rom_style = WEIGHT_MEMORY *) reg [ROM_WIDTH-1:0] weight_memory [0:ROM_DEPTH-1];
    integer address;
    initial for (address = 0; address < ROM_DEPTH; address = address + 1)
      weight_memory[address] = WEIGHTS[address*ROM_WIDTH +: ROM_WIDTH];
    always @(posedge clk) if (state == DOT) weight_word <= weight_memory[weight_address];
  end else begin: split_weights
    localparam integer BLOCK_ADDRESS_BITS=WEIGHT_BLOCK_DEPTH<=1 ? 1 : $clog2(WEIGHT_BLOCK_DEPTH);
    localparam integer TAIL_DEPTH=ROM_DEPTH-WEIGHT_BLOCK_DEPTH;
    localparam integer BANKS=(TAIL_DEPTH+LOGIC_WEIGHT_BANK_DEPTH-1)/LOGIC_WEIGHT_BANK_DEPTH;
    localparam integer BANK_BITS=BANKS<=1 ? 1 : $clog2(BANKS);
    localparam integer ADDRESS_BITS=$clog2(LOGIC_WEIGHT_BANK_DEPTH);
    (* rom_style = "block" *) reg [ROM_WIDTH-1:0] blocks [0:WEIGHT_BLOCK_DEPTH-1];
    reg [ROM_WIDTH-1:0] block_word;
    wire [ROM_WIDTH-1:0] words [0:BANKS-1];
    wire [ROM_ADDRESS_BITS-1:0] tail_address=weight_address-ROM_ADDRESS_BITS'(WEIGHT_BLOCK_DEPTH);
    reg selected_block;
    reg [BANK_BITS-1:0] selected_bank;
    integer address;
    initial for (address=0; address<WEIGHT_BLOCK_DEPTH; address=address+1)
      blocks[address]=WEIGHTS[address*ROM_WIDTH +: ROM_WIDTH];
    always @(posedge clk) begin
      block_word <= blocks[BLOCK_ADDRESS_BITS'(weight_address)];
      selected_block <= 32'(weight_address)<WEIGHT_BLOCK_DEPTH;
      selected_bank <= BANK_BITS'(32'(tail_address)/LOGIC_WEIGHT_BANK_DEPTH);
    end
    genvar bank;
    for (bank=0; bank<BANKS; bank=bank+1) begin: tail_storage
      (* rom_style="logic" *) reg [ROM_WIDTH-1:0] memory [0:LOGIC_WEIGHT_BANK_DEPTH-1];
      reg [ROM_WIDTH-1:0] word;
      integer entry;
      initial for (entry=0; entry<LOGIC_WEIGHT_BANK_DEPTH; entry=entry+1)
        memory[entry]=bank*LOGIC_WEIGHT_BANK_DEPTH+entry<TAIL_DEPTH ?
          WEIGHTS[(WEIGHT_BLOCK_DEPTH+bank*LOGIC_WEIGHT_BANK_DEPTH+entry)*ROM_WIDTH +: ROM_WIDTH] : {ROM_WIDTH{1'b0}};
      always @(posedge clk) word <= memory[ADDRESS_BITS'(tail_address)];
      assign words[bank]=word;
    end
    // Read the block prefix and bounded logic banks independently. Selection
    // uses their registered outputs in the existing multiplier-input stage.
    // Reads outside DOT are unobserved, so no state-dependent enable is needed.
    always @* weight_word=selected_block ? block_word : words[selected_bank];
  end endgenerate

  reg [REDUCTION_LANES*8-1:0] input_word;
  reg operand_valid, operand_rq, operand_last;
  reg operand_first_group, operand_last_group, operand_last_byte;
  reg product_valid, product_rq, product_last;
  reg operand_first, product_first;
  reg [POOL_BITS-1:0] operand_pool, product_pool;
  reg product_first_group, product_last_group, product_last_byte;
  wire dot_valid, dot_complete, dot_first;
  wire [POOL_BITS-1:0] dot_pool;
  generate if (REDUCTION_LANES > 1) begin: dot_pipeline
    reg valid, last;
    reg first;
    reg [POOL_BITS-1:0] item;
    always @(posedge clk) begin
      if (rst) valid <= 0;
      else valid <= product_valid && !product_rq;
      last <= product_last;
      first <= product_first;
      item <= product_pool;
    end
    assign dot_valid = valid;
    assign dot_complete = valid && last;
    assign dot_first = first;
    assign dot_pool = item;
  end else begin: direct_dot
    assign dot_valid = product_valid && !product_rq;
    assign dot_complete = dot_valid && product_last;
    assign dot_first = product_first;
    assign dot_pool = product_pool;
  end endgenerate
  reg pool_update, pool_commit, pool_first, pool_last;
  reg pool_choose [0:OUTPUT_LANES-1];
  // The emitter proves this width covers the final result, or retains all
  // 32 bits. Modular addition permits the same narrowing at every MAC step.
  reg signed [ACCUMULATOR_BITS-1:0] accumulator [0:OUTPUT_LANES-1];
  reg signed [ACCUMULATOR_BITS-1:0] tile_bias [0:OUTPUT_LANES-1];
  reg signed [ACCUMULATOR_BITS-1:0] pool_maximum [0:OUTPUT_LANES-1];
  wire signed [ACCUMULATOR_BITS-1:0] completed_dot [0:OUTPUT_LANES-1];
  wire signed [ACCUMULATOR_BITS-1:0] selected_maximum [0:OUTPUT_LANES-1];
  reg signed [8:0] byte_operand [0:OUTPUT_LANES-1];
  reg signed [8:0] coefficient_operand [0:OUTPUT_LANES*REDUCTION_LANES-1];
  wire signed [17:0] product [0:OUTPUT_LANES*REDUCTION_LANES-1];
  reg signed [INNER_BITS-1:0] inner_sum [0:OUTPUT_LANES-1];
  reg signed [REQUANT_BITS-1:0] total_sum [0:OUTPUT_LANES-1];
  wire signed [INNER_BITS-1:0] group_sum [0:OUTPUT_LANES-1];
  wire signed [INNER_BITS-1:0] next_inner [0:OUTPUT_LANES-1];
  wire signed [REQUANT_BITS-1:0] next_total [0:OUTPUT_LANES-1];
  wire signed [63:0] shifted [0:OUTPUT_LANES-1];
  wire [7:0] quantized [0:OUTPUT_LANES-1];
  localparam integer SEARCH_BITS = THRESHOLD_BITS < 1 ? 1 : THRESHOLD_BITS;
  reg [SEARCH_BITS-1:0] search_mask;
  reg [SEARCH_BITS-1:0] quantizer_code [0:OUTPUT_LANES-1];
  localparam [1:0] QUANT_IDLE=0, QUANT_PRIME=1, QUANT_SEARCH=2, QUANT_POST=3;
  reg [1:0] quantizer_state;
  reg [BLOCK_BITS-1:0] quantizer_block;
  reg signed [ACCUMULATOR_BITS-1:0] quantizer_value [0:OUTPUT_LANES-1];
  wire signed [REQUANT_BITS-1:0] quantizer_sum [0:OUTPUT_LANES-1];
  localparam integer COEFFICIENT_STEPS=MULTIPLIER_BITS;
  localparam integer QUANTIZER_STEP_BITS=COEFFICIENT_STEPS<=1 ? 1 : $clog2(COEFFICIENT_STEPS);
  reg [QUANTIZER_STEP_BITS-1:0] quantizer_step;
  localparam integer QUANTIZER_GROUPS=OUTPUT_LANES/QUANTIZER_LANES;
  localparam integer QUANTIZER_GROUP_BITS=QUANTIZER_GROUPS<=1 ? 1 : $clog2(QUANTIZER_GROUPS);
  reg [QUANTIZER_GROUP_BITS-1:0] quantizer_group;
  wire quantizer_accept = OVERLAP_QUANTIZER != 0 && state == POST && quantizer_state == QUANT_IDLE;
  wire searching = OVERLAP_QUANTIZER != 0 ? quantizer_state == QUANT_SEARCH : state == RQ;
  wire [BLOCK_BITS-1:0] threshold_block = OVERLAP_QUANTIZER != 0 ? quantizer_block : block;

  genvar output_lane, reduction_lane;
  generate for (output_lane = 0; output_lane < OUTPUT_LANES; output_lane = output_lane + 1) begin: mac
    // A direct registered ROM read keeps block-update control before its
    // register, rather than moving it into the bias lookup during synthesis.
    always @(posedge clk) tile_bias[output_lane] <=
      ACCUMULATOR_BITS'(BIASES[(32'(block)*OUTPUT_LANES+output_lane)*32 +: 32]);
    wire [COEFFICIENT_BITS-1:0] coefficient =
      MULTIPLIERS[(32'(block)*OUTPUT_LANES+output_lane)*COEFFICIENT_BITS +: COEFFICIENT_BITS];
    wire signed [PADDED_ACCUMULATOR_BITS-1:0] byte_accumulator = PADDED_ACCUMULATOR_BITS'(
      POOL_ITEMS > 1 && pool_commit && pool_last ? selected_maximum[output_lane] : accumulator[output_lane]);
    wire [7:0] selected_byte = byte_accumulator[32'(accumulator_byte)*8 +: 8];
    always @(posedge clk) if (state == RQ)
      byte_operand[output_lane] <=
        {selected_byte[7] && accumulator_byte == BYTE_BITS'(ACCUMULATOR_BYTES-1), selected_byte};
    for (reduction_lane = 0; reduction_lane < REDUCTION_LANES; reduction_lane = reduction_lane + 1) begin: multiply
      localparam integer INDEX = output_lane*REDUCTION_LANES + reduction_lane;
      wire [7:0] coefficient_byte =
        coefficient[(32'(multiplier_group)*REDUCTION_LANES+reduction_lane)*8 +: 8];
      wire signed [8:0] data_operand = REQUANT_MASK[INDEX] && operand_rq ? byte_operand[output_lane] :
        $signed({INPUT_SIGNED != 0 && input_word[reduction_lane*8+7], input_word[reduction_lane*8 +: 8]});
      wire signed [8:0] weight_operand = REQUANT_MASK[INDEX] && operand_rq ? coefficient_operand[INDEX] :
        9'($signed(weight_word[INDEX*WEIGHT_BITS +: WEIGHT_BITS]));
      always @(posedge clk)
        if (state == RQ) coefficient_operand[INDEX] <=
          {MULTIPLIER_SIGNED != 0 && 32'(multiplier_group)*REDUCTION_LANES+reduction_lane == MULTIPLIER_BYTES-1 &&
           coefficient_byte[7], coefficient_byte};
      if (PRODUCT_MASK[INDEX]) begin: used
        reg signed [17:0] value;
        // Consumers are gated by product_valid; an enable here is redundant
        // and prevents sharing the same clock control across DSP registers.
        always @(posedge clk) value <= data_operand * weight_operand;
        assign product[INDEX] = value;
      end else begin: constant_zero
        assign product[INDEX] = 18'sd0;
      end
    end
    // Requantization reuses the wider products. Dot products only need the
    // declared input precision times a signed byte, plus reduction carry bits.
    localparam integer DOT_PRODUCT_BITS = INPUT_BITS + WEIGHT_BITS;
    localparam integer DOT_SUM_BITS = DOT_PRODUCT_BITS + $clog2(REDUCTION_LANES) < ACCUMULATOR_BITS ?
      DOT_PRODUCT_BITS + $clog2(REDUCTION_LANES) : ACCUMULATOR_BITS;
    wire [REDUCTION_LANES*DOT_SUM_BITS-1:0] dot_products;
    for (reduction_lane = 0; reduction_lane < REDUCTION_LANES; reduction_lane = reduction_lane + 1) begin: dot_operand
      assign dot_products[reduction_lane*DOT_SUM_BITS +: DOT_SUM_BITS] =
        DOT_SUM_BITS'($signed(product[output_lane*REDUCTION_LANES+reduction_lane][DOT_PRODUCT_BITS-1:0]));
    end
    // Separate the product reduction from the accumulator feedback. One
    // product per cycle remains possible; only dot startup/drain gains an edge.
    wire signed [DOT_SUM_BITS-1:0] dot_sum;
    integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
      .values(dot_products), .sum(dot_sum));
    if (REDUCTION_LANES > 1) begin: summed_dot
      reg signed [DOT_SUM_BITS-1:0] held_sum;
      always @(posedge clk) held_sum <= dot_sum;
      assign completed_dot[output_lane] = accumulator[output_lane] + ACCUMULATOR_BITS'(held_sum);
    end else begin: single_product
      assign completed_dot[output_lane] = accumulator[output_lane] + ACCUMULATOR_BITS'(dot_sum);
    end
    reg signed [INNER_BITS-1:0] group_value;
    integer lane;
    always @* begin
      group_value = 0;
      for (lane = 0; lane < REDUCTION_LANES; lane = lane + 1) begin
        if (REQUANT_MASK[output_lane*REDUCTION_LANES+lane])
          group_value = group_value +
            (INNER_BITS'($signed(product[output_lane*REDUCTION_LANES+lane])) << (8*lane));
      end
    end
    assign selected_maximum[output_lane] = PIPELINED_POOL != 0 ? pool_maximum[output_lane] : pool_choose[output_lane] ?
      accumulator[output_lane] : pool_maximum[output_lane];
    assign group_sum[output_lane] = group_value;
    assign next_inner[output_lane] = group_sum[output_lane] +
      (product_first_group ? INNER_BITS'(0) : inner_sum[output_lane] << (8*REDUCTION_LANES));
    assign next_total[output_lane] = (total_sum[output_lane] << 8) + REQUANT_BITS'($signed(next_inner[output_lane]));
    assign shifted[output_lane] = 64'($signed(OVERLAP_QUANTIZER != 0 && THRESHOLD_BITS == 0 ?
      quantizer_sum[output_lane%QUANTIZER_LANES] : total_sum[output_lane])) >>> SHIFT;
    if (OVERLAP_QUANTIZER != 0 && THRESHOLD_BITS == 0 && output_lane<QUANTIZER_LANES) begin: shift_add_quantizer
      wire signed [ACCUMULATOR_BITS-1:0] value;
      wire [31:0] lane_index=32'(quantizer_group)*QUANTIZER_LANES+output_lane;
      assign value=quantizer_value[output_lane];
      wire signed [ACCUMULATOR_BITS+MULTIPLIER_BITS-1:0] result;
      serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
        .SIGNED_COEFFICIENT(MULTIPLIER_SIGNED)) multiply (
        .clk(clk), .start(quantizer_state == QUANT_PRIME), .step(quantizer_state == QUANT_SEARCH),
        .last(quantizer_step == 0), .value(value),
        .coefficient(MULTIPLIER_BITS'(MULTIPLIERS[(32'(quantizer_block)*OUTPUT_LANES+lane_index)*COEFFICIENT_BITS +: COEFFICIENT_BITS])),
        .product(result));
      // Narrow after the exact product, then add with the declared modular
      // width. This also preserves INT64 overflow before the signed shift.
      assign quantizer_sum[output_lane] = REQUANT_BITS'(result)+REQUANT_BITS'(OFFSET);
    end else assign quantizer_sum[output_lane] = 0;
    if (THRESHOLD_BITS > 0) begin: threshold_quantizer
      localparam integer THRESHOLD_WIDTH = ACCUMULATOR_BITS+2;
      localparam integer LEVELS = 1<<THRESHOLD_BITS;
      localparam integer PAIRS = LEVELS/2;
      localparam integer NODE_BITS = THRESHOLD_BITS <= 1 ? 1 : THRESHOLD_BITS-1;
      localparam integer ADDRESS_BITS = BLOCKS*PAIRS <= 1 ? 1 : $clog2(BLOCKS*PAIRS);
      (* rom_style="logic" *) reg [2*THRESHOLD_WIDTH-1:0] children [0:BLOCKS*PAIRS-1];
      genvar entry;
      for (entry=0; entry<BLOCKS*PAIRS; entry=entry+1) begin: tree
        localparam integer NODE = entry%PAIRS;
        localparam integer LEVEL = NODE == 0 ? 0 : $clog2(NODE+1)-1;
        localparam integer LEFT = NODE == 0 ? LEVELS/2 :
          (4*(NODE-(1<<LEVEL))+1) << (THRESHOLD_BITS-LEVEL-2);
        localparam integer RIGHT = NODE == 0 ? LEFT : LEFT+(1<<(THRESHOLD_BITS-LEVEL-1));
        localparam integer BASE = (entry/PAIRS*OUTPUT_LANES+output_lane)*LEVELS;
        initial children[entry] = {
          THRESHOLDS[(BASE+RIGHT)*THRESHOLD_WIDTH +: THRESHOLD_WIDTH],
          THRESHOLDS[(BASE+LEFT)*THRESHOLD_WIDTH +: THRESHOLD_WIDTH]};
      end
      wire [NODE_BITS-1:0] node = THRESHOLD_BITS > 1 && searching ? NODE_BITS'(quantizer_code[output_lane]) : NODE_BITS'(0);
      wire [ADDRESS_BITS-1:0] address = (ADDRESS_BITS'(threshold_block) << (THRESHOLD_BITS-1)) | ADDRESS_BITS'(node);
      reg [2*THRESHOLD_WIDTH-1:0] child_pair;
      reg choose_upper;
      wire signed [THRESHOLD_WIDTH-1:0] threshold = choose_upper ?
        child_pair[THRESHOLD_WIDTH +: THRESHOLD_WIDTH] : child_pair[0 +: THRESHOLD_WIDTH];
      // The accumulator remains stable throughout the search. One bit of the
      // exact output code is decided per cycle, with no arithmetic approximation.
      wire signed [ACCUMULATOR_BITS-1:0] search_value =
        OVERLAP_QUANTIZER != 0 ? quantizer_value[output_lane] :
        POOL_ITEMS > 1 && pool_commit && pool_last ? selected_maximum[output_lane] : accumulator[output_lane];
      wire upper_half = THRESHOLD_WIDTH'(search_value) >= threshold;
      always @(posedge clk) begin
        // Heap node zero holds two copies of the root threshold. Interior
        // nodes hold both children in one ROM word, registered before selection.
        // Shift in decisions; the leading heap bit drops out at the last step,
        // leaving exactly the output code. Leaf-child reads are unobserved.
        child_pair <= children[address];
        choose_upper <= upper_half;
        if (OVERLAP_QUANTIZER != 0 ? quantizer_accept : dot_complete)
          quantizer_code[output_lane] <= SEARCH_BITS'(1);
        else if (searching)
          quantizer_code[output_lane] <= (quantizer_code[output_lane] << 1) | SEARCH_BITS'(upper_half);
      end
      assign quantized[output_lane] = LOW[7:0]+8'(quantizer_code[output_lane]);
    end else begin: multiplier_quantizer
      wire [7:0] result = shifted[output_lane] < $signed(LOW) ? LOW[7:0] :
                         shifted[output_lane] > $signed(HIGH) ? HIGH[7:0] : shifted[output_lane][7:0];
      if (QUANTIZER_GROUPS>1 && output_lane/QUANTIZER_LANES<QUANTIZER_GROUPS-1) begin: partial
        reg [7:0] held;
        always @(posedge clk)
          if (quantizer_state==QUANT_POST && quantizer_group==QUANTIZER_GROUP_BITS'(output_lane/QUANTIZER_LANES))
            held <= result;
        assign quantized[output_lane]=held;
      end else assign quantized[output_lane]=result;
    end
  end endgenerate

  reg [OUTPUT_ELEMENT_BITS-1:0] output_pixel [0:OUTPUT_CHANNELS-1];
  reg output_pending;
  reg [OUTPUT_BITS-1:0] output_word;
  wire output_finished = out_ready && output_word == OUTPUT_BITS'(OUTPUT_WORDS-1);
  wire [BLOCK_BITS-1:0] committed_block = OVERLAP_QUANTIZER != 0 ? quantizer_block : block;
  wire [31:0] tile_channel = (GROUPS == 1 ? 32'(committed_block) : 32'(committed_block) % TILES) * OUTPUT_LANES;
  wire [31:0] group_channel = GROUPS == 1 ? 32'd0 : (32'(committed_block) / TILES) * GROUP_OUTPUTS;
  assign out_valid = output_pending && !rst;
  assign starting_dot = (state == IDLE && window_available) ||
    (PIPELINED_POOL == 0 && state == DOT_DRAIN && dot_complete && pool_item != POOL_BITS'(POOL_ITEMS-1)) ||
    (state == POST && (OVERLAP_QUANTIZER != 0 ? quantizer_accept : (!output_pending || output_finished)) && block != BLOCK_BITS'(BLOCKS-1));

  // Tile startup has spare operand-read cycles before the first MAC result.
  // Register its decision while the new block's bias passes through its ROM
  // register, keeping downstream ready and the decoder off accumulator D.
  reg [1:0] initialize_tile;
  always @(posedge clk) begin
    if (rst) initialize_tile <= 0;
    else initialize_tile <= {initialize_tile[0],(state == IDLE && window_available) ||
      (state == POST && (OVERLAP_QUANTIZER != 0 ? quantizer_accept : (!output_pending || output_finished)) && block != BLOCK_BITS'(BLOCKS-1))};
  end
  integer accumulator_lane;
  always @(posedge clk) begin
    for (accumulator_lane = 0; accumulator_lane < OUTPUT_LANES; accumulator_lane = accumulator_lane + 1) begin
      if (initialize_tile[1] || (PIPELINED_POOL != 0 && pool_update && !pool_last))
        accumulator[accumulator_lane] <= tile_bias[accumulator_lane];
      else if (dot_valid)
        accumulator[accumulator_lane] <= completed_dot[accumulator_lane];
      else if (POOL_ITEMS > 1 && pool_commit)
        accumulator[accumulator_lane] <= pool_last ? selected_maximum[accumulator_lane] :
          tile_bias[accumulator_lane];
    end
  end

  integer lane;
  always @* begin
    out_data = 0;
    for (lane = 0; lane < LANES; lane = lane + 1)
      if (32'(output_word)*LANES+lane < OUTPUT_CHANNELS)
        out_data[lane*8 +: 8] = OUTPUT_SIGNED != 0 ?
          8'($signed(output_pixel[32'(output_word)*LANES+lane])) : 8'(output_pixel[32'(output_word)*LANES+lane]);
  end

  integer channel;
  always @(posedge clk) begin
    if (rst) begin
      state <= IDLE;
      block <= 0;
      dot_step <= 0;
      pool_item <= 0;
      dot_bubble <= 0;
      weight_address <= 0;
      operand_valid <= 0;
      product_valid <= 0;
      pool_update <= 0;
      pool_commit <= 0;
      output_pending <= 0;
      output_word <= 0;
      quantizer_state <= QUANT_IDLE;
      quantizer_block <= 0;
    end else begin
      dot_bubble <= 0;
      if (POOL_ITEMS > 1) begin
        pool_update <= dot_complete;
        pool_commit <= pool_update;
        if (dot_complete) begin
          pool_first <= (PIPELINED_POOL != 0 ? dot_pool : pool_item) == 0;
          pool_last <= (PIPELINED_POOL != 0 ? dot_pool : pool_item) == POOL_BITS'(POOL_ITEMS-1);
        end
        // The pipelined form updates the maximum through its register enable.
        // The operand bubble leaves this comparison an idle accumulator edge,
        // so that same edge can initialize the next dot's bias. No bias mux is
        // inserted into the accumulator's carry-feedback path.
        if (PIPELINED_POOL != 0 && pool_update) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
            if (pool_first || accumulator[channel] > pool_maximum[channel])
              pool_maximum[channel] <= accumulator[channel];
        end
        if (PIPELINED_POOL == 0 && pool_update) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
            pool_choose[channel] <= pool_first || accumulator[channel] > pool_maximum[channel];
        end
        if (PIPELINED_POOL == 0 && pool_commit) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1) begin
            pool_maximum[channel] <= selected_maximum[channel];
          end
        end
      end
      operand_valid <= (state == DOT && !dot_bubble) || (OVERLAP_QUANTIZER == 0 && THRESHOLD_BITS == 0 && state == RQ);
      operand_rq <= OVERLAP_QUANTIZER == 0 && THRESHOLD_BITS == 0 && state == RQ;
      operand_last <= dot_step == STEP_BITS'(DOT_STEPS-1);
      operand_first <= dot_step == 0;
      operand_pool <= pool_item;
      operand_first_group <= multiplier_group == GROUP_BITS'(MULTIPLIER_GROUPS-1);
      operand_last_group <= multiplier_group == 0;
      operand_last_byte <= accumulator_byte == 0;
      product_valid <= operand_valid;
      product_rq <= operand_rq;
      product_last <= operand_last;
      product_first <= operand_first;
      product_pool <= operand_pool;
      product_first_group <= operand_first_group;
      product_last_group <= operand_last_group;
      product_last_byte <= operand_last_byte;
      if (state == DOT && !dot_bubble) begin
        input_word <= window_data[32'(subword)*REDUCTION_LANES*8 +: REDUCTION_LANES*8];
        weight_address <= weight_address + 1'b1;
      end

      if (output_pending && out_ready) begin
        if (output_finished) begin
          output_pending <= 0;
          output_word <= 0;
        end else output_word <= output_word + 1'b1;
      end

      if (product_valid && product_rq) begin
        for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1) begin
          inner_sum[channel] <= next_inner[channel];
          if (product_last_group) begin
            total_sum[channel] <= next_total[channel] +
              (product_last_byte ? REQUANT_BITS'(OFFSET) : REQUANT_BITS'(0));
          end
        end
        if (product_last_group && product_last_byte) state <= POST;
      end
      if (dot_complete) begin
        if (POOL_ITEMS == 1 || (PIPELINED_POOL != 0 ? dot_pool : pool_item) == POOL_BITS'(POOL_ITEMS-1)) begin
          if (OVERLAP_QUANTIZER == 0) search_mask <= SEARCH_BITS'(1) << (SEARCH_BITS-1);
          accumulator_byte <= BYTE_BITS'(ACCUMULATOR_BYTES-1);
          multiplier_group <= GROUP_BITS'(MULTIPLIER_GROUPS-1);
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1) total_sum[channel] <= 0;
          state <= POOL_ITEMS > 1 ? POOL_WAIT : OVERLAP_QUANTIZER != 0 ? POST : RQ;
        end else if (PIPELINED_POOL == 0) begin
          pool_item <= pool_item + 1'b1;
          dot_step <= 0;
          weight_address <= ROM_ADDRESS_BITS'(32'(block)*DOT_STEPS);
          state <= DOT;
        end
      end

      case (state)
        IDLE: if (window_available) begin
          block <= 0;
          dot_step <= 0;
          pool_item <= 0;
          weight_address <= 0;
          state <= DOT;
        end
        DOT: if (!dot_bubble) begin
          if (dot_step == STEP_BITS'(DOT_STEPS-1)) begin
            if (PIPELINED_POOL != 0 && pool_item != POOL_BITS'(POOL_ITEMS-1)) begin
              // One empty operand edge leaves the completed sum stable for
              // the maximum update and bias reset while the next dot starts.
              pool_item <= pool_item+1'b1;
              dot_step <= 0;
              dot_bubble <= 1;
              weight_address <= ROM_ADDRESS_BITS'(32'(block)*DOT_STEPS);
            end else state <= DOT_DRAIN;
          end else dot_step <= dot_step + 1'b1;
        end
        POOL_WAIT: state <= OVERLAP_QUANTIZER != 0 ? POST : RQ;
        RQ: if (THRESHOLD_BITS > 0) begin
          if (search_mask == SEARCH_BITS'(1)) state <= POST;
          else search_mask <= search_mask >> 1;
        end else if (multiplier_group == 0) begin
          multiplier_group <= GROUP_BITS'(MULTIPLIER_GROUPS-1);
          if (accumulator_byte == 0) state <= RQ_DRAIN;
          else accumulator_byte <= accumulator_byte - 1'b1;
        end else multiplier_group <= multiplier_group - 1'b1;
        POST: if (OVERLAP_QUANTIZER != 0 ? quantizer_accept : (!output_pending || output_finished)) begin
          if (OVERLAP_QUANTIZER == 0)
            for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
              if (tile_channel+channel < GROUP_OUTPUTS)
                output_pixel[group_channel+tile_channel+channel] <= OUTPUT_ELEMENT_BITS'(quantized[channel]);
          if (block == BLOCK_BITS'(BLOCKS-1)) begin
            if (OVERLAP_QUANTIZER == 0) begin
              output_pending <= 1;
              output_word <= 0;
            end
            state <= IDLE;
          end else begin
            block <= block + 1'b1;
            dot_step <= 0;
            pool_item <= 0;
            state <= DOT;
          end
        end
        default: ;
      endcase
      // One completed tile is held independently of the MAC accumulator.
      // Backpressure stops this stage at commit, then stops the producer at
      // its next handoff. No output pixel or unfinished sum is overwritten.
      if (OVERLAP_QUANTIZER != 0) begin
        if (quantizer_accept) begin
          quantizer_block <= block;
          for (channel=0; channel<OUTPUT_LANES; channel=channel+1)
            quantizer_value[channel] <= POOL_ITEMS > 1 && pool_commit && pool_last ?
              selected_maximum[channel] : accumulator[channel];
          search_mask <= SEARCH_BITS'(1) << (SEARCH_BITS-1);
          quantizer_step <= QUANTIZER_STEP_BITS'(COEFFICIENT_STEPS-1);
          quantizer_group <= 0;
          quantizer_state <= QUANT_PRIME;
        end else case (quantizer_state)
          QUANT_PRIME: begin
            quantizer_step <= QUANTIZER_STEP_BITS'(COEFFICIENT_STEPS-1);
            quantizer_state <= QUANT_SEARCH;
          end
          QUANT_SEARCH: if (THRESHOLD_BITS > 0) begin
            if (search_mask == SEARCH_BITS'(1)) quantizer_state <= QUANT_POST;
            else search_mask <= search_mask >> 1;
          end else begin
            if (quantizer_step == 0) quantizer_state <= QUANT_POST;
            else quantizer_step <= quantizer_step - 1'b1;
          end
          QUANT_POST: if (quantizer_group!=QUANTIZER_GROUP_BITS'(QUANTIZER_GROUPS-1)) begin
            // Consume a fixed set of lanes, then move the remaining values
            // forward. Each register has one neighboring source; this avoids
            // a wide group-indexed read mux and an extra operand register bank.
            for (channel=0; channel<OUTPUT_LANES; channel=channel+1)
              quantizer_value[channel] <= channel+QUANTIZER_LANES < OUTPUT_LANES ?
                quantizer_value[channel+QUANTIZER_LANES] : ACCUMULATOR_BITS'(0);
            quantizer_group <= quantizer_group+1'b1;
            quantizer_state <= QUANT_PRIME;
          end else if (!output_pending || output_finished) begin
            for (channel=0; channel<OUTPUT_LANES; channel=channel+1)
              if (tile_channel+channel < GROUP_OUTPUTS)
                output_pixel[group_channel+tile_channel+channel] <= OUTPUT_ELEMENT_BITS'(quantized[channel]);
            if (quantizer_block == BLOCK_BITS'(BLOCKS-1)) begin
              output_pending <= 1;
              output_word <= 0;
            end
            quantizer_state <= QUANT_IDLE;
          end
          default: ;
        endcase
      end
    end
  end
endmodule

// The consumed coefficient bits become product bits. Only the upper value
// width needs an adder, rather than the full product width on every cycle.
// The final coefficient bit has negative weight for a signed coefficient.
module serial_product #(
  parameter integer VALUE_BITS=8, COEFFICIENT_BITS=8, SIGNED_COEFFICIENT=0
) (
  input wire clk, start, step, last,
  input wire signed [VALUE_BITS-1:0] value,
  input wire [COEFFICIENT_BITS-1:0] coefficient,
  output wire signed [VALUE_BITS+COEFFICIENT_BITS-1:0] product
);
  localparam integer WIDTH=VALUE_BITS+COEFFICIENT_BITS+1;
  reg signed [WIDTH-1:0] work;
  wire subtract=SIGNED_COEFFICIENT != 0 && last;
  wire [VALUE_BITS:0] term=work[0] ? (VALUE_BITS+1)'(value) : (VALUE_BITS+1)'(0);
  wire [VALUE_BITS:0] upper=work[COEFFICIENT_BITS +: VALUE_BITS+1]+
    (term ^ {(VALUE_BITS+1){subtract}})+(VALUE_BITS+1)'(subtract);
  wire signed [WIDTH-1:0] combined={upper,work[0 +: COEFFICIENT_BITS]};
  always @(posedge clk) begin
    if (start) work <= WIDTH'(coefficient);
    else if (step) work <= combined >>> 1;
  end
  assign product=(VALUE_BITS+COEFFICIENT_BITS)'(work);
endmodule

// Exact addition modulo 2**BITS. Each level compresses triples in parallel;
// only the last two operands need a carry-propagating adder.
module integer_sum #(
  parameter integer WORDS = 2, BITS = 32
) (
  input wire [WORDS*BITS-1:0] values,
  output wire [BITS-1:0] sum
);
  generate if (WORDS == 1) begin: single
    assign sum = values;
  end else if (WORDS == 2) begin: pair
    assign sum = values[BITS-1:0] + values[BITS +: BITS];
  end else begin: compressed
    localparam integer GROUPS = WORDS / 3, REMAINDER = WORDS % 3;
    wire [(2*GROUPS+REMAINDER)*BITS-1:0] reduced;
    genvar group_index;
    for (group_index = 0; group_index < GROUPS; group_index = group_index + 1) begin: group_value
      wire [BITS-1:0] a = values[(3*group_index)*BITS +: BITS];
      wire [BITS-1:0] b = values[(3*group_index+1)*BITS +: BITS];
      wire [BITS-1:0] c = values[(3*group_index+2)*BITS +: BITS];
      assign reduced[(2*group_index)*BITS +: BITS] = a ^ b ^ c;
      assign reduced[(2*group_index+1)*BITS +: BITS] = ((a & b) | (a & c) | (b & c)) << 1;
    end
    if (REMAINDER > 0)
      assign reduced[2*GROUPS*BITS +: REMAINDER*BITS] = values[3*GROUPS*BITS +: REMAINDER*BITS];
    integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
