module inference (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
wire [31:0] data_0; wire valid_0, ready_0;
wire [31:0] data_1; wire valid_1, ready_1;
wire [31:0] data_2; wire valid_2, ready_2;
wire [31:0] data_3; wire valid_3, ready_3;
wire [31:0] data_4; wire valid_4, ready_4;
wire [31:0] data_5; wire valid_5, ready_5;
wire [31:0] data_6; wire valid_6, ready_6;
wire [31:0] data_7; wire valid_7, ready_7;
wire [31:0] data_8; wire valid_8, ready_8;
wire [31:0] data_9; wire valid_9, ready_9;
wire [31:0] data_10; wire valid_10, ready_10;
wire [31:0] data_11; wire valid_11, ready_11;
wire [31:0] data_12; wire valid_12, ready_12;
wire [31:0] data_13; wire valid_13, ready_13;
wire [31:0] data_14; wire valid_14, ready_14;
wire [31:0] data_15; wire valid_15, ready_15;
wire [31:0] data_16; wire valid_16, ready_16;
assign data_0 = in_data; assign valid_0 = in_valid; assign in_ready = ready_0;
assign out_data = data_16; assign out_valid = valid_16; assign ready_16 = out_ready;
wire [31:0] edge_data_0; wire edge_valid_0, edge_ready_0, space_0;
wire [23:0] packed_input_0, packed_output_0;
assign packed_input_0[0 +: 8] = 8'(data_0[0 +: 8]);
assign packed_input_0[8 +: 8] = 8'(data_0[8 +: 8]);
assign packed_input_0[16 +: 8] = 8'(data_0[16 +: 8]);
assign edge_data_0[0 +: 8] = 8'(packed_output_0[0 +: 8]);
assign edge_data_0[8 +: 8] = 8'(packed_output_0[8 +: 8]);
assign edge_data_0[16 +: 8] = 8'(packed_output_0[16 +: 8]);
assign edge_data_0[31:24] = '0;
stream_fifo #(.WIDTH(24), .DEPTH(2), .MEMORY_STYLE("block")) fifo_0 (
.clk(clk), .rst(rst), .in_data(packed_input_0), .in_valid(valid_0 && ready_0), .in_ready(space_0),
.out_data(packed_output_0), .out_valid(edge_valid_0), .out_ready(edge_ready_0));
wire [31:0] edge_data_1; wire edge_valid_1, edge_ready_1, space_1;
wire [15:0] packed_input_1, packed_output_1;
assign packed_input_1[0 +: 4] = 4'(data_1[0 +: 8]);
assign packed_input_1[4 +: 4] = 4'(data_1[8 +: 8]);
assign packed_input_1[8 +: 4] = 4'(data_1[16 +: 8]);
assign packed_input_1[12 +: 4] = 4'(data_1[24 +: 8]);
assign edge_data_1[0 +: 8] = 8'(packed_output_1[0 +: 4]);
assign edge_data_1[8 +: 8] = 8'(packed_output_1[4 +: 4]);
assign edge_data_1[16 +: 8] = 8'(packed_output_1[8 +: 4]);
assign edge_data_1[24 +: 8] = 8'(packed_output_1[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_1 (
.clk(clk), .rst(rst), .in_data(packed_input_1), .in_valid(valid_1 && ready_1), .in_ready(space_1),
.out_data(packed_output_1), .out_valid(edge_valid_1), .out_ready(edge_ready_1));
wire [31:0] edge_data_2; wire edge_valid_2, edge_ready_2, space_2;
wire [15:0] packed_input_2, packed_output_2;
assign packed_input_2[0 +: 4] = 4'(data_2[0 +: 8]);
assign packed_input_2[4 +: 4] = 4'(data_2[8 +: 8]);
assign packed_input_2[8 +: 4] = 4'(data_2[16 +: 8]);
assign packed_input_2[12 +: 4] = 4'(data_2[24 +: 8]);
assign edge_data_2[0 +: 8] = 8'(packed_output_2[0 +: 4]);
assign edge_data_2[8 +: 8] = 8'(packed_output_2[4 +: 4]);
assign edge_data_2[16 +: 8] = 8'(packed_output_2[8 +: 4]);
assign edge_data_2[24 +: 8] = 8'(packed_output_2[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_2 (
.clk(clk), .rst(rst), .in_data(packed_input_2), .in_valid(valid_2 && ready_2), .in_ready(space_2),
.out_data(packed_output_2), .out_valid(edge_valid_2), .out_ready(edge_ready_2));
wire [31:0] edge_data_3; wire edge_valid_3, edge_ready_3, space_3;
wire [15:0] packed_input_3, packed_output_3;
assign packed_input_3[0 +: 4] = 4'(data_3[0 +: 8]);
assign packed_input_3[4 +: 4] = 4'(data_3[8 +: 8]);
assign packed_input_3[8 +: 4] = 4'(data_3[16 +: 8]);
assign packed_input_3[12 +: 4] = 4'(data_3[24 +: 8]);
assign edge_data_3[0 +: 8] = 8'(packed_output_3[0 +: 4]);
assign edge_data_3[8 +: 8] = 8'(packed_output_3[4 +: 4]);
assign edge_data_3[16 +: 8] = 8'(packed_output_3[8 +: 4]);
assign edge_data_3[24 +: 8] = 8'(packed_output_3[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_3 (
.clk(clk), .rst(rst), .in_data(packed_input_3), .in_valid(valid_3 && ready_3), .in_ready(space_3),
.out_data(packed_output_3), .out_valid(edge_valid_3), .out_ready(edge_ready_3));
wire [31:0] edge_data_4; wire edge_valid_4, edge_ready_4, space_4;
wire [15:0] packed_input_4, packed_output_4;
assign packed_input_4[0 +: 4] = 4'(data_4[0 +: 8]);
assign packed_input_4[4 +: 4] = 4'(data_4[8 +: 8]);
assign packed_input_4[8 +: 4] = 4'(data_4[16 +: 8]);
assign packed_input_4[12 +: 4] = 4'(data_4[24 +: 8]);
assign edge_data_4[0 +: 8] = 8'(packed_output_4[0 +: 4]);
assign edge_data_4[8 +: 8] = 8'(packed_output_4[4 +: 4]);
assign edge_data_4[16 +: 8] = 8'(packed_output_4[8 +: 4]);
assign edge_data_4[24 +: 8] = 8'(packed_output_4[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_4 (
.clk(clk), .rst(rst), .in_data(packed_input_4), .in_valid(valid_4 && ready_4), .in_ready(space_4),
.out_data(packed_output_4), .out_valid(edge_valid_4), .out_ready(edge_ready_4));
wire [31:0] edge_data_5; wire edge_valid_5, edge_ready_5, space_5;
wire [15:0] packed_input_5, packed_output_5;
assign packed_input_5[0 +: 4] = 4'(data_5[0 +: 8]);
assign packed_input_5[4 +: 4] = 4'(data_5[8 +: 8]);
assign packed_input_5[8 +: 4] = 4'(data_5[16 +: 8]);
assign packed_input_5[12 +: 4] = 4'(data_5[24 +: 8]);
assign edge_data_5[0 +: 8] = 8'(packed_output_5[0 +: 4]);
assign edge_data_5[8 +: 8] = 8'(packed_output_5[4 +: 4]);
assign edge_data_5[16 +: 8] = 8'(packed_output_5[8 +: 4]);
assign edge_data_5[24 +: 8] = 8'(packed_output_5[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_5 (
.clk(clk), .rst(rst), .in_data(packed_input_5), .in_valid(valid_5 && ready_5), .in_ready(space_5),
.out_data(packed_output_5), .out_valid(edge_valid_5), .out_ready(edge_ready_5));
wire [31:0] edge_data_6; wire edge_valid_6, edge_ready_6, space_6;
wire [15:0] packed_input_6, packed_output_6;
assign packed_input_6[0 +: 4] = 4'(data_6[0 +: 8]);
assign packed_input_6[4 +: 4] = 4'(data_6[8 +: 8]);
assign packed_input_6[8 +: 4] = 4'(data_6[16 +: 8]);
assign packed_input_6[12 +: 4] = 4'(data_6[24 +: 8]);
assign edge_data_6[0 +: 8] = 8'(packed_output_6[0 +: 4]);
assign edge_data_6[8 +: 8] = 8'(packed_output_6[4 +: 4]);
assign edge_data_6[16 +: 8] = 8'(packed_output_6[8 +: 4]);
assign edge_data_6[24 +: 8] = 8'(packed_output_6[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1), .MEMORY_STYLE("block")) fifo_6 (
.clk(clk), .rst(rst), .in_data(packed_input_6), .in_valid(valid_6 && ready_6), .in_ready(space_6),
.out_data(packed_output_6), .out_valid(edge_valid_6), .out_ready(edge_ready_6));
wire [31:0] edge_data_7; wire edge_valid_7, edge_ready_7, space_7;
wire [15:0] packed_input_7, packed_output_7;
assign packed_input_7[0 +: 4] = 4'(data_7[0 +: 8]);
assign packed_input_7[4 +: 4] = 4'(data_7[8 +: 8]);
assign packed_input_7[8 +: 4] = 4'(data_7[16 +: 8]);
assign packed_input_7[12 +: 4] = 4'(data_7[24 +: 8]);
assign edge_data_7[0 +: 8] = 8'(packed_output_7[0 +: 4]);
assign edge_data_7[8 +: 8] = 8'(packed_output_7[4 +: 4]);
assign edge_data_7[16 +: 8] = 8'(packed_output_7[8 +: 4]);
assign edge_data_7[24 +: 8] = 8'(packed_output_7[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_7 (
.clk(clk), .rst(rst), .in_data(packed_input_7), .in_valid(valid_7 && ready_7), .in_ready(space_7),
.out_data(packed_output_7), .out_valid(edge_valid_7), .out_ready(edge_ready_7));
wire [31:0] edge_data_8; wire edge_valid_8, edge_ready_8, space_8;
wire [15:0] packed_input_8, packed_output_8;
assign packed_input_8[0 +: 4] = 4'(data_4[0 +: 8]);
assign packed_input_8[4 +: 4] = 4'(data_4[8 +: 8]);
assign packed_input_8[8 +: 4] = 4'(data_4[16 +: 8]);
assign packed_input_8[12 +: 4] = 4'(data_4[24 +: 8]);
assign edge_data_8[0 +: 8] = 8'(packed_output_8[0 +: 4]);
assign edge_data_8[8 +: 8] = 8'(packed_output_8[4 +: 4]);
assign edge_data_8[16 +: 8] = 8'(packed_output_8[8 +: 4]);
assign edge_data_8[24 +: 8] = 8'(packed_output_8[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_8 (
.clk(clk), .rst(rst), .in_data(packed_input_8), .in_valid(valid_4 && ready_4), .in_ready(space_8),
.out_data(packed_output_8), .out_valid(edge_valid_8), .out_ready(edge_ready_8));
wire [31:0] edge_data_9; wire edge_valid_9, edge_ready_9, space_9;
wire [15:0] packed_input_9, packed_output_9;
assign packed_input_9[0 +: 4] = 4'(data_8[0 +: 8]);
assign packed_input_9[4 +: 4] = 4'(data_8[8 +: 8]);
assign packed_input_9[8 +: 4] = 4'(data_8[16 +: 8]);
assign packed_input_9[12 +: 4] = 4'(data_8[24 +: 8]);
assign edge_data_9[0 +: 8] = 8'(packed_output_9[0 +: 4]);
assign edge_data_9[8 +: 8] = 8'(packed_output_9[4 +: 4]);
assign edge_data_9[16 +: 8] = 8'(packed_output_9[8 +: 4]);
assign edge_data_9[24 +: 8] = 8'(packed_output_9[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_9 (
.clk(clk), .rst(rst), .in_data(packed_input_9), .in_valid(valid_8 && ready_8), .in_ready(space_9),
.out_data(packed_output_9), .out_valid(edge_valid_9), .out_ready(edge_ready_9));
wire [31:0] edge_data_10; wire edge_valid_10, edge_ready_10, space_10;
wire [15:0] packed_input_10, packed_output_10;
assign packed_input_10[0 +: 4] = 4'(data_9[0 +: 8]);
assign packed_input_10[4 +: 4] = 4'(data_9[8 +: 8]);
assign packed_input_10[8 +: 4] = 4'(data_9[16 +: 8]);
assign packed_input_10[12 +: 4] = 4'(data_9[24 +: 8]);
assign edge_data_10[0 +: 8] = 8'(packed_output_10[0 +: 4]);
assign edge_data_10[8 +: 8] = 8'(packed_output_10[4 +: 4]);
assign edge_data_10[16 +: 8] = 8'(packed_output_10[8 +: 4]);
assign edge_data_10[24 +: 8] = 8'(packed_output_10[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_10 (
.clk(clk), .rst(rst), .in_data(packed_input_10), .in_valid(valid_9 && ready_9), .in_ready(space_10),
.out_data(packed_output_10), .out_valid(edge_valid_10), .out_ready(edge_ready_10));
wire [31:0] edge_data_11; wire edge_valid_11, edge_ready_11, space_11;
wire [15:0] packed_input_11, packed_output_11;
assign packed_input_11[0 +: 4] = 4'(data_10[0 +: 8]);
assign packed_input_11[4 +: 4] = 4'(data_10[8 +: 8]);
assign packed_input_11[8 +: 4] = 4'(data_10[16 +: 8]);
assign packed_input_11[12 +: 4] = 4'(data_10[24 +: 8]);
assign edge_data_11[0 +: 8] = 8'(packed_output_11[0 +: 4]);
assign edge_data_11[8 +: 8] = 8'(packed_output_11[4 +: 4]);
assign edge_data_11[16 +: 8] = 8'(packed_output_11[8 +: 4]);
assign edge_data_11[24 +: 8] = 8'(packed_output_11[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1), .MEMORY_STYLE("block")) fifo_11 (
.clk(clk), .rst(rst), .in_data(packed_input_11), .in_valid(valid_10 && ready_10), .in_ready(space_11),
.out_data(packed_output_11), .out_valid(edge_valid_11), .out_ready(edge_ready_11));
wire [31:0] edge_data_12; wire edge_valid_12, edge_ready_12, space_12;
wire [15:0] packed_input_12, packed_output_12;
assign packed_input_12[0 +: 4] = 4'(data_2[0 +: 8]);
assign packed_input_12[4 +: 4] = 4'(data_2[8 +: 8]);
assign packed_input_12[8 +: 4] = 4'(data_2[16 +: 8]);
assign packed_input_12[12 +: 4] = 4'(data_2[24 +: 8]);
assign edge_data_12[0 +: 8] = 8'(packed_output_12[0 +: 4]);
assign edge_data_12[8 +: 8] = 8'(packed_output_12[4 +: 4]);
assign edge_data_12[16 +: 8] = 8'(packed_output_12[8 +: 4]);
assign edge_data_12[24 +: 8] = 8'(packed_output_12[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_12 (
.clk(clk), .rst(rst), .in_data(packed_input_12), .in_valid(valid_2 && ready_2), .in_ready(space_12),
.out_data(packed_output_12), .out_valid(edge_valid_12), .out_ready(edge_ready_12));
wire [31:0] edge_data_13; wire edge_valid_13, edge_ready_13, space_13;
wire [15:0] packed_input_13, packed_output_13;
assign packed_input_13[0 +: 4] = 4'(data_11[0 +: 8]);
assign packed_input_13[4 +: 4] = 4'(data_11[8 +: 8]);
assign packed_input_13[8 +: 4] = 4'(data_11[16 +: 8]);
assign packed_input_13[12 +: 4] = 4'(data_11[24 +: 8]);
assign edge_data_13[0 +: 8] = 8'(packed_output_13[0 +: 4]);
assign edge_data_13[8 +: 8] = 8'(packed_output_13[4 +: 4]);
assign edge_data_13[16 +: 8] = 8'(packed_output_13[8 +: 4]);
assign edge_data_13[24 +: 8] = 8'(packed_output_13[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_13 (
.clk(clk), .rst(rst), .in_data(packed_input_13), .in_valid(valid_11 && ready_11), .in_ready(space_13),
.out_data(packed_output_13), .out_valid(edge_valid_13), .out_ready(edge_ready_13));
wire [31:0] edge_data_14; wire edge_valid_14, edge_ready_14, space_14;
wire [7:0] packed_input_14, packed_output_14;
assign packed_input_14[0 +: 4] = 4'(data_12[0 +: 8]);
assign packed_input_14[4 +: 4] = 4'(data_12[8 +: 8]);
assign edge_data_14[0 +: 8] = 8'(packed_output_14[0 +: 4]);
assign edge_data_14[8 +: 8] = 8'(packed_output_14[4 +: 4]);
assign edge_data_14[31:16] = '0;
stream_fifo #(.WIDTH(8), .DEPTH(2), .MEMORY_STYLE("block")) fifo_14 (
.clk(clk), .rst(rst), .in_data(packed_input_14), .in_valid(valid_12 && ready_12), .in_ready(space_14),
.out_data(packed_output_14), .out_valid(edge_valid_14), .out_ready(edge_ready_14));
wire [31:0] edge_data_15; wire edge_valid_15, edge_ready_15, space_15;
wire [15:0] packed_input_15, packed_output_15;
assign packed_input_15[0 +: 4] = 4'(data_13[0 +: 8]);
assign packed_input_15[4 +: 4] = 4'(data_13[8 +: 8]);
assign packed_input_15[8 +: 4] = 4'(data_13[16 +: 8]);
assign packed_input_15[12 +: 4] = 4'(data_13[24 +: 8]);
assign edge_data_15[0 +: 8] = 8'(packed_output_15[0 +: 4]);
assign edge_data_15[8 +: 8] = 8'(packed_output_15[4 +: 4]);
assign edge_data_15[16 +: 8] = 8'(packed_output_15[8 +: 4]);
assign edge_data_15[24 +: 8] = 8'(packed_output_15[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1), .MEMORY_STYLE("block")) fifo_15 (
.clk(clk), .rst(rst), .in_data(packed_input_15), .in_valid(valid_13 && ready_13), .in_ready(space_15),
.out_data(packed_output_15), .out_valid(edge_valid_15), .out_ready(edge_ready_15));
wire [31:0] edge_data_16; wire edge_valid_16, edge_ready_16, space_16;
wire [15:0] packed_input_16, packed_output_16;
assign packed_input_16[0 +: 4] = 4'(data_14[0 +: 8]);
assign packed_input_16[4 +: 4] = 4'(data_14[8 +: 8]);
assign packed_input_16[8 +: 4] = 4'(data_14[16 +: 8]);
assign packed_input_16[12 +: 4] = 4'(data_14[24 +: 8]);
assign edge_data_16[0 +: 8] = 8'(packed_output_16[0 +: 4]);
assign edge_data_16[8 +: 8] = 8'(packed_output_16[4 +: 4]);
assign edge_data_16[16 +: 8] = 8'(packed_output_16[8 +: 4]);
assign edge_data_16[24 +: 8] = 8'(packed_output_16[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(2), .MEMORY_STYLE("block")) fifo_16 (
.clk(clk), .rst(rst), .in_data(packed_input_16), .in_valid(valid_14 && ready_14), .in_ready(space_16),
.out_data(packed_output_16), .out_valid(edge_valid_16), .out_ready(edge_ready_16));
wire [31:0] edge_data_17; wire edge_valid_17, edge_ready_17, space_17;
wire [7:0] packed_input_17, packed_output_17;
assign packed_input_17[0 +: 8] = 8'(data_15[0 +: 8]);
assign edge_data_17[0 +: 8] = 8'($signed(packed_output_17[0 +: 8]));
assign edge_data_17[31:8] = '0;
stream_fifo #(.WIDTH(8), .DEPTH(2), .MEMORY_STYLE("block")) fifo_17 (
.clk(clk), .rst(rst), .in_data(packed_input_17), .in_valid(valid_15 && ready_15), .in_ready(space_17),
.out_data(packed_output_17), .out_valid(edge_valid_17), .out_ready(edge_ready_17));
assign ready_0 = space_0;
assign ready_1 = space_1;
assign ready_2 = space_2 && space_12;
assign ready_3 = space_3;
assign ready_4 = space_4 && space_8;
assign ready_5 = space_5;
assign ready_6 = space_6;
assign ready_7 = space_7;
assign ready_8 = space_9;
assign ready_9 = space_10;
assign ready_10 = space_11;
assign ready_11 = space_13;
assign ready_12 = space_14;
assign ready_13 = space_15;
assign ready_14 = space_16;
assign ready_15 = space_17;
actor_1 node_1 (.clk(clk), .rst(rst),
.in_data({edge_data_0}), .in_valid({edge_valid_0}), .in_ready({edge_ready_0}),
.out_data(data_1), .out_valid(valid_1), .out_ready(ready_1));
actor_2 node_2 (.clk(clk), .rst(rst),
.in_data({edge_data_1}), .in_valid({edge_valid_1}), .in_ready({edge_ready_1}),
.out_data(data_2), .out_valid(valid_2), .out_ready(ready_2));
actor_3 node_3 (.clk(clk), .rst(rst),
.in_data({edge_data_2}), .in_valid({edge_valid_2}), .in_ready({edge_ready_2}),
.out_data(data_3), .out_valid(valid_3), .out_ready(ready_3));
actor_4 node_4 (.clk(clk), .rst(rst),
.in_data({edge_data_3}), .in_valid({edge_valid_3}), .in_ready({edge_ready_3}),
.out_data(data_4), .out_valid(valid_4), .out_ready(ready_4));
actor_5 node_5 (.clk(clk), .rst(rst),
.in_data({edge_data_4}), .in_valid({edge_valid_4}), .in_ready({edge_ready_4}),
.out_data(data_5), .out_valid(valid_5), .out_ready(ready_5));
actor_6 node_6 (.clk(clk), .rst(rst),
.in_data({edge_data_5}), .in_valid({edge_valid_5}), .in_ready({edge_ready_5}),
.out_data(data_6), .out_valid(valid_6), .out_ready(ready_6));
actor_7 node_7 (.clk(clk), .rst(rst),
.in_data({edge_data_6}), .in_valid({edge_valid_6}), .in_ready({edge_ready_6}),
.out_data(data_7), .out_valid(valid_7), .out_ready(ready_7));
actor_8 node_8 (.clk(clk), .rst(rst),
.in_data({edge_data_7}), .in_valid({edge_valid_7}), .in_ready({edge_ready_7}),
.out_data(data_8), .out_valid(valid_8), .out_ready(ready_8));
actor_9 node_9 (.clk(clk), .rst(rst),
.in_data({edge_data_8}), .in_valid({edge_valid_8}), .in_ready({edge_ready_8}),
.out_data(data_9), .out_valid(valid_9), .out_ready(ready_9));
actor_10 node_10 (.clk(clk), .rst(rst),
.in_data({edge_data_10, edge_data_9}), .in_valid({edge_valid_10, edge_valid_9}), .in_ready({edge_ready_10, edge_ready_9}),
.out_data(data_10), .out_valid(valid_10), .out_ready(ready_10));
actor_11 node_11 (.clk(clk), .rst(rst),
.in_data({edge_data_11}), .in_valid({edge_valid_11}), .in_ready({edge_ready_11}),
.out_data(data_11), .out_valid(valid_11), .out_ready(ready_11));
actor_12 node_12 (.clk(clk), .rst(rst),
.in_data({edge_data_12}), .in_valid({edge_valid_12}), .in_ready({edge_ready_12}),
.out_data(data_12), .out_valid(valid_12), .out_ready(ready_12));
actor_13 node_13 (.clk(clk), .rst(rst),
.in_data({edge_data_14, edge_data_13}), .in_valid({edge_valid_14, edge_valid_13}), .in_ready({edge_ready_14, edge_ready_13}),
.out_data(data_13), .out_valid(valid_13), .out_ready(ready_13));
actor_14 node_14 (.clk(clk), .rst(rst),
.in_data({edge_data_15}), .in_valid({edge_valid_15}), .in_ready({edge_ready_15}),
.out_data(data_14), .out_valid(valid_14), .out_ready(ready_14));
actor_15 node_15 (.clk(clk), .rst(rst),
.in_data({edge_data_16}), .in_valid({edge_valid_16}), .in_ready({edge_ready_16}),
.out_data(data_15), .out_valid(valid_15), .out_ready(ready_15));
actor_16 node_16 (.clk(clk), .rst(rst),
.in_data({edge_data_17}), .in_valid({edge_valid_17}), .in_ready({edge_ready_17}),
.out_data(data_16), .out_valid(valid_16), .out_ready(ready_16));
endmodule
module actor_1 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(256), .WIDTH(505), .INPUT_CHANNELS(3), .OUTPUT_CHANNELS(8), .POOL_H(2), .POOL_W(2), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(8), .INPUT_SIGNED(0), .INPUT_BITS(8), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(2), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .MULTIPLIER_BITS(7), .ACCUMULATOR_BITS(19), .INNER_BITS(16), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(2304'h400047001f00810061003600ab004471f12ca30247d33ec1cfc5d54dce2d09002800000020002500770070000400406cbe133316c1a7ff0f71511ef7a9f0e700d900ae001a002c00340054001c00c43f1a9e46088fe2f31a0ae803f74713ad00ed00b600580098007f00d00033004037d090d15be884d8bb57c02727ba9f1f003f004c003600d30036007f001a00e6fc3ba91307a2d211ae0715c25fd2757f0046004b009400dc00f0004400ba00b0e02c7ed32cc35a4487ba04fb0157a80d001b00e8007f00ff006100de00ed00a50d8100a5662d5bc7a69dcb06a6fbfd8700cf0096008f005000a600eb0062005f53c9ded3c626090dee1ce6f4397fd63a000c007f00f200580007001d00bd001e58b77f78bac5a5bd0c135316eaac26e6), .BIASES(256'hffff907affffffcffffff37800004e6effffb6c4ffff8a37fffff9bcfffff684), .MULTIPLIERS(128'ha00270026000f0010000a0044003a), .PRODUCT_MASK(16'hffff), .REQUANT_MASK(16'h0), .PIPELINED_POOL(1), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(2)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
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
    localparam integer DEPTH = 1 << $clog2(SPAN);
    reg [INDEX_BITS-1:0] write_index, origin;
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
    localparam integer STORAGE_BITS=(CHANNELS<LANES ? CHANNELS : LANES)*BITS;
    wire [STORAGE_BITS-1:0] banked_data;
    wire [WORD_BITS-1:0] stored_data=WORD_BITS'(banked_data);
    wire [INDEX_BITS-1:0] read_location;
    window_storage #(.WIDTH(STORAGE_BITS), .DEPTH(DEPTH), .BANK_WIDTH(8),
      .PIPELINED_READ(PIPELINED_READ), .MEMORY_STYLE(MEMORY_STYLE)) storage (
      .clk(clk), .write_enable(!rst && commit), .write_address(write_index),
      .write_data(pending_data[STORAGE_BITS-1:0]), .read_address(read_location), .read_data(banked_data));
    always @(posedge clk) begin
      if (rst) begin write_index <= 0; origin <= 0; end
      else if (commit) begin
        write_index <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+1'b1;
        if (pending_output) origin <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+INDEX_BITS'(1-SPAN);
      end
      
    end
    if (PIPELINED_READ != 0) begin: pipelined
      reg [INDEX_BITS-1:0] requested, first, alternate;
      reg use_first, use_alternate;
      wire [INDEX_BITS-1:0] offset = ALTERNATE_READ != 0 && use_alternate ? alternate :
        STARTUP_READ != 0 && use_first ? first : requested;
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+offset;
      wire [WORD_BITS-1:0] data=stored_data;
      reg [WORD_BITS-1:0] forwarded_data;
      assign read_location=location;
      reg forwarded;
      always @(posedge clk) begin
        requested <= coordinates[window_address];
        first <= coordinates[first_address];
        alternate <= coordinates[alternate_address];
        use_first <= select_first;
        use_alternate <= select_alternate;
        
        // Match the window's write-first visibility without depending on the
        // target RAM's read-during-write behavior for equal addresses.
        forwarded <= !rst && commit && write_index == location;
        forwarded_data <= pending_data;
      end
      assign window_data = forwarded ? forwarded_data : data;
    end else begin: asynchronous
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+coordinates[window_address];
      assign read_location=location;
      assign window_data=stored_data;
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
module window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_2 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_2_integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(12), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(6), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(2), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(11), .ACCUMULATOR_BITS(14), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(5184'h41fdc118220fe2eb87fc1109cb8e720f4c85d4b36bf4703d0c7ff20c0e0c3f1fc8df8cc1448cffffdcecfb1b1adf9d2b14f64e3bde15e00d0bb791efffcd2feb2d3e0853b2d763326b350ed801400fabfaf091f5d7de74207202183b95efa2cbf491f5fc0582144e3f37e4362c4cb0d82f180e3d41016b4ae7b9ccf35288c8cb02db5d41c82ffc228bb83c517edc223667521f38cfb406fe31237b251447f775070414fc72e3718b306043bf2e42105fb61b710258361523700c1072264ea52e305f360caff43903c5285f0e1fdef6d4868eced04af84cf7ef70f6eb3cfc3e75cb0ce0095491c71e9221088d28034ebee0600cc2bff41be1b9c7c3cb275c48203e49f71068005d0487c1087c0242283fc7c4804b2fd4d2cf87f3312c8c20c14c20114e078eb6c3e466382608143ec82d6149f7327bfbfeb9d8108df90fb7fb40c8ec3f0602e14bdb6baf24e107f04dc22b1fb6f381903c004b4742bdb7e2c6180e0af81e00f7cf83fc6394fc1bfa205dc417ccbd879a0ffd6f13005e82cfff3daffeb90bb61f0bc86ec70ec7484dfb1ea0701360c7e4c2fdc284ba03bfc824bf3ce460ffcec18b00603af7befedb1133f6effce8000854cfcbebed49c6ff49cc109ff74f80dc9149198ebddb8d6b1c1d4ef48e42da1f00e9a0ba63ee48cfd078ff2fc0fedf91cb30fedcfbbf149105d05fcc10baf8e4e179fe6fbb431d4fce8e82ccd03e92307333af3bf46cfacf2bc5cb9248bf3097f2c203e021ba0c7e03db80ca0be07f07c089274276d350d0dbe001dae1c900cfc21842760b72c0d34086108fbf494cd17cce3d174ff5c45ecf0f90cad871fa1c61b8fc5f003010fce3f23bd09143e7ef40485cf51f50c23f6105869574e7cfc108014301137df3e0c7efe047d3a4cdf48f3d), .BIASES(384'hffffff83000000280000001fffffffe60000004000000014000000baffffffdc000001580000006300000068ffffff3f), .MULTIPLIERS(192'h1f3022703c203d3022902aa034f02f101ed01eb0393043c), .PRODUCT_MASK(12'hfff), .REQUANT_MASK(12'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(2), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(2)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_2_integer_convolution #(
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
  actor_2_raster_window #(
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
    actor_2_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_2_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_2_serial_product #(
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
module actor_2_integer_sum #(
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
    actor_2_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_2_raster_window #(
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
    localparam integer DEPTH = 1 << $clog2(SPAN);
    reg [INDEX_BITS-1:0] write_index, origin;
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
      if (rst) begin write_index <= 0; origin <= 0; end
      else if (commit) begin
        write_index <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+1'b1;
        if (pending_output) origin <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+INDEX_BITS'(1-SPAN);
      end
      if (!rst && commit) memory[write_index] <= pending_data;
    end
    if (PIPELINED_READ != 0) begin: pipelined
      reg [INDEX_BITS-1:0] requested, first, alternate;
      reg use_first, use_alternate;
      wire [INDEX_BITS-1:0] offset = ALTERNATE_READ != 0 && use_alternate ? alternate :
        STARTUP_READ != 0 && use_first ? first : requested;
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+offset;
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
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+coordinates[window_address];
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
module actor_3 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  wire [15:0] stored_input, stored_output;
assign stored_input[0 +: 4] = 4'(in_data[0 +: 8]);
assign stored_input[4 +: 4] = 4'(in_data[8 +: 8]);
assign stored_input[8 +: 4] = 4'(in_data[16 +: 8]);
assign stored_input[12 +: 4] = 4'(in_data[24 +: 8]);
assign out_data[0 +: 8] = 8'(stored_output[0 +: 4]);
assign out_data[8 +: 8] = 8'(stored_output[4 +: 4]);
assign out_data[16 +: 8] = 8'(stored_output[8 +: 4]);
assign out_data[24 +: 8] = 8'(stored_output[12 +: 4]);
  integer_block_pool #(.HEIGHT(128), .WIDTH(252), .CHANNELS(12), .KERNEL_H(2), .KERNEL_W(2), .LANES(4), .BITS(4), .SIGNED(0), .MEMORY_STYLE("block")) actor (.in_data(stored_input), .out_data(stored_output), .*);
endmodule
module integer_block_pool #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer KERNEL_H = 1, KERNEL_W = 1,
  parameter integer LANES = 1, BITS = 8, SIGNED = 0,
  parameter MEMORY_STYLE = "auto",
  localparam integer CHANNEL_WORDS = (CHANNELS + LANES - 1) / LANES,
  localparam integer OUTPUT_WIDTH = WIDTH / KERNEL_W,
  localparam integer OUTPUT_HEIGHT = HEIGHT / KERNEL_H,
  localparam integer WORDS = OUTPUT_WIDTH * CHANNEL_WORDS,
  localparam integer ADDRESS_BITS = WORDS <= 1 ? 1 : $clog2(WORDS),
  localparam integer BASE_BITS = $clog2(WORDS+1),
  localparam integer CHANNEL_BITS = CHANNEL_WORDS <= 1 ? 1 : $clog2(CHANNEL_WORDS),
  localparam integer ROW_BITS = HEIGHT <= 1 ? 1 : $clog2(HEIGHT),
  localparam integer COLUMN_BITS = WIDTH <= 1 ? 1 : $clog2(WIDTH),
  localparam integer Y_BITS = KERNEL_H <= 1 ? 1 : $clog2(KERNEL_H),
  localparam integer X_BITS = KERNEL_W <= 1 ? 1 : $clog2(KERNEL_W)
) (
  input wire clk, input wire rst,
  input wire [LANES*BITS-1:0] in_data, input wire in_valid, output wire in_ready,
  output reg [LANES*BITS-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg [ROW_BITS-1:0] row;
  reg [COLUMN_BITS-1:0] column;
  reg [Y_BITS-1:0] block_y;
  reg [X_BITS-1:0] block_x;
  reg [CHANNEL_BITS-1:0] channel_word, pending_channel;
  reg [BASE_BITS-1:0] column_base;
  wire included = 32'(row) < OUTPUT_HEIGHT*KERNEL_H && 32'(column) < OUTPUT_WIDTH*KERNEL_W;
  wire [ADDRESS_BITS-1:0] address = included ? ADDRESS_BITS'(column_base + channel_word) : 0;
  wire last_channel = channel_word == CHANNEL_BITS'(CHANNEL_WORDS-1);
  wire last_x = block_x == X_BITS'(KERNEL_W-1);
  wire last_y = block_y == Y_BITS'(KERNEL_H-1);
  reg pending, pending_included, pending_first, pending_last, forwarded, output_pending;
  reg [ADDRESS_BITS-1:0] pending_address;
  reg [LANES*BITS-1:0] pending_data, memory_data, forwarded_data;
  (* ram_style = MEMORY_STYLE *) reg [LANES*BITS-1:0] memory [0:WORDS-1];
  wire advance = pending && (!pending_last || !output_pending || out_ready);
  assign in_ready = !rst && (!pending || advance);
  assign out_valid = !rst && output_pending;
  wire capture = in_valid && in_ready;
  wire [LANES*BITS-1:0] previous = forwarded ? forwarded_data : memory_data;
  wire [LANES*BITS-1:0] maximum;
  genvar lane;
  generate for (lane = 0; lane < LANES; lane = lane + 1) begin: compare
    wire [BITS-1:0] value = pending_data[lane*BITS +: BITS];
    wire [BITS-1:0] prior = previous[lane*BITS +: BITS];
    wire greater = SIGNED != 0 ? $signed(value) > $signed(prior) : value > prior;
    assign maximum[lane*BITS +: BITS] = pending_first || greater ? value : prior;
  end endgenerate
  always @(posedge clk) begin
    if (capture && included) memory_data <= memory[address];
    if (!rst && advance && pending_included) memory[pending_address] <= maximum;
  end
  integer channel;
  always @(posedge clk) begin
    if (rst) begin
      row <= 0;
      column <= 0;
      block_y <= 0;
      block_x <= 0;
      channel_word <= 0;
      column_base <= 0;
      pending <= 0;
      output_pending <= 0;
    end else begin
      if (out_ready) output_pending <= 0;
      if (advance) begin
        pending <= 0;
        if (pending_last) begin
          output_pending <= 1;
          for (channel = 0; channel < LANES; channel = channel + 1)
            out_data[channel*BITS +: BITS] <= 32'(pending_channel)*LANES+channel < CHANNELS ?
              maximum[channel*BITS +: BITS] : BITS'(0);
        end
      end
      if (capture) begin
        pending <= 1;
        pending_included <= included;
        pending_first <= block_y == 0 && block_x == 0;
        pending_last <= included && last_x && last_y;
        pending_data <= in_data;
        pending_address <= address;
        pending_channel <= channel_word;
        forwarded <= advance && pending_included && pending_address == address;
        forwarded_data <= maximum;
        if (last_channel) begin
          channel_word <= 0;
          block_x <= last_x ? X_BITS'(0) : block_x + 1'b1;
          if (last_x) column_base <= column_base + BASE_BITS'(CHANNEL_WORDS);
          if (column == COLUMN_BITS'(WIDTH-1)) begin
            column <= 0;
            column_base <= 0;
            block_x <= 0;
            row <= row == ROW_BITS'(HEIGHT-1) ? ROW_BITS'(0) : row + 1'b1;
            block_y <= row == ROW_BITS'(HEIGHT-1) || last_y ? Y_BITS'(0) : block_y + 1'b1;
          end else column <= column + 1'b1;
        end else channel_word <= channel_word + 1'b1;
      end
    end
  end
endmodule
module actor_4 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_4_integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(12), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(6), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(11), .ACCUMULATOR_BITS(15), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(11664'hbd2dc0000a47c04000190139000b88337000293b8f000d823510000ce193000a40175000d32417000afbcaf000d4e1cb000108d45000e7ae3a0001c1107000f033b7000b3e43e0001f7b9c000cb70c8000ec04010009c6200000e05304000fa958b000f8904a000033ec30001071c00003f0f3e0003c8d40000c750ba000dfae3b000f73fff0000fc04b00000117d0000920ba00002b007000341179000226e40000ff7c9f000d2c949000fb31ff000b7d949000fc1151000ff584100023ef16000840c47000ef900f000e7f03a000de5858000c2a9130001bce880002ff34400030a33a000b3a087000e24d16000e27a3a0001cfdc8000b4ee810002161b8000f7b4fc0000e1f0f0001021cb000ef8d7900038527f00008aa48000e7ffc6000e71f3e000eb1f3a000ff2f0500030bfc500020a143000004ff1000f3e433000fbcf52000e41b05000c77f7b00003e37d000eb7373000348ffb000109205000c41fcd0009faeba00013b0bd000d502fa000e93f8400002dc1a00023ae460001d0cbb000102204000c341f700016bc7a000e120bd0001830d0000a65bfa000e49e41000e98188000ec5e430002053c6000080f7d0004badc300014bcc1000df4000000004c7d0001fc281000ec0f0c0002fdc07000dc8000000efd17e000143fbe0003ec0bb1321b81f3f3f10f3a40f9403d47fc5f78cafdfe139f00e47d5dd3917a1edcfb050eb7084ffde7ae7f9c22ad1300f63060f5febe0bf38ddfe05bb7ebaffcf72345b7349314f26a7f80eef85fb0e074042ea0c9cbdaff27e07c279f3a0ba984f7e1bd16d339dfcf3efb10fdc77ec707813a082e680eef00eae3411be1f6d30ff61c7e44ec4dfbfead460bb1c6079ff3efdf3df4b152d2e101007fc82463f5f351aadad282ffff32cce6491c2f92033ebdc3a2f83bc177179294b1533818132ebc5c408534980353f3a41f0427c0bb1c8f88111cb1f82085ea12d4f5417127a845f862c824330ecc900e647df1e0fb4af4510307ddcc397bc7e73d2b3fd0fee70ac2384fc3f71ff1d13fadd2cfbf1faf8728dff0240be32c908bbf220e24cb7d1400082a10c2f92d3e3c8d79448d85153efd03cb46273fddbbaf83fce204174f8904bef20f5f46e372d616c16a0f8013239ebcfbcfebf061fdfd0f04f0827d0c010927e108df23edfc91c2bb217d17d1f2e3eff4dfb0c6263da9db614930507d20fc50507fbd282ec3ff0288ffff86ed5e0d53dc3803fd8edbe178d8ff5c005eb3132f80fbefb90b9cd8182fc0daf0bfe8cff7e32fbff8ed3abfe00b0fd379443da6441f800b6145f81f4af81f84ec6facfcfb45446e3d3d007b03b2d4e42f120bd1820aeec9ff8d86d7f076dedfecb34c01040cc9f7fff3e08beed40db5035f86324f09e4948a2cb002fcf371cf4e70f08fc1f3f33f3bfdb8e6be831dc076f85dbeb2693dfb4f36f00ab9c7a089856f38009d04f393cb0af2c7e7f3093b7f74df82b5a7e07b0b70f528118d0fcd030b82b81083b9005216afc443185135103361d10bbedc2202d7ae45f72ab9329e49ffcf43001fb62cbeed04feb4efed341f7f8ef7507be7a1b4382dc6df616d1b622c086e25fc3f0cecb1caf75dacec2ef4da1ec05b733b13cf45cf5444d91642d861b233ae73d75eb31853c30b2f0137ff430044f0878845090f80002dc4c52148f87dbbf9628b8814c84820814d2deae79b3dd58235251fb32b3ebcebef73f793b2bc0e382952ff1c81b3dfafdfc47f7edf3e8811a8ae19b5bcffd20acca0ba3920422ff1c314ecc4e401761d2bc2131e02b4430ad7b0c60f7ecdf9a2381004e1676085d392371380281bfd87f831f324e1f51bbf3519024a601ad023c2870034ed0c4ff817b17b98ecb9dbf2741f003df4634503c2f11311482bdfc2d80ef2304037f3fdcae7f243c00c86dbcc7dec40770eb1baffd43b20a0f04370cbf0b33d52f54f2b8fca0bb07b0c6165d7b3ce04c13eff70ae409f3bd751efec41fffb617cf26cf803df7dd860fd18afba000fb3cf9078140e352c4137e7decae5c), .BIASES(576'h15500000106000000f9fffffeae0000009effffff6800000048000000daffffffb00000011700000080000001b700000089ffffffceffffffffffffffe5), .MULTIPLIERS(288'h16f01f702190332048902a103310200023d023102b701c1028603db030f026e), .PRODUCT_MASK(6'h3f), .REQUANT_MASK(6'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .WEIGHT_MEMORY("block"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_4_integer_convolution #(
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
  actor_4_raster_window #(
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
    actor_4_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_4_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_4_serial_product #(
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
module actor_4_integer_sum #(
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
    actor_4_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_4_raster_window #(
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
  actor_4_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(STORAGE_BITS),
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
module actor_4_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_5 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  wire [15:0] stored_input, stored_output;
assign stored_input[0 +: 4] = 4'(in_data[0 +: 8]);
assign stored_input[4 +: 4] = 4'(in_data[8 +: 8]);
assign stored_input[8 +: 4] = 4'(in_data[16 +: 8]);
assign stored_input[12 +: 4] = 4'(in_data[24 +: 8]);
assign out_data[0 +: 8] = 8'(stored_output[0 +: 4]);
assign out_data[8 +: 8] = 8'(stored_output[4 +: 4]);
assign out_data[16 +: 8] = 8'(stored_output[8 +: 4]);
assign out_data[24 +: 8] = 8'(stored_output[12 +: 4]);
  integer_block_pool #(.HEIGHT(64), .WIDTH(126), .CHANNELS(16), .KERNEL_H(2), .KERNEL_W(2), .LANES(4), .BITS(4), .SIGNED(0), .MEMORY_STYLE("distributed")) actor (.in_data(stored_input), .out_data(stored_output), .*);
endmodule
module actor_6 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_6_integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(3), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .MULTIPLIER_BITS(8), .ACCUMULATOR_BITS(17), .INNER_BITS(17), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(27648'h2cfffaf316d2fbfefaf9f611c2b0b7f1e1d85ed8e6e0131031a7e1fa4020be2021ecf4011b00bb04fecb080dfb0db71e30132cdf2f0911ebdee703fd3605ea1229d4f5ad10d80cd12cfc0bef0ff7d82121fee4fc11f4d4e8e91be003d526bf001e0c18fbfe100fbcc3e0c6177d59ee3d020f34f703eff10d23cb20c4fe16f7297ff5ecc224f01df2d40ef91527fcf314101de503d8f3fce6f7ffe11103e1061d28d9562e1af739ad3802e01436e504f90e101fe7157110ea1a0bef0bb4c9e1250e2f40e02e0cf5f6d9cadef4e8735101f21527267129efe5351104590af9f525ca4fe4f74449db141afb0816f3c2fa34e4f9131ef91d3df0f40d1833014a2c1a12face622efad2284720d63923ed241bfe0914f3ff29370fe936f11c41dbf80618c8dc211ad5dbffe7b705c91ccae101e70f16eb210000fd26210918ddd249ee0b35af2e0532ffc9eb1d1812e5f2212b3cbb1531cf0301cd0fc905f0ad2650e304f791334f4fb63a19241518f7c43ed2e434db2c131720e73d1119ebfecfdc2720e526dbf408f02e99c30722ec02e9bb1bfc817ff3ece44dcd1bea2afaf4341e0035eafafaebeec5edf81bd944c806cb94e4f618f312f0fb1f01170ad92603bc11092113a441111c024aed4eb1033ceb3635e1e441fbe51900d90cf203f02507f1c5ce4afcd8c300fff2f7df79d3e1ebd0f39bd1b6e4cfdf0ae3cf0d26e725f3181fefefe6070cb9250add290f28b9ebc41fc7ceece99917e3baf9f1dd94df3bbfec7fa0e6cbf7352fce250e7fdb2521c7f00c1b2d0c249f0808f5e127e8ccf400c8d8170e351815f70cc6dba4f8d2af54189b468133e0e6f603f925c5e5fcc10d03e10994d0eaf30d07d8fc0bed30fc14c987fd31f6a8f821d91d09dce2d1bf1e0fd6f6e5292430e9faceca10d91d0410fcd2eaf3170828051f302738f6f2e1e5d9cffffc2be204d60904d75c2206fde800e9d9e2ea3b212ae0eead2c175416e0171b1262160f1dd115d7fcfd41ded0f5d4ce36eb0ef0ffe9051b05f8cfbeb64a10e10fc60d33ddce08353ce20a35ea3e25f6e8405cc326fee9db3add15220015fab2ed3312ea0ce5c2eae52c19f0ef2c16df71a4d4692bcee5100a09142cf139370c02dc2d0b250414d92dea20e60fcffbe0f57c1f0aefd663fbf14f010d0fcd2eba1e00f403131cd408d8d03041180b1022e409232415fdf943cc2353f104d0810dc00bf2b7e9e510e5f1f5e4f03631fe4d1bd814ad1c30cafcc5fefe55f72403e52b1fce31f2a10846413ccacf09e7da120dd71f1ff2c5d02ed9ed3515201ece51fff925d540f8e3f4cd37e8ce00f90b231d2c4d02b81b1177f01618cd090af7f8e22d25b0e4c3dbd61908f62859d8f0dab11e0b1803c2c20e0d1cfcdd1c2dd8ea1213bafafc0be736f32508c213bd85fd0afb37f50100e8032527c5dedf5a041a141d2b080c0a31fff139235f30f7f4e5211f4f03d24e15ea2727b0bceebaf7fcc615d5e72ad9821421f52f532e5114eedce4ff121a005427c4fcf1082c0035f60fcc6142815b25e20a0cf728e101fbf3ea1bbdf3f9f9f3ee13b2ef1e59d2f1ca3b23ef27d1e0b425360fffd33bca4a2e0fddf224f74a001c3ef5290402e5b2f5d532ffaaef1207d2f9271200f21eb2f1e3ee1bf8022adcde27f030fbceff0e101cbdf72907f03c9bc7f12498f219c0e1bdfcc7e8c8ecf9110c1d397ff002e41b102704ede31b24ea25bef3e9aece430ae3cdf4d2931410a9e4f8dec7e9169001df15d0da92f9f2d6d506cee767f702bd0e27e3f5f106033105dce4d0d0d030ce202d13332c08d71a0321d1a416cbbc30bd2116e3fdffeb2a3a1256ec1adf0b2ce7027ffee3f73b11180be4cb11f70c1be8fbdbb9f3f0f42a24eedfe21e0902f4182fddcefc1d00f532f60bd124e7f80c002107f0fef60eff07fdbdfe00daf70222bfeed6e0fbeb0b10063315f92dd11034bb190b01f3edf8ffca81e9cb0be22223e31ad5f002d9de24e2d8143bfe031321cc0e2617061fb22df044d819c21f4d8af3161f3318ed05ffe33fdd01d7d44f21db2014feed08d8f02953a44b2a052d23d7ead9eb3e0be6f8f9d8ecef23d421c32ef82cdb27f50e3ae51917cef0c81b0f8e2c3df3ffdcccbbf429c3e2fae755079606fcf7cfffeffddb59ede65e010ebe1d2934cc021f141ca9bd10bcfefead3381e322e934ebe604fc2409cefcfa220893e6ea11af0c0e0cf770330ef2012befdf2bd702ed32eef0c1ff0a34220cfd60f9104324071702073935d64c0535dc0bd02d08fff83de4f9041ef8f003fb2db426f9c1efedb801212523081602081ceddafe2b242a25e4d5e21fcac81b2402188d47f217c00ff315ff0c2123233126dec8f616dcdef5ebf1d6dad912e21806ddfb9c1415192413a6fe09ecb804f4250b8d25d209f5f61c21065e60f928f0f501cee9e9e606f924e5e6fa2d27371c334b111416eced35ed0c232fb0fb18d9ffefb6e9b4eb09e8582020c6e41143edd3fe1fcf3629110b02eade2ef5df1fe7f818fff9dd30170e02faf1d78117fde7f3edeed6fd4140c21901514bf20ff281ead90dfc00e007c4ec0bddebb9dd27e5be090b9cd5ff1e2ce118ccaf6ef119f305e61da82badeffef626481a11241eec1721fe4707021312b0231cefe20e0213eb0b2f0ef0eeb53dd7d6c748aff1f80ef605c7bde012d31f59f408faeee167feecd2cd3c13ebf8370b0fec080308ebcfb95bdbe6b3f01d3ba0ea0afe8eea5dc706d91f240e6d00c5220e070e12ccb10c811d0f2e0c34ceca1b1a16ddfdfb3cf3eaf2f425e0ee240ce408d8ee5c165e9f1c0fa1cfc18ffe0d000e0eea1d0904c7031cc51cfce9e5e7e6fddb2204295217650af019e9d7e950ee393a63bbe4ed3be82f2025e3044ffe153202ca1300fa0efa45dc1410fe0a25cfe5f911bbef39e018309e15f206fe0ee4311eed18041827f63b2032d4fcf5b41533e4df1cb6d408a2f2ee13ca1e1ad409e71ed181dd1cbadff0cf2ce815081acd0772d73fec12c4d017d415f1df2c96d7f7d4d516c3fc27cc0c0618d626073a40404aafc5f848dfbbf7d4da18e8eaf30d3332ec2bfa00085ac3031917f1ba23ccd61a1e09e0b51e01edf8fef4301a00095802ebd7fdea1ac6d3e321d21fd101ecf717e34621ff301fdd30edde2e09fc3fb8c3eaeffec9ecd3daf822a00d37d900391149f3bff32bdaed0705a517f5fc02b52af2370f1529192523b4c2fced013ff6edfef610fdbef866e41819f1dc2eccf323da21fddcf821eb2cef1e2ddeeaee002c13271016d9eedbf57f5c6512f5fd13f7d3d01db402c74d18092200cf4ff5cd1835be0af6eeebe5c50fc1e90bf5951c3afb52c0e50ebb1a30e7d5511fdb302b40fa2facd813ed14040bee1900fa18c08196b52821cef42db951ddde0bcd9beec03270eff5191e1109e0f721b7813117e2f5d3dc02ddec12402acfeaf3dded96ee6233e3db1600d219b3462234f23bcdc411d9110bbeabd9c8341f090cefd91bfd0a5f08f5b0d4f5ee34e1ed29d5fcf8b9b4e8db01f8f00afad3e81b2bd0cbef060fe6f1e4c5c20fa510c7d810b0e603ecb515e7b844052904f6c24ce933d5db0020f7f53334d9e3ebf4fbfcf71e07ce4712edfab6e129dc2c00f6f716d9160ee0f4f9e42c811019d60007d7261fd0e0a9db403cecf62795f61a06fad7ce0be4fc07bcf5f3e922feb6a4de81c7f90f3a0edccfba189e400407e81223f53e1e179f1633b220f49c16f7fde33300032d16ebe721b8cc30eac5d7fbe19af3ecc62eb307d1051602192cc7dc12f6cfc902fbed223fb4fc3d87fc07d9baf58b162125fcebd9d7da4340f62e1a3aa70211d4c623e7330512d1331b1e4439a00c16e4050df13cee291ac29fb2f1370afbabfd080e7f1400251e311db8e3e660c5fedb28d7b2f1ac3cb009f42cc3e9101835f721e0f35affdf188e3aeae7191dc2bc0f50361ef4f5de240ad3eaf60d25f41df64708c80d0e0a061cd1eaf703d70b04e8fca55710bafd72fd0ef12c2628c825ee4fe0f619f0eb2604f0400516c6f1e632cd49b407ca759c42c112e73bcdfde20cf9c9fb07000bff2ea2a2000ebfe9d2eb0ae10ff9df474e1eed06073619fb24ea3d280ebae235b81dac364204c3cb2e1b02efdedcf339e50cce160e09ebfe08fb3806e24df6c4fe04d6e31c0af1ddce27341f0b06dd241a21da2143b9faf9091ded0d1ac61404fc1f1c1c24ef2132f7b1142b243223fa0cf5f232e9e32039d73cdc1c4ff8eb0916e2023e25f9130ac6231c1b09d8df221ccef51111112f1412d504fe67e0f84225e2dd2f2221074309110df6f8fd1cd2daf8d6ce2a360faebc1ef8fd1ffb1bcbc40b0809b1422b0d01fe1beaf6db00e4f6ce05c231109cfff9970dcac70417ed11b49bd43131f318ba13f597ac18af03042e3d1d131101e511241f1edfd43ac7f60115c93ae38116088f1fcb041107fd324eed052c1beefff40b2922ac27f0112800100e2626f7fedf36da1b4cf5043d5d0f08031806cdea4e2efd2ad7fbd92419fbf762dcd62017ea19efda7f6818280ab0c31108c7ceeb344204d706baf3d52fe5f49bf3d3b3ded6a82601f11b5948e503aa08f1fccf31a1c89ba9b89c04262f0217572df806ddf760f7e51ef1e0b70dfbfafe3c09ca0d42d657c4bc061f1bee2115b7e801d704e9120413d3c0fca31cddb5da2601041bb2bf1b017ffc072e46110d15d32152e4db30f34306c9b0080c243035e4d8e3ecec9fd2380e584bd7fec3aa28dbc8adfeccd708db0d28d107c91ae40ec2c33fff0b30134a25ee1a20e0f6f031cfbdf233f401d1eb60dd5c14c913ee20e42ecc11e3521de02925f3e3f747b51518271fddc92943eafaf704), .BIASES(768'hfffffc5bfffffcc3fffffd8fffffffe6ffffff7f0000058b0000040c0000012efffffc2d0000062bfffffd3d000000f1000001a0fffffba8000006bd000000e40000014c00000896000004c10000051ffffffe3a0000077f00000064fffffbbe), .MULTIPLIERS(192'h9f88c78198b58866b774fcdbac696790f2645aa0ab569bb4), .PRODUCT_MASK(3'h7), .REQUANT_MASK(3'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .WEIGHT_MEMORY("block"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_6_integer_convolution #(
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
  actor_6_raster_window #(
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
    actor_6_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_6_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_6_serial_product #(
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
module actor_6_integer_sum #(
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
    actor_6_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_6_raster_window #(
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
  actor_6_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(STORAGE_BITS),
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
module actor_6_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_7 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_7_integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(24), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(4), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(9), .ACCUMULATOR_BITS(18), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(41472'ha6ff1d29ffaab7fceff0590cec01e62d35cb12e82a191002f3b259f344c7ffdd1dda0ef1d9fef603020225322cd124247f9860f9133721a93ef01dd1eb942dd6253cfdadf021e9d4243acefff5a3022afb0132df3720eb1213ef0736d21deb13bed30ed5f3b7dcfcd1af0120be54f9f04dfdf3db0df5e498ceac292ce6a9de02e3bbd0f9dd2d0f3ff199f014d5e8071ceabffb002fe50f1a1adb00f9f4d6c3fbe0d76927cb170c11fc10092b1901ecc4fedee713131625dc0acaf503ecef0dfa350e0cda11ca10e1c6dc22fa1a01e12bf1cbf218eedee0e12ab2026124ffc5f8f5e40beae6f94136b5e9c41608ab1ed5f8fae5e51f16e608dee01110f0b9c11df9ef2e1ffed32d21f3fcef41f11e09a4cb04cbf8ece5050da8e6c6d72a342c0af5d7f4fc06c3e0d3e122193cc206f31a0eac34d904f31a2adbd3230c3089ece2e904ac2013efff1622ff4fe8da11fc4a78e01b12e623fff73dfa062134931114dfc1fc150949edff2013480e2ae2d9365b0cee38261de52dfcb9181ef325d31ec8fdf9ee07cd37adbee7f56ffaf5bd260e032cbc3bdf05c004af2801f781e823fa0a0b36d0f20350dbdb1affd1f1ef26e6d1e706f620d53910d10824e6d1e92de4f43950153f3ec813f0ce1011f6def9eaf82c0e3306ec03158ae933f8fcd8fb041b0a140deb0001cfd71102d928014ebabc17f1dfbcf80bc49422ea0dafe4f81bcfe81fddf9f0f7e43025ea10c7dbbd0b08e13a35ed05f9c4c7dc191281af3f2e034b030ffa0cd929f9eac93a3a73e81328f11ff615392fe616fb2b3cee05db1ba20dc6df11ff0fdf34ca04b0f9e0d6eedf17e22ef5170e08a640e2e7bc011af2cbebf0f11bf92cee282bfac5f714b21ec9eadd099bebeb2cf508ec23aff7be08291758efffe881faf9e3405630137c141304050a4fe704ffdf23df07f012f9c3cdd8e3fdca14001d36ed2e042cef01f0c0ec15ff1506f1eba760d01deaf6f9fff20ce8d81ef039e72f10ee0812e3d20918fa091be002000b1710cd1e90f2eb0233ed36f720ffb6c0fe25e3eac22346ebe164e80629291b3ebd3111dd1bf6db2a0bc6cb10cbfbfdccfb100a0fa90e13a4b001e50118dedbeba322dd1709fdf3f4fdf31ed131efd6fb0d3f2d0cdbcfca01e20e4cfcb01248ea0a13040ad9f73d107f05022315068b1a242cf8fe687ffbf9ca2643d7353404fcb80cd118f7eaa91e353111cebdd4010dc7091df8d5eefc05181bf61b12b9addde30dcbdff0d4012806251808f3f01124e71406137f4ff2d428fbf1ebfde12e3e22212e12fcd951071efaf609fd17f60c132afec12fe2b81e38ea28fefce7cf7f3de2f30f0f02e9fe2b0119cef3b22505c6080dd9f418e8f6d1b119f00c2412fb28224ab71e28f6eaf7ede10eebdffdf5d0fff1272730cf1bd9fff91d1be1d4ef252c400023302ff7d5bf651dd3d9ea1d00d9c9f3e5074a0eee062e11f20ea92f1b3149e13f22d53a0a3052dce9f5ed0ee8fff5201c11d1df96c209e2f806f8fefd4f23d2ebd4d3f33d05d21af6effadf05331d001fd80b0efde54030350cba15b5504fa2f720d10eaffcf9e6d9c6000bf6fdda2f040a3c02ff175cf6cdd5eb06ec4d36fb270012f931fdda13f9f6ecf4f20d6b1fcf05dde2f1e4270e25e4eec6ec223bcf0bdbecd6eed3f0d6deec0a14e42c0e230206d6af13f9d2ccdcb0290129ee13f43bd721f340ee28235c742c363323b70431f6a21103ceab1ced34e1520eed15dfe6efe2d91c0ada1713ecb513cff230f60866ecf2e500db16fe2e01ce1f4553bd11a3f3c90fcec2fbc30be3d1fddd2a1d431f1ee52ae6e3edf4cb2915ec0531bb1ce3441dd281db45ee435f07fe1edc01ed36fdf8e021ea21ef26bb2de803e1d1e6ebbc41f5e4e6de0ffcfb50e541bbd1ed41aaefdbcc4101c5191edc02053be0df10daba1520be01c9f6e1de071a164907264b01c8f2a9de01d2d60ed4d641da1705d825cef8ee0de9146608e04202e503f8faf50309f212b9f9b2df262bbdf91eef89ffc7f0b4ff0d0047f0d0e446f3dd45e3e409f4121c03e4dbd5d5edfcece8cbca03ec17f7e9e9f648f4e91fc0cf2539d7c2084cbadc11d2570002be98fc28e897dfee151a0a13d23a09df5028f81cec8b3807b6b401094d31fe13f7a0ece7c81b47c9b5f6e91ef13bf4ba1d6b0ceb25b9ecdd162918dd3cdef7faeecdc82ae1d4eefd41d415e90cbacf1c1f57d141ec05e805d3e1e330be2e31dec7b6f815f50dfd35b31240f9ac6efa2015fe16eafdeb0300f81df10ef734f4d2efd1d415f7e450f0cddbdb1e2ae02be24eade70439ed09c71a28e8d61f14f5043744fe22300fde1519f7e0f721be040f4126f50c5918c9f434b7c628e8ed1aaccbe7001ef933fef93bf42c2cf230fa105754f0da07f3eff34ea9d5f8d97f00ede1d32df6d5efb4202dcb47f9c0feeed213203f1d39d718b81613f533dcc5ccfc19eb16cecf010fd6d1fd21dfcb1630a3ef3dcd0cfcf33ed4e81d1124ef2f22fc6de7da2507f007e6147ffaf413f1ac0403b533290138bc0dec410cf512dccd09f5fe2700d40106ce3919aadedede23e410383bfe36f619398cf009fff8e4bbe65b52d346e808fe21ba200815f0f85eb4e22d141bef21f7f6fd28f40607d2bb12204ff402e031961be9e8f6100bedc9d6f0f0f234bd20f21be7dceae4f201112e021a38dfd7c723f306e3b3232cc6e2fdeb1b4faabfde1736d8cf850eea1401dc1f2da415391cee2df6e842d9afd52a20e40a5d17abdeaf2ddc2e2dfc37e5f0e2dc32e1740e31c513bc2bbe049f0de1ddf41effb6c9f201f6d3f50db79e3fc00b622633beffc01225142609bffdeaf8e8191919d9fde90cfbfa13d4f64ebf0eaf4ce23c17c7fd4237aac44eb90013cdcb4b2210d15722efca2af707d503f9ec325bf4f3f1c7ff659356b914fd3f01f9c13be02f1915fa3700ed260ed051e606f10aed3630cdec09d7fc4d1fe2a6ec180bde0864e112276311aabbe7be54fadac93d30cb2ae9d901f7ec0af2e122ea52eee7f91a156a145e0d18d3eef1d6d4cd14f52debecd4eb3ffdf3d5f65f34f524e817c43614120a02290d082c3371f50711a53622ccb6e651d84b230af6d2bcfddb111406c73901f6c30320a3f63310f5120733d0c81404b20dffc73be50dd6055ed5c97f1dfcc5e0ea1340cffbf8dce0270f3cc8259bfaf626ca21043ad2df36d3efd7fbdf1e0bab02f8050b1af5eeed400e380ce3b99af1fd819afdcc06eaca0eca55350feaf40481de000b1106e6ed1226aa1bdc0a9cf62535f5fea60b1325e61225f82009445ee7f00f0cde0ceedd4b0cfefe09f08ef106e107f6f7940397d63bd43e2412fd5c1ccb02c2d330441d1b07b235de2bc8d2f4b9fd1d9843cf46ffa9c0fe19bbc307c10f22161901f9d524ee09ebe022c40c10d5fc30c51906e730fdfe84e4f5de2ff111af0cc9f7e8b43bf4dae4d2d88a47c4c02baf68a22dc4c9e1d24bfe37cfd7f7fc26c1fe2c3726fb02cfd9e92b55194afbf0ec9f3a08b21cea0c5db0f9ec18c82844efe1cf28e6170ad8f0d32c07e603e1e94a0f00f429bd1aeaf4440c3e4bebf3fceaee2af2c00bc8fa90d4e4d5b901fcec0b7fdb27a50bed3864f6031286001b1aca2cf50d943ff504db2ef339e3cdeed544072e06c7f4cc18010aff3148b6dc9dbb97fda5c601ca8eff3f0babf3350ff0e7e912fe27cca3abe4f625d51a0ec9be1eece4d3aff510c7ee38e0aeefeaee14d6dfea1144bd1e01e0d035c322d2d20ee6cce71a0adb0de4ce1408f3f432f00c44fa21081531f4f24c90e23501ece827b8d6ffc9fa1cd20419131181fc0a0abad12dcf05f1d311dbd5c6e0e9ebfc05fccff927edf1e5f3eff31ec2fb150f0efe050ee1f808fd2be8e6965ab2e5cf160af9fefa178ff2dbf615f1f52af64001f8301a221f0e24e6ca23be072101350208b01f10b1093221f4e90113edf705f0afe40aece5c5f624d4a019ee0b0633ed04dff73ddecd1b04d6061c0a10fb8622ef2c30daff5ee6fff600f82fd7e3c709f3efd211f7ede5e3d31dc120c1131bf817e2fb3de1d90fd6172c3af70313f1f3edcad4d5d3dfeee5afc41619efd6cc17e8ef02faf8fdf3dccb04060ccbe53ccc07e6fddc25d4d7fa09e7f811f4d90b251ff1fce91b0cfb11f4e8dcfdd1d5f010e6e4bdfe0be921ddcfb3f8e724055f021edac84415ff33d8000021f6122c1cf5e5b60b0125d3df05fdac4218dfec0a2aebc6feeb0f3dddeac8b7f1fab1f14e27e42a3101f1d307eef5ec162b19d30ac5f3cee9fb01060011e113b42e09e1e409ec280700f200ee2bbef11a44c5ee2b2f03d8b223fd1d04cef824e93906282deb378131ee04dc1415bef9ee0d3304191a2cdaf7fdef33ece2f0e6f7bafd22f72009cef13eee0e19dffa2f0d2023eac3812c39ddee29fd23ded810eef3e7d4cb4cd7f2df16d633f812b7d7d72ee4de153703b1ddfcf21cdbf215f7100efdf71aa4a313c62c09ca2c2cfabff8dbad42021ae6ef25faef114fdb00d2f7f4dae24bc303f3f7ccf8e71e074fccc1f9cb08aaf9dff3d5041ef9ec2e2033042ac2e2cbb8b122c52b3df4e8f9480f19f33e3b344c33b2f32b1128f6d520de112f114715a7fdfd21f707bbe13d01ccf6f3b603f8273ce826b2e73253e2fac210ced9f812faf4fce8252bf713ec1dd0dcd3f7c5cc0b110a1ee708dbf52c035abc24fd030b18e509eb3342c07f4605b714f1fbf9023ae7e9dd3f0b1715083eb128f0e0f71ea648a209dd2cbe0602c4def3e304cc171244e60ed4ef340d4d0ddd152b2039d22fecb2fc1113b01dfcefa51e140dff34d5fc10fadc3ffa2b38ce4822f0020d3155e504142fd59d643206a6e105151ab906ce0fc4ef0ae426f5d04e13f9d3ed0be939f0f8b134051a375ff6040727d2e2e8f3f31eebd4d41105f709cee3faa6810dd522102413c8f4fb27fde70d173fcf1dce170bedb3e7eee548f4f0b8d15df3da28fc56813bfbe8f4056601111a4beaeeb2e219da1eee07ebe53a10f1d0ea44d63a34f8f843ee380ed0ee191b4be50924262a3bf1d52c10155de41ec9b70001183c07edd625cbd22ffee8c4ded80a12f123092c259c5dd4b3642902c80b3ce3ec12561ac70bf0e50b17061b1cce3d4210f78119fe0cec3c05c1fd1dff210e2d0af340e00c4f0213fceee4032912dbfe2ea22b35fec332020df93f16ebb7d2002c090c12dd12110f352194e208bc06f3cef007e9fcfd7e1fdcf0363d063f17b6090745fec892d2c915ceaaf5e933170822dbd804faf9150e38c908daffdffcce0b11e94bd7f2db16efd5cd0a0e2bc8ebc61bfe41d9daefdb0e2705d1f51aa6ac08492be62726f408e71e03defa18cf32e1d8e8ea2ad2bde6db3acd02d609203cf24303150c24e220d30ec827fcf21d401227b53ce8fc1e35e3e51efad6fc2917102f1c07270facebf6f2fefbfa7feb16011e022df8e543e8ca0a1d0e15d526e8111f1a1e2a15fdb0e206d9e53007f8f0f118ed0d10b52ddc053bf8fbee24f314e60b502036efd5fce6e7c0faf3b7033a16e8c44409dc1b0aecbbdf09c8dd0afa1b2114e1642ce8d6e70f012e034ffb16070c0132f2ce15fdd51327d8eccfe7100223d008ef02eed23952f80e30f0fb351e58e704eddf4201fbcb4320f31832ef26e23e140fd8f1df2dd2ed0709e5b234112ffbe6f82d0308f4eff81adfea05130a24ee4bd10006e1f0f418acf905ebabce37134bf8f0da040220f617cdf2e6021c00e0f617031605e63246d3e1c0c1f0c9e2bdef06facfc7d72dc33cf618e759fb2ac5e80f1fc3e5e70bfafb1304d1ff2a2c01e6fbf71710e5f0dbead1e5fddf3d2ffb12000f1821eddd33f2330103e3f412152b059decdcda4531b507d23319eb02f114f4281ffcf84d40f41000110ee5b60500eff0d6e7e00df415f9e300ec2ce5edc00a16fff9013dfcfbe10aee2be6d9241333d1defdd5dbfd1ede87e45b43e90ce135171af8edebfe231e1e2837eebf03fa038c2eb6fff313dfda203430fbf0e1df04c4250b1b1541e5e40e292f1fe4c2ef101d1e200ad4f8501ee7340933d1e535e120c8110ee10431e1f2d31922d9200ddbf3b8ef2bd9fbc3010b0ee8dcdf1ddf1312112214f71701efdc05d6ee0025df1cea13e9e515ce0dedfd0cef27bdb928d20039fd4dd0e82401114a0305b7bf11f4d4fd0cf4f33881fd09ef05db12f0e6cbfe2bd4f4e9dcec11111b1026170c1529f0133f1fc9fad420000ce2f9d8f8ecf2ff3fe8f126fd10e80411fde914e4f307f6f22bfdf4fe270eb738f13208e713ce242f01fbfcf4eee9f008eff411be1eeaed261419de120027d30a04db31e018b3d9f9fd06160d2d1cfd17dd71f01ceae510ff45dff323cded15c5002b11d8f2f5acfc040c1ce60101112a0bd1d0e6d210e5013122f5fcfe81bffff1fdf51404d5fbf5effafdfa1af1eae2d01922bdd4fcfd12310ae3f90da7d9e031b5fac6e003f93b23fc2723e6f9101d2c1cdc00fd2d15de1519bd05cce5d2f032e2f133f34019b2150b0f402301fb1c10effaf7d9efecf211e0f4ff1f5a231240fbbbda01cf111b021cf9041e36f1e2d0501bfb1e5ac3e146590407d0eb060ddc222e16221904f2bd2109171f380eec0cd816fa1afbe1dd00d0e881cb3afef728bcfc03f125de21e412fb283d32f5ce04d0fae0e1cde9faf4dee5082118d3f209effaea2eb61fffef0c162afd33d92fff04eeefeae2c2111718fce1aa11d91420ee10ec1d1adbe5cdf442b3f7f6290ff00f122dfe1cf9e501ed1506ca1ae2e83b0a1914042cbef6bde0ffed29341fde2917cbd6ed10e9e53bfed90a2da0df951da0120cf5e5f0ea27a8fa1f26ce00cef19dd80408d017e236cbdce60fba0d1237f0ddf5f8d01ce121edee0d0d0beb14e8f0e4ea170b2305fc02aa199504f2ee0cb1ea33d00137ecc7062de9f9f6efd71dbede07b5e3ccfb0ed201071b0c2a520318dbeb0dea1e10e20ded0c0ddef9c3091c7f0bea26d9e03e121a22e0fa190b03fe03fe5b0fe80400f309fe19dbe5feedf90bed1b02201b0ee21fc8d2fffb192a0c2420e43df3c4e1c3ec0e311613c930ffeff8cdfcfcce0bf21dbe1fddfb05ecede9fb29f9f507e5ee0c0d0907f7d9d713ddc9eba8ee0216ddc1e4cb331ff30c380edb43ebf7e4eafe03cf05301ecf0f200d192a1307cfd3d40e1707ef06b8f0f816f6dd1bf200c115ec03fffe11231e340afbabf0f3ef13fdfa0f05b7049cf1f21ef10f371ddedecc08221637e8e20ceff1aef8c6e2fffacedbd515fdf5ce1e24f7c32efcf7dcd643aff4e6e5f3), .BIASES(768'h10b00000913fffffcf1fffffc850000003900000171ffffff4900000115ffffffe8000003020000014d0000006c00000938000000eefffffe1100000603fffffe97fffffd690000029d00000006000004fafffffed6000001ae00000417), .MULTIPLIERS(384'hbe003c00c80097008300d6007b0083007b0080007700920084009d009f007e00a800b400fe006a00c7008500c70103), .PRODUCT_MASK(4'hf), .REQUANT_MASK(4'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .WEIGHT_BLOCK_DEPTH(1024), .WEIGHT_MEMORY("block"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_7_integer_convolution #(
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
  actor_7_raster_window #(
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
    actor_7_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_7_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_7_serial_product #(
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
module actor_7_integer_sum #(
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
    actor_7_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_7_raster_window #(
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
  actor_7_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(STORAGE_BITS),
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
module actor_7_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_8 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_8_integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(24), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(2), .DILATION_W(2), .PAD_H(2), .PAD_W(2), .GROUPS(1), .LANES(4), .OUTPUT_LANES(2), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(2), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .MULTIPLIER_BITS(8), .ACCUMULATOR_BITS(18), .INNER_BITS(17), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(41472'hd81d2d26f037d813240105f81af6eef8d22e03110ff024eb15feef052cebcaf3f8172903f908c41003d4e927f2f903e2d92a1ff3c93ad5dde0e92e27ff0e11faff100bfd040302160d1318bcab36f405daec81ddb719d51f14d61109d3dfe43f1d28defdf70bd7f5f01bf2bbd5cae5ffd8d5fb031781e60dfde2f5d81d24c825f9b0eeefe2240ecf19c7f9f62dfa2164f51339270112fb0903ee01190bd8cfe4f0ee2a390f19d91e3afa0514270202e51d24e63bf2e51bfe08dc05eae7f1b7e106f9f519f706d5023d3a289d57f6f5e5dcd9f3f14a5015fe3822f2021321f9e06deb23f90ad6eb2405042ee54502f9f2ee3fe22a20ca131328351f0ee504dffade1a0ee336042f1239f829c62dfcf1f9fbd90fd6c41017f50de61c2444010dc21c0fe202e313e608fff52bd3d4fed6bb034de1f20903bf0d47e0cee8b03ee00806fa201c11ddeaf5a8c702e318fa0d3f1e2efef828d7cf0cfbeb03fcda05f8cc0f454a06ead7261323dcd610de37eee1d8e3f6dee91134e41cf3ec1b07e6a1852a272128f4f6feee42fcf939a301f309ce27c12d171924b061df0b2d254f060c2000e5e0d416b6f235d9cf263115e107001be1f330d2b21c17f6cfdc1417e2d6eeedffdd18f3d88ff2f0ead5f9001b045b1808103102e0e4e135da0cf7f2f8cd05e30b10fd0aed08dd101d180729ecc50cffe8ea7f1a0ec1dfa70f40fafd200a4cc13019f5f01af30507f6e832fa14f42624f1e6f60ee005dd103a2d0db205282cdfe3fb42d4e7ca1bdafaf9e6d00feece20d4f6cfedf33410ece209d70f4b06e7ecfb0f04f99f3cd1e5c5c0ebfcdf08dfd603eef0faa01bed0424040a05fc12f51e06332d1b2b28f62f070be810fccc2dfa041bf7fbc821ebf521fccac7f62f212dc80c2e090d39efed05f415ff224428f6eb0904322618360e2c1b1ee809311fcc41fb3411eb04da331af0cec417d4fc180bf9f5ef0acecaeeec0021db2ff1d304d00bc3f4f73fe7f21ae80107281fefdec9030cb3daff0ceab4f72f40d6e7e2d3d5e70313fbe91312d1dbe8e9fdb6eed881de480109ea00f0f50ff8f03e04e6fbd1fef600e8eff8fde7242f51da24e95ed649181ac341d5f6e30502e025f6e2eebf1bf8020c150fd5121bd5fcdf091501fee0ec0006d62353ec1c05fe22fffcf8d6d32c18f0c8d7eedfe00cdbf801d93be60bc6f723030cdefe0325d1290e9f0cbab007062f0b1dc6ed164905fcdd2cdbcdd94ae03cd2e32097fff7105dc7463da2c70be1a50e9be3ff0521064a1b16d556f808e506eb1ee0cb1c0dfe4a34e4dd1e1deef5bf0418fbdc2f08e03a004beacf17c6f30c1b0c23080704c7a1090308c4a05bd41b05f797f9c70efa02f437e9e526f6cf033770159d1e0f02ca242ee318c5cc1915ed12fbfa42dd32fe0991d8471ad1fbe5cb2f18186d7f2b53fbc607f62c2a2f611ada0e12081edb0bfef209e2eae2dde9facdfa3b05c5544cd409f9f1d9c43f1f4bb45f3dac14381a19fe22c0392046e881f8fa08c5541218eec20f0d364efa04dcd339d9d216ef184f01102df849a10f4205fc12edd245315c4244ab0c0ff01f21d6ef3433ddb312fe2bf424f825295039f9dd2b180317edb0aabddbf493031d340d00423f2701d9b7081c8bca181e4fc316deb6dd10e7481e0d11221821e998f9b73729f79d1df93f2ecbc4ffe7ecf4e9d1f813ca3d0bcef1d2e807ac1d38dd65e643e8fc0809339bd8c349fb06c1f5e1c80018f432d64a5c0d0603e31df930bd34efdabeed3b213001d5c361174b1d480715f006feebabec1f23009cd009173213affd62ee30a5bafc1318c11141badb470087c74211f25bf0df53052e14c30f2c45c90813213481d022f9131c8f2b25edf82314042ddff9e50cd2d9ebfbfed1fc151113110eedf8f9d965f39a41f6fdfbeba99fd9eefbb1a0493e04c9d9011ac4fe0af0230c47dcac33160c32e8572942fe147f9030f40349132bdf0fb60ef62827fb3108e41c81b36ebd3defe9fef8e431361df2d4f10118e1ee961fd5f49ae52bc3fe1c41bd21d1bbf93912b724f10781171820fef2d4b933f5ba502232c5e5dab6e61853221a280e15e5d72413f5cd55f9420cc3463521ddc3fe1fd24f24d6dde2c7fbcdc02954f206b342dc21144dc72350280429f027ecc2cef7141722ecba0222b248fff32a11990d1f9e0ad3dde015fa559a14f63ee5dac7f4f62932e72c5ff3131365332519281fc3cfe4c2f1019d1558164c4b17db7fbf17e4d02233d70eff1a25fbfca3e24e33f1fa04fa42204121b9f55404261f16b8e0184bf41d9ed5a512ea0e45deafc1fcf8e9d4f64013fdca0afcbae1c5bc05ad0b1bc41ac9d80623ecbfc8331c0dd4cb294a24f1453bfb623360d206de33e293e7f166e23e1e1af424db42c342e7dbeee7d40df63405e0cc39a57022e505bb18e4d932fa43d335f93411ece5f1db09d93b13f90ccd8fda46120ff7302e9cedddd8f428e3344abb1af306fcc727f70d053cc8344fea24f645220c1eb5d32fbd4bf8b805f1ea41f43806d805fdecef14f109332308e8fd9327ada9b981f0eee712f93b11ee19f3174be031fbf3f42ecc05161b96d62320ac1a0142f1a836c69d131509a7f7f7d698f84148c43842411937e70eb29fcf2efaf514fe1f3e0a449b1a3605382613581616bf25fef4350ac3183a323a44d757de2c4607d20f17fb41f8d81b2ac92deb27b48bf805f310d7d9ebdcbbe50f20f022e84202c1e7c1db1ee3c05b8a10f1f3f0d3191752a54403d94656e0f44a42f226eb2ed0f419c4041dbd0b613ddf4bd1180202429220331425215b0f06e53af01119e11fae2459d91dc7243c36c0edc9b5e1ff3f1c16e5b055b7cae0f725dbd2e23810a097191cf432fbdce53300d6dfe016c8cbe1e3051fc3ee0417132d255e05543ee91bb6e2b826a540266402e22cf9bb34e9d21feac1f80d4ff2ddbf1c0f1ce63ae220d11dfbb2343631f5d5f043bfe2e5e63bbe9ed11220282ad42332b510d5ccfdd3c44329030ace12c6c1a61d2ffcd37fcf5d0b0ccf07d9ead8140f00e581e3f234efd0fddce2eaf60de402fe34dbe3efc405ffd2e9423bf3efe5e7cbf2ec23cff91700f02612d0d607f60345cf2611121aecea05f8b933c60bc10ac618f6e9f015db02073e21fe25fe152bfc2c1b59e90a0d1620e9f00fd8dafb193bd722551ee72119f500021dcee1e50cc013b91e04310e03eed81bd128051f2821521ef2c200b4f30ef91a2efcc50f22e13020e8f8e3e5d4f114d614d8b311dfec10c60ee5fe03cb031c2325e12ccbe9e5e83109d9eb2cd6d621d5ddffbac8e7e9b700f2d420d6e858e00f1a030942f50cf7190c22e0e1e621e7f0140d0d30d4fcdb1b0ee41cffd8f00dea0019e9dc05c3d500dbef121dec0dfffcbb0fa205f113e6f7fbec1ced043cf404d20af6d8cf31f2e1e5e3d8dcc0ef0d09fc0ac7d3f00127df1826d8dd1c18fe1de55219380e81e5440700c7150c231f0405f51034e6fbe0bb13e013f8e40ee92629fbc2f517ebe6070f00f3102b38060c00ff15fa1bfbfd0cf506f71bce270df0f801da09bfd8f0d2ebf4f812edee941a0a2e1f00071929e11b27ecfd1eb4144b112ec115112d30f8fe2bde05d5f0ce43dce22abdd7ac00ed333b47a0e5a941f141f31d062704f6fd04e7c32bdef428e7db9bd5f3c042e4f3c7ae31ed5c1c4ce1d8040257a7222ef50efbe7a5fed70ca238f1e305b700a440060ef5f0c0cde2b408cd862094e6120e1cb052fc15f9ab271602d3e6202867f6e2c724a1fbe1d02851d40c2b34174b2fdee9ae1d41152e6036efb132d8de16f9e2b41d100ff4ce12e824e8c7ba1af3efdb1b05fbff103f1105eb0b34ef0c08006358cb2ac8141f21327f222300f6db16e909fa201c2acb255f132f0ae43cf3f12416fe100ef9ef1509e9da31eb0dff38c9413f220d0bd2f8efeaf7112a09014919d2eaf3f41eea2b310069fe4ae4d114e3dc30e6edfcf5081107feb32f02fce31916f0cd04f55dc2f91532fcfafd390e0d328103d4e6afc6fbf6e2dffafa20f6c023fb1ed0cf1df7e3183933f50add9f3e67cd38e8ec535eed16def2a832bdf6f8c62a1935f5f9471af8cd25d1edfede07021b28f30422e0eafe3217dc78ea074be832fedfffffb04a0acf1ff6d7e6d71bfe2c20eede2950dfe5e4ceccdab5f03501d3d50de017fe02f9ea1dda3902e12404ce4d20ea31c5d7ca223dc6c4320328e606660dbcdffde5e6ccfe1312bd0ce417e7d12135e9f2dc4012b52fa8eceff834e40fcbfa43df1c081af96beeece9c90fe805ff0efde31e06d81903e1da32d6e435ce215f46f3e1f50fefebd70f08ce1de9d9f0060af35425edfc5ae2f5d4dc75d3e5f4eb24f4bf13f9f212c609ecec0affb21c5ee0f0d2e6eb0ae5f30f1fecea2c10ccf7d81913fc20fb7fd0e4cdf36d0ef8fdbc2105e314fbd830ca2bfa0fe32009e5280903211fecfb3dcc0816ef0d09dd0d28f5f1260922226405181cb517c8e906fd27f519d8e1f5e5d7d420c9ba130b1a64edff11f3ebe918f40aee2efc25f1df0c06ff22102df50a04f9f71a2413161abfef0fd5ffdbe928dceae922cdff1df350cefc06f0fe0b0130200308dcfac1c7f11b071bc21cf346d8fff0fddc0b19f3a9f329c817060011d2cd082ce3d3242f26f1fa122ad12646c4f5ebeeead3060c1defe2d414ace42d0c11ec8735e815d6cafd1b5bd9ec38e1abf80f228fe05b2f06d91529ebd3f91dd1fff7ec21d202c605f319e9002be707f9e734ea3a05e8f5f9d5fefd36262502a33b101dd681dc241ffd0d1be222e2040823fdaf0ecf2cd235fb080bfa2ce94be9e9052924e90d13d1cf00431fe02a1ad9f10c2cb4f23bf567df1bf213144afffe1705323cbfeeaf0b36ec294acecb51e613ebaf38f809baf9cd30ff1cfefa09a831e1c3023d2ccb5533e09d084227f71c0ef7f81a92dd221c392c434aea17430e2af5351fb8e4eec00f12effde6cff8f1f7b9034b1d1d1b74b9e7b0b8f716cca8e020da06c327c60ff7241ae30fe154ce1d0b1c7f87d90b9a05140507d5a9f181c6d506c224effb31e2d31c27463825ddbecc0b0ad90ff7fcf8b309f6f2e47fbc9afac239cad8cc4bf41829a609c9d9cd15ca03a43022fa0ee2df120e49f407c7cc2c08f09e65aa06ffc937193c0b7733d4d72255b20e0ed9bf06ebb3dfd431e03c2525db49f43615c7d70106e7db2814def9ed040a03fcf831adf7e8e4f970ba1af8db1881e8dcb1c9ebedf2ecdf43d7eccbedf229e9e95917c5e22f22285a91afd50b1ee016f16a11d1d610e7e4631ad22f974309ddaa2bdc3e2dd824fdc3ce34db02a817ef210814d10c2519341fbfb9e4b302df2eb2430cced3ffefe23e040df3a23cc2d3cbcb30e311f2c0fbdeab040ecad7f90b3509d2d8320101311cd2fadeb8d6ba1ab95131ee1afbbfc64e300f06481400f4f4f6f60c1e2efbddeacfeceefbc43ff7ecf7251700ced941d2b0eadaeab20f81d3c015f8fbd108bc19f7faa4ecfdef1d201dda3e15f6ec1f03f03494091e13f13630ce01f5cde7f41e1ce1ccd563c3d2f7142103df23f7c643d31cc10fd4891b2313dc17ff0cc0e73d11efd02cfddff92312b0eaf106e93b0369dae018ae2007250a25ace7ed01f848ed3e053a1ccef8043cfd05dfe41a17512ec1b4cc810f1ac5c4b1162ad8cf3ed58d44db35e40ffb0ffe1afeedc001b7fb1eea90c8b1c4f6e813196f16f8e6abe9ade18d1a4cd10438f6f8bf4fc62fe8d3f0d8d7f4b2183f202f040353d21f4feab9c80123c8e7f0670eee26edfdf2b347fa1fbfff1220213f30e3e7ad5611fae1b618dbf48b22c809321fb971c724e307ff1b03fa84fef010aa0453c71e12d02a03fed3dcebf81ab6e7ebe10ce71aeb032ad8c81d14bbce90b6ea0548d903d121b7fbdde0119d081ad63211082c21cbe4e533b1ae40e9c8c1c6c8b613304aec031200141a02da5e2124e6e564673604b284e5f8161e9fd9ded30027cf45179ef2e7ecd8d00d150ed8461301631b4cf1e99cf3ecd304d8076124e2ca20471808be3e34d7e0f1e5c60f210df8c01251fdfcca2d134b5401fd6afaf3bf46e8cffebdec00dfed3dd310ffbeddc7fd2e0df1de1fc6b904f7fee635ca04dc2b3e0a0a394ff52000f416be13251ce92dd7241c0bd0c15aca06042831efd7000abf46fae3c4d2efa428f7e2e6d9e0ecdffbf1fff49e0829dcb3e2c423f1e6019ad92e12d45b13e51eb805f5e017ac46fbc0be004bcbbff2d9f5ea02c80ee4efbcca04f24ddf02f60c5c1547dfc0f00f391aeff4dd14de08a43b080004000327c6264247c7d2171dc7aeeaf7f908c70b370f2810f017530acab652f017ae0b061cac1016e1220fdaa23781b8e3def4cdf3559fc604ac1bee06ce2bc792d2c6e7d3fbcc18fe81cbf63fed0111d4d03508a2baf4e4ea0c02eb99d710b4342ad22de4e5206d22eb1ae6aeda1958e0c42054e0ba13e54ce33b1932bcde0f610bfb023b0deafb262400f71c43c7461cf6d62e163123ed32cced16cb292dd0d6d6f4e12309d8f0f41ae0c3e4f321c219cd09f4f0f103083aeb2b2a0151f509fb03fd1124fc0822f0e81e0097d60be0c1e9fceffdd10111dabc33f7fa2901f6efe9f119cce321e7460ff3f1b5cf061046e8d4ffd2ec153a47db0afeb62909e4e3330aea18aff408f4f9eafa4bc0a410fedacbddfc16e6f8d2d853f3f31440e6bbf4252439f6b20e1efffc180e349b04e81e3652060c35e4ecc1b9b80fd3d7c334e8e4d8e419ba033f5d24d9439eff4bf4341546b235f87ffd01b4f922d8f7b5212b330daf10f2f5f61329dc06d7f30aede73be316dd46eb24b6cbf2cfac0310320a0b12f606f529080dd6fe001948efdcf9d9210cf04737ff106bd65c3435e2f0fcdfd1f1d7c81b1ed6c6cac51fb72455e309dfdc0309fa23a0de189928ab0cee1b1a1fce27db0c4608e1dd275adbd9e4e928fdd3c21fee10709f103d1535fded39b526181c7225fc8102fef6f9c713a80219d510e135c5d8d516012dd906dbdaf4209e203e272ece009026e0c3010400c4e4f13e1703b80357e5b6d5552faff00d33eefe0f4f0bf7b83f1f1d1e0d404517bf370ffcd2b7153f3dfbd715fb063c27e92019f5f9f5b8221bf4e2c7f50a40a82f2dfa0c25101defd651e2f90ff8d11450f3010ebf8e3ddd11c511f5d0bc0a0b14ddfc1230b92a15d2f61ce4f80f0c010c08eb1bf2292a3d01d9ed120af104d5f504c89511d4f1e2dc0e385cd84d34fdcf22d4470928ebefd828e12b7aeaff23c9ba03061d08acfcffda0e2afa04), .BIASES(768'hfffffc1600000233ffffffff0000027efffffeebfffffe14fffffe500000010bfffffb44000002c400000161000001f70000009dfffffe29fffffd9600000150fffffe750000083d0000000c0000089f0000075a000001bafffffefa000001e4), .MULTIPLIERS(384'h9300c900ad00ca00ab007b00d5007500a5008800cf00d3008b00a3006800f40058007f009b006b007600e800d200af), .PRODUCT_MASK(4'hf), .REQUANT_MASK(4'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .WEIGHT_MEMORY("block"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_8_integer_convolution #(
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
  actor_8_raster_window #(
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
    actor_8_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_8_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_8_serial_product #(
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
module actor_8_integer_sum #(
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
    actor_8_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_8_raster_window #(
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
  actor_8_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(STORAGE_BITS),
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
module actor_8_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_9 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_9_integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(4), .POOL_H(1), .POOL_W(1), .KERNEL_H(1), .KERNEL_W(1), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(0), .PAD_W(0), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(10), .ACCUMULATOR_BITS(15), .INNER_BITS(19), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(512'hcfcdbb818171453ecdc3c5b63fe1003b6257ea7f5663c4c9f9e8d5182eea28ddd9c78189c20b25382deafeb9351dd2e415767ff80fee3038f36233b3251043ff), .BIASES(128'h16bfffffec500000196fffffe67), .MULTIPLIERS(64'h1d8017702e2025e), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(1)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_9_integer_convolution #(
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
  actor_9_raster_window #(
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
    actor_9_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_9_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_9_serial_product #(
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
module actor_9_integer_sum #(
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
    actor_9_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_9_raster_window #(
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
    actor_9_packed_line_store #(.ROWS(EFFECTIVE_H-1), .LINE_WORDS(LINE_WORDS), .BITS(WORD_BITS), .MEMORY_STYLE(MEMORY_STYLE)) storage (
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
module actor_9_packed_line_store #(
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
module actor_10 (
input wire clk, rst,
input wire [63:0] in_data,
input wire [1:0] in_valid, output wire [1:0] in_ready,
output wire [31:0] out_data, output wire out_valid, input wire out_ready);
wire available, release_window, select_alternate, active_dot;
wire [5:0] window_address, alternate_address, first_address;
wire [31:0] window_data;
wire [1:0] ready, finished;
reg done;
reg [5:0] output_row;
reg [6:0] output_column;
wire advance_frame = done && (&finished);
assign available = !rst && !done && (&ready);
always @(posedge clk) begin
  if (rst || advance_frame) begin output_row <= 0; output_column <= 0; done <= 0; end
  else if (release_window) begin
    if (output_column == 125) begin
      output_column <= 0;
      if (output_row == 63) done <= 1;
      else output_row <= output_row + 1'b1;
    end else output_column <= output_column + 1'b1;
  end
end
wire [63:0] branch_data;

wire [31:0] bounded_input_0;
assign bounded_input_0[0 +: 8] = 8'(in_data[0 +: 4]);
assign bounded_input_0[8 +: 8] = 8'(in_data[8 +: 4]);
assign bounded_input_0[16 +: 8] = 8'(in_data[16 +: 4]);
assign bounded_input_0[24 +: 8] = 8'(in_data[24 +: 4]);
wire [15:0] stored_0;
actor_10_view_rows #(.OUTPUT_HEIGHT(64), .OUTPUT_WIDTH(126), .KERNEL_H(3), .KERNEL_W(3), .LANES(4), .BITS(4), .OUTPUT_BITS(4), .QUANTIZE_ON_READ(0), .SOURCE_SIGNED(0), .CHANNELS(24), .TOTAL_CHANNEL_WORDS(7), .WORD_OFFSET(0), .WORDS(12096), .DEPTH(756), .CROSS_FRAME(1), .ROW_WORDS(378), .LAST_USED_COLUMN(125), .FIRST_COLUMN(0), .MEMORY_STYLE("block"), .ROW_ADDRESSES(1920'h17a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e800000000017a0017a5e97a5e8005e8000000000000), .COLUMN_ADDRESSES(3780'h1745d1745d16e5d16e5b96e5b9685b9685a1685a1625a162589625895c5895c5715c5715657156559565595055950541505414a5414a5294a5294452944511445113e5113e4f93e4f9384f9384e1384e1324e1324c9324c92c4c92c4b12c4b1264b126499264992049920481204811a4811a4691a4691446914451144510e4510e4390e439084390842108421024210240902408fc408fc3f0fc3f0f63f0f63d8f63d8f03d8f03c0f03c0ea3c0ea3a8ea3a8e43a8e4390e4390de390de378de378d8378d8360d8360d2360d2348d2348cc348cc330cc330c6330c6318c6318c0318c0300c0300ba300ba2e8ba2e8b42e8b42d0b42d0ae2d0ae2b8ae2b8a82b8a82a0a82a0a22a0a2288a22889c2889c2709c2709627096258962589025890240902408a2408a2288a2288422884210842107e2107e1f87e1f8781f8781e0781e0721e0721c8721c86c1c86c1b06c1b0661b066198661986019860180601805a1805a1685a1685416854150541504e1504e1384e1384813848120481204212042108421083c1083c0f03c0f0360f0360d8360d8300d8300c0300c02a0c02a0a82a0a8240a824090240901e0901e0781e0781807818060180601206012048120480c0480c0300c03006030060180601800018000000000000), .COLUMN_AFFINE(3'h7), .COLUMN_SHIFTS(9'h49), .COLUMN_STEPS(30'h601806), .COLUMN_BASES(480'h1800000000000000000000000000000000000000000000000000000000000000000000000000000003fa), .ROW_VALID(192'h7ffffffffffffffffffffffffffffffffffffffffffffffe), .COLUMN_VALID(378'h1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .REQUIRED_ROWS(896'hb71adc6b71ac4cb132ad2ab4a958a5627de9f7a66499924ea93aa3708dc21f687da07c81f1f027c09d887621c0e7039a946a5191a64697a05e8162658994ac52b13324cc91b846e103e40f8ec43b10d4a3528bd02f40a5629588dc23707621d885e817a046e11b82f40bd017a05e8000), .VALID_ROWS(64'hffffffffffffffff), .LIMITS(896'hc2eaf40bd02dc6b71ac4cb132ad2ab4a958a5627de9f7a66499924ea93aa3708dc21f687da07c81f1f027c09d887621c0e7039a946a5191a64697a05e8162658994ac52b13324cc91b846e103e40f8ec43b10d4a3528bd02f40a5629588dc23707621d885e817a046e11b82f40bd02f4), .RELEASE_COLUMNS(64'hd555555555555554), .TABLE_COUNT(1), .CHANNEL_TABLES(24'h0), .TABLES(1024'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffedcbaa9876543210)) rows_0 (
.clk(clk), .rst(rst), .advance_frame(advance_frame), .done(done), .release_window(release_window),
.output_row(output_row), .output_column(output_column),
.in_data(bounded_input_0), .in_valid(in_valid[0]), .in_ready(in_ready[0]),
.ready(ready[0]), .finished(finished[0]),
.window_address(window_address), .alternate_address(alternate_address), .first_address(first_address),
.select_alternate(select_alternate), .active_dot(active_dot),
.window_data(stored_0));
assign branch_data[0 +: 8] = 8'(stored_0[0 +: 4]);
assign branch_data[8 +: 8] = 8'(stored_0[4 +: 4]);
assign branch_data[16 +: 8] = 8'(stored_0[8 +: 4]);
assign branch_data[24 +: 8] = 8'(stored_0[12 +: 4]);
wire [31:0] bounded_input_1;
assign bounded_input_1[0 +: 8] = 8'(in_data[32 +: 4]);
assign bounded_input_1[8 +: 8] = 8'(in_data[40 +: 4]);
assign bounded_input_1[16 +: 8] = 8'(in_data[48 +: 4]);
assign bounded_input_1[24 +: 8] = 8'(in_data[56 +: 4]);
wire [15:0] stored_1;
actor_10_view_rows #(.OUTPUT_HEIGHT(64), .OUTPUT_WIDTH(126), .KERNEL_H(3), .KERNEL_W(3), .LANES(4), .BITS(4), .OUTPUT_BITS(4), .QUANTIZE_ON_READ(0), .SOURCE_SIGNED(0), .CHANNELS(4), .TOTAL_CHANNEL_WORDS(7), .WORD_OFFSET(6), .WORDS(8064), .DEPTH(2016), .CROSS_FRAME(1), .ROW_WORDS(126), .LAST_USED_COLUMN(125), .FIRST_COLUMN(0), .MEMORY_STYLE("block"), .ROW_ADDRESSES(2112'h1d8b72762dc999b72666bd199af456abd15aa7656a9d91ba7646e7e11b9f83727e0dc97a3725e89d97a2763f09d8fc17a3f05e87e17a1f81f87e07e0001f800762001d8b72762dc999b72666bd199af456abd15aa7656a9d91ba7646e7e11b9f83727e0dc97a3725e89d97a2763f09d8fc17a3f05e87e17a1f81f87e07e0001f800762001d8b72762dc999b72666bd199af456abd15aa7656a9d91ba7646e7e11b9f83727e0dc97a3725e89d97a2763f09d8fc17a3f05e87e17a1f81f87e07e0001f800762001d8b72762dc999b72666bd199af456abd15aa7656a9d91ba7646e7e11b9f83727e0dc97a3725e89d97a2763f09d8fc17a3f05e87e17a1f81f87e07e0001f800000), .COLUMN_ADDRESSES(4158'h7d0f81f43e07b0f81ec3d07b0f41e43d0790f01e43c0770f01dc3b0770ec1d43b0750e81d43a0730e81cc390730e41c4390710e01c43806f0e01bc3706f0dc1b43706d0d81b43606b0d81ac3506b0d41a4350690d01a4340670d019c330670cc194330650c8194320630c818c310630c4184310610c01843005f0c017c2f05f0bc1742f05d0b81742e05b0b816c2d05b0b41642d0590b01642c0570b015c2b0570ac1542b0550a81542a0530a814c290530a4144290510a01442804f0a013c2704f09c1342704d0981342604b09812c2504b094124250490901242404709011c2304708c114230450881142204308810c21043084104210410801042003f0800fc1f03f07c0f41f03d0780f41e03b0780ec1d03b0740e41d0390700e41c0370700dc1b03706c0d41b0350680d41a0330680cc190330640c4190310600c41802f0600bc1702f05c0b41702d0580b41602b0580ac1502b0540a4150290500a41402705009c1302704c094130250480941202304808c11023044084110210400841001f04007c0f01f03c0740f01d0380740e01b03806c0d01b0340640d0190300640c01703005c0b01702c0540b0150280540a01302804c09013024044090110200440800f02003c0700f01c0340700d0180340600b01802c0500b014024050090100240400701001c0300700c014030050080140200300800c010030040040100100000400000), .COLUMN_AFFINE(3'h7), .COLUMN_SHIFTS(9'h0), .COLUMN_STEPS(33'h400801), .COLUMN_BASES(528'h100000000000000000000000000000000000000000000000000000000000000000000000000000000000007ff), .ROW_VALID(192'h7ffffffffffffffffffffffffffffffffffffffffffffffe), .COLUMN_VALID(378'h1fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .REQUIRED_ROWS(896'h7c09f027a11e067621d0a7231c0e6e41b126a51a16666191a627181e5e817225a9162656a152a52b142e4ec13324ad123646e113a42f103e3f00f423b10e463720d4a3330c4e2f40b522b50a56276095a237085e1f807621b9066617a056a13b046e0fc03720bd027607e017a03f007e), .VALID_ROWS(64'hffffffffffffffff), .LIMITS(896'h99925e695a24ea91b23ee8dc22f289d21f685e20fa81f1ffe7e01f027a11e067621d0a7231c0e6e41b126a51a16666191a627181e5e817225a9162656a152a52b142e4ec13324ad123646e113a42f103e3f00f423b10e463720d4a3330c4e2f40b522b50a56276095a237085e1f807e0), .RELEASE_COLUMNS(64'hfffffffffffffffe), .TABLE_COUNT(1), .CHANNEL_TABLES(4'h0), .TABLES(1024'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffedba98654310)) rows_1 (
.clk(clk), .rst(rst), .advance_frame(advance_frame), .done(done), .release_window(release_window),
.output_row(output_row), .output_column(output_column),
.in_data(bounded_input_1), .in_valid(in_valid[1]), .in_ready(in_ready[1]),
.ready(ready[1]), .finished(finished[1]),
.window_address(window_address), .alternate_address(alternate_address), .first_address(first_address),
.select_alternate(select_alternate), .active_dot(active_dot),
.window_data(stored_1));
assign branch_data[32 +: 8] = 8'(stored_1[0 +: 4]);
assign branch_data[40 +: 8] = 8'(stored_1[4 +: 4]);
assign branch_data[48 +: 8] = 8'(stored_1[8 +: 4]);
assign branch_data[56 +: 8] = 8'(stored_1[12 +: 4]);
assign window_data = branch_data[0 +: 32] | branch_data[32 +: 32];
actor_10_integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(28), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(4), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(11), .ACCUMULATOR_BITS(16), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(24192'h28657817b9c308c0fe27f045476086d3d17d1c1e480b9e86d08c77dc3204d7dcfccbdf46dff182e7ff3217df7607f3fc8c4534cfdbb1e34108fccc4427aab7dc4ec01b9c679c4bc1e393fefc3377f430baebd3050cd185c859801c33702b90860771c4f3f07b2fefc7ebbfc6c82b4ef83e8fe03c82f84191fc5dc3fba27a0c7fbf14743fcf6301fc3c2e1f117f14ba7a344eb6f94cfa139f2fb0603bfbbec3fc4f3ecbedefe800bf90ead70bd1023052bc07d074f53d88002e32106108ebff8efc2140107f84d81e80f411cedffdc21410c7e09bbd249206ee92a6381d41f3a0c52c3cbd186cfef48dbc23b1749bd044dfee4ef87cc8e88c7303bf0b23d44de74bc20078460f9d84faccd10041fb0bcfc6c34f45dc3ebc1482c8f85f02fbb2ced7a4341c007c03b0fd13a1b4a86372f82c4113a3c9fccb4603ddad034ffd27adf090ee4333f55414a03ae092790f81b93bc0c093f8481be234f40e83302005fbe0bc2021c7b80e4db88c82147fce041d7de84109fb4186345f37ffce782c9276bf45b8d45cc60c120200aa7f0fc4b9dbdf381b5ef9a85d3e27a209084f02f05f7df02083b0ed950b9fff57c3bd3f40ff004c4f102e371481c1cbce0af04184ec4200081fbbf4cf87ff91f407c13f004f4503e0c7da127037ae43ff933e3bda40178db8f401bd03c0b9ac9d822bceff108fc4d0007d2b810bf45fcb0820391c8eb2184445304eff003037183206e39dfab432f83c7139e02d3fd3f0c2d3b440ec5f72181df44043b7d9a4b2dfde3e0bd3be1b9cb41ff43dc4410203be7c842e402ff188f4cdb0040039fba1bae04f82e071fd0be076f851c9148e04fc81b5301205a3bcfff4cab108defe0fbf04f8a1010bde0400befc042f7c3c716d0ff0f3bb804cffd1bc083bc0ff44fecfd4310bb1b187ce02183d35fbfbb2dbedf7f38ebe23e4ae1c446d38d0393f6140e45b06fc6f7213e186afbd834053bd003e7cf78fc0304476f7cfc1300d4ae40efc0c1eb7d6742fec3fc60fb1f6283b4532ef41df547f17d2b7b02c4917d87508ab86d3bf8613f210001ec8fb53031ccf85001005076fc11bcc03e3becbf87546f38e870bde051ce28c1f863b237db614bc7fd97cc50b8fca0ff0c9182ffc0f6b34543d80082f3e105ec5971ef6efc2c1f810bef34bedc989fdef1ccb10043bebeb012c953bd8cdcaf3518c1fe0bcd4bf04d80546eb7fc22440c5dccdd71fe0521b9f4300df4cd1f179d2ce7d2fd18913cf8cefcabdf3dd810bee350c1e7d9ee180e4a1fcd441c0ef4cb0f3cd470bfec6efb13a1c004ab8bcd3bc4c7e16d342f38ef9bf50fae3c5c5ef007f0c5ed5bfb0d8178d4b0b9f3ef01e45e93039028ff647ff010c4f79e2e86e0c6d790b8fb6201efd9372c1e3cebae85ffc131177ac5f3c2bef4ee80147db217c2b22040ba244f7b182fc0c3cc3540cfc964127bf47e4bf7e2c82c61ff1bb27d0710cfdc7247086f7f146200f0217a1b837dd0427ef770c0ef827df04a323caec6135fb7f05fc5eb3d03c0d13804503d1be33e18468847af7e043f3320c142f49d45f40f0660bf7fe82181101efbf78002d400390830c1f48cc40091bd1b718720522f1beff8af4047c010c407b07f0bebfb3c4c87dba00307a047f75d44f0017afbc04417ae85211a0e186f3e07cf7217c23a0cabbe0c0d86408efc1fc048e4e175d55179d880c1dc200cfd2ccb0750b02f83c8f4b0fd0c00b0a7bf00b850bc0f92fdfbeaf74b0cfcfbee462392b1ef4f38e3c147f88dc0f7ce81ffbefad091fa0fdf362c4fc7ab8eb038cc86235f6fe40f85f780bb1843432351432b21c6c7df3e2f3f7df40f33fb72c0133d01cbc341c73e46f3f079ffffeffc1dc62bdd80c44e46fe10f2c7cf000c3e06dc81f90fc381e2ce38b0be6624b03ad07b42f8803d502ef4d7ef3f26fcbd53418cbf913a033e04f88d7b104fbbf8d1790380f01c2e2ccb4106cb3e42f7eec0042bfd23cdc3d7aec8fbbd8a07904827f1014ffdcab3f03507fb7f36ac46ec4ea10cb23de86f3f2c60087c1036201c080488fd05027dc8b23703cf01f1cc053bc2b6f7d38523fdb5f8b980d4af07dfc0bae8303e145a7d5bacfe070e90132cfb0fae70fb71c32c2dcb9c5e00107149abbebb0c310d254340b84e34ac038b08f137d0af81b76e43d07102bb7db73c9087c83f3527fec600a08424bd882c4fb7bfe0ff2cbf01f730b49b7b49bfe031b68accefcfd25edc782bde0916be70af248f2b2fc0336f3204500be3634dac5cfc97f08bcce0c713b215d7cc4ad42dff034303dbeebdb702b91cd03fa0600800926c2101f8c450fa44dfb90ff0afc2eb02a7d339070e02f86f52fa715016bac10b02352ee2bb502e89ef913828914bfba141c3aed09f418fe38fc10b6c85370f95277d88074407f72c80e3d2c1011e86d3e0b9102f6d3c833bc8b077049fff07dfea0eecc69f20751afec5f06a31c700c1d78a01fc007cce9b0e92dd7ba3ea80db8e4f043ff7d90100e85245fcb188efddfcd2dc7e240c3bd37eccf753430bb04d36f101d4913d14817e180f03c37e0e08d00c1bd2eeb80dffb37334fa98cd0f7dc32ebdbdc4200c1a92305741c34350b806e63c4c6f100793cd97ee05d3e088bc0e090c9e52ee887f179e0727b2cbc7c24bb43f01f79f88b401bfe4646e407145ffd03628bdc93073f6203ec4c4223512da012b9d44f761c62fec781ed1b6d4657853b22a0b71ba4b5ebb0c24c8c77fcaa4404acc807d082ad3237f01ff60f818707f13bc10fcd208093fbdf3fe0703333340003be3e06f347f81f45f66ebcd13bfd2b70781323cbdc21b90b81c6ebe00223133da47df7d04272cd9c3b152cc9546afd07b273fbfb4ddc8d47cc7fc5bff3d1a3fb3a045e8358ecacccc2a830acb9271e81e8210ae84bf3dc30fdf0b281232db6c43e0713eef6dc70ff3050e113ae38e051a1e76fc22f92bef04bba34753ff070b7651a4cec8dc8f0394903ef4fb8aeb3e0123fdbb0780c7e83539a45148172205c05177140df3682447f83ff93320c9f4a430c35ebf2401a9bb1cf5443f3ecfc23d025e35078cca84c5ac583ec0c08386381f832b8645c05e35c83209bc5f72f02e8f375e8e07df3f041ef503ce82e09fc4492e03f7cdc1d7d0ee6bb2410050f6141d89c84172f03d85b37fb10700b0104fb4ff32be001b693b9045409bc3c382341411b91e50badbbff8c73ffbfb7001a4ad4acbfe7acb9efaac3abe961fb42b4cb3e7e086f06d0400bb4a10385f37a02e14fff70951ecb7338a304f4f07607cf2c08d583f6d0c7e89d4cbb9eaa0b9304c73ff9e8211906b36a044e91001fec1b6dbd27b237343c77bff982f3ed7ed41cfa131dfeefcc80ec1c8e90abdbd75f498492ba3f3f48fb0013f7e07723838a1f4e81ebdcc4f454f4379e87c00d740f7127fee2733851ba84acd2bc1ed01d0df9076efb1c2fbbeb74b22072bdbbb07cfbba8ddc5356ffe85117fe0ac47c0bfd5b4b3382c8c0420734b092f34e8c0bfd3d3b3f4bfaec43ac6106005c420bb18acbbfb73b3ef0e43055c77eb8043bc517dec1fc3d8f200d72fb7e46241c8d10ed3edb7cfeebfe03c4cbe5136df6f06b0704214ff86cbdf8df068c63f737f1cd278e86141b2e1bd04f08e43ab1537a09070f0bdf030c40c8d3537dbbac880f92472f52b00214b4146fff1fef6d180007eccefb142f04d7ea86008185d07eb6d41c7a04ccc8dcaf8cd4ac88dfc17eebd3bb234f4d0f6d102ffff62fa0cd2411c1f47245fc2f07fc4e02b4304c23a5392c51040f9341201576e00c0f192e7be7cffbf0a13dbc41cd43d202c7eebf003d3808618d144e87f41ecdc88d10f47fd517c1c5fc22c63c5093eb3dd20f70390f9fcc180387d42fba3fcfcf04cfffb10d78f732f5106f72c21ab2e0c035c821912fef46dc5df4f72fcdc7bed0a93e45c36a35fac185ef7d62eb6ce7d0af0c041232298bb2ecdec8881079201144efec0913a1ed284f8d08f278a01fc1a86391bc7d73fc8e0cea7db12be441f76271efde03b40b0f23d5ff13626efb8e7bb75d03bbd9d8e37b3f035041002beef76d2de83fc7fbbf41144dfeb03041e4727c5ba10903a0ba32f5ea0fbe89f3afbbf3d07dfb300010ee74b03e86e053b20bdd6a3b937736e474167ebd18127dfffeb003b13f937c0237edbacfefc1e0017507d504bc5e7a006d89f36bd1f80f493873f8ef427e2af011eb1d46fb223b074e4ddc4182cc3d1007a3f6ec4032a5420210517b), .BIASES(512'h390000012f0000004e00000106000000bcfffffffc00000286000000ec0000000f00000044000002f000000147000000000000033bffffff9e00000353), .MULTIPLIERS(512'h1de000002f4000001f100000120000002eb0000027c0000015100000187000004120000010b0000020e000001310000023e0000011e000003b5000001e4), .PRODUCT_MASK(16'hffff), .REQUANT_MASK(16'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(1), .EXTERNAL_WINDOW(1), .WEIGHT_MEMORY("block")) actor (
.clk(clk), .rst(rst), .in_data(32'(0)), .in_valid(1'b0), .in_ready(),
.out_data(out_data), .out_valid(out_valid), .out_ready(out_ready),
.external_available(available), .external_data(window_data), .external_release(release_window),
.external_address(window_address), .external_alternate(alternate_address), .external_first(first_address),
.external_select(select_alternate), .external_active(active_dot));
endmodule
module actor_10_integer_convolution #(
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
  actor_10_raster_window #(
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
    actor_10_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_10_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_10_serial_product #(
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
module actor_10_integer_sum #(
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
    actor_10_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_10_raster_window #(
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
    actor_10_packed_line_store #(.ROWS(EFFECTIVE_H-1), .LINE_WORDS(LINE_WORDS), .BITS(WORD_BITS), .MEMORY_STYLE(MEMORY_STYLE)) storage (
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
module actor_10_packed_line_store #(
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
module actor_10_view_rows #(
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
  input wire [WINDOW_BITS-1:0] window_address, alternate_address, first_address,
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
  wire [COORD_BITS-1:0] coordinates [0:WINDOW_WORDS-1];
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
    for (word=0; word<WINDOW_WORDS; word=word+1) begin: coordinate
      localparam integer Y=word/(KERNEL_W*TOTAL_CHANNEL_WORDS);
      localparam integer X=(word/TOTAL_CHANNEL_WORDS)%KERNEL_W;
      localparam integer CHANNEL=word%TOTAL_CHANNEL_WORDS;
      if (CHANNEL >= WORD_OFFSET && CHANNEL < WORD_OFFSET+CHANNEL_WORDS) begin: present
        assign coordinates[word]={row_included[Y] && column_included[X],CHANNEL_BITS'(CHANNEL-WORD_OFFSET),
                                  row_taps[Y],column_taps[X]};
      end else assign coordinates[word]=0;
    end
  endgenerate
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
    requested <= active_dot ? coordinates[window_address] : coordinates[first_address];
    alternate <= coordinates[alternate_address];
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
module actor_11 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_11_integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(2), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(9), .ACCUMULATOR_BITS(17), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(18432'hec2fd1bfd62381ecebe0daefdb02c8e30331131fb5d41bc510471db4c40c001fefe937b0dc02c9f150e3d4ed4318f9bf3b2702243efe2029150770ebe10b22330d87eea79fd320211646fb023218baedffd2c504212ddfe1272b4ce3f313343a303418a58deab0ea380b2222d227ebfe4c2a15191510d6a1eb2ae6f2e52104132b23f9adae019fd50b0ee8e023262cb8e65b0605e2240bd10b20f8efdae4c9250db90a819a4207f91c2a43dcf6d1b6d40a022527c9e506d9d80649470ed605c5e32e26c2c92405e8d4b3102a0ef706daf505c1fbd3e8bab8f426b7da00fee0e9080427988c02e4d9d4e9bc24e51b54d1f6fcfe1529f711d42c29f306e91b252359c3bdaedcfb49d71c0f0b42a741febf021d541fdcfaeadbf5ff0c0dfbe0f8e8de05c7f416ededf4cfc40409a6f0c2feebbbebec0a353052fd27fff649f118ef030fe3fafd03f409eb10ebf722dff139ece4f21316102435f3091d13c1d10308d3f7d0d7efecdf09cb21dbe70bda2c14fa9fd6046cebfb00fef813feaeadb5da0515f2ff57214111f1f90208aafabd5cfae11ed7295bf030f90328d9252c0140e6ecf702fe20f01713071fd5e75b3849e01024164323f7231ff1f9e6b51c9b33d5d910e5e64cbff9e1e210eee9f846f7e4a2edd9e4f6ddf9d508f9ebc9d2d4c9f4e405f55d2c09fdf8ddd811eec6c824fec1f8c00fffe910fc113af6ff12200fe2051aef81e716e1281b0b0401511b0711cb05fa9b0d1d241a084308e4d566f0cfd305d6cc41d1f517d00e1fa4fefae5fb81dfc32950ec36f416ff030bba5ca0b5ed47f5ed2aea171e263421faef0d10d4edc0092cdcfbe5d881332efa30dd0bd1e96ab4cefcd21c0805f11e210ae004ded6c73821fcf7ec1894361bef0eec14f81148ec15e8d6fff929241630ecda22391b1c17e2b803e41ff3c8e9fef0eff7e632fb52e3ffaae72afaf0f9d2fcf8ffdbfce0fb21c6fdb61ca1331cff14c71c0dfa5318dd0ec804fd181025e61817f62e17153ed8140fd410b33848f70b0140e1d73ed91bfbeedb2943fc1bf20ed806fdbae4f100e7fad8dff90d53dc020a26182229280d0781083aeee0ceee1630fe1b12fa17eab6fc993bb5caf2f004cc0c24eb4616051db9f858ca17e4f40d2b132038fbfa14d7199cfdb0ab122afce5f70b9a1b01f308c4033432ee09d50cfc1c8fdbd210ddbe0097dff6f9311308e70db320dee8d52bd3d4e76c250f021bf1ee439adc14f70815d71b29fc22ab2624bcb5efefbc1a0d2d060a11da21f3d0d2ff36ec15ee1222241cb44dd1cbef0652bbe60619e233ee13e468f016f2e019ff9f0307dab35f48384c14222beeeff21b06abbadabd1409f5f6c4e6c51fd54f04f0cb819cf52639fa1e07320fdb313af01aeec0b5ea19040d0f22e2babbfed2e707a692f2d942301f1107f1d69f0836f421cf05ee01cdfb24e3f11de7d2371703d7d009b6134906f727121bf8f1e7fb000fc7ec1aecf29c2dc6ed26188fd20f1fe8009cc3021fefd24c1a160ce44c00b649bcf6dfe90981ecd031db2bcaf6b22a1ef9c2feeef3b1d9e5c3040f120901c02c1bf3f0fad6cef0e34dde00c20107fd5916ee4ef5a7e0cdfbeed301e9c9e2dfd3ea0f0bc12a02c6ba1ac7ec180105e3fb0eebadf5dfabe9fedb3a388afceec0f9e1d42df40ce2f7c2f8b7fe25dad80ccaded6b2f903eae30de0200e09f91c280dceea1dfb0debcabd16f723f6d4fccfc4e181b2ebffc1e1ed04f4d5db1dedecf112b429d4ea1006d017f10420f1282adecfd0d602d40af9ded1fa36d1c50e05c7c4ce1236e617e5b33bc440f80509070134defc17f823d3e2003a4e0b012823e92e072fd4c605e2c7450f001926061ba547b5fb031723f418ccd501ffefe319eb03f71ee6d106efb501ebab25e7c2ecafffe5d727d918e3d8dffe279418d0eee60ac717000e1ffaac52fee905fc1905e123f4c0e700f40ed01cf5eb052bdbddf913dd20fdd8f5fb8150bb0629e4ed068b1e81d6e4faf0ecdafbe0b122f8dfd0f2b2fd1708aa0605c8db1a263708304202f0aca3e1de9be8d9158eb4d9e2810a1346f9ce0b811af1cde3badf21c3f81ee93ff14900ca9033ecf3c5ece0fdc8e4bdf215dc02153512eaf147e409e4caf6e0bc4e284f28c9032b36c8efe2d19ae3ce4d05e40cc22efa0a0226593ddbceee0c14e3a20e31c916dcebded5f423d43829100aeaee9c0b282a231e26eeff19321c12e3451851d21e24fbb6cb19dac32d1d235439f311cae61feb25bad5000d2ddff43b3f0102c5f5fe09ce593514a0f8e3caee02eecb121a0dfaf458060eca1720d3c9b8fc3ede030ecca8491ec0e9b417f331dbc59fec23deca06d7df01a2e8c93d8faaf717d7f803e406e2b5e2e7e6ffe64f12aafae2d018c2cdaf21030b29fa73813b1bc0cffaf20bccdefd04b628e809141514d8ecfdff0eecfbaa21e8fd06a7173ad80bd92408dcb906f3e7ff09d112e0160ed8edea05c6f023b805e6f1f2b544c12e05daf7e5501a0e14e20a090318f4f9bfd9dd0bf6d80a0dee23ed020d49e7eb1df381f9e1dbcdcddfe6eedaf7464ffffaf0efed274ac3c4c61305f6feb32d31ec01eaff20f019cbd6e2ee17d605c5f727fefeee31fb0e13dd0e120a0c39532aeb04ee080e3aed362d08e6e91deccb02bdc1f1060bd15b23241ef7f4f6f7edaf1e07cafe04d315f1f8e3e6d10f2c38eff7d3f909f00a0cc325ed0c00f0e538cc17ed190a0803d8fca1f1e028ec35fbe61bf3dc070a0bbcd8d6fb3aecf929220b15090b01f8cbd718e6f1f3e611dc81c2deccf9df02a72525d2f624e4d4cd44cf23fcbf05d7cc052616f409d9df3b242a39f02705dfd8ea26dcefc6fa3d143e392adef9e0b3280dcf21beff05bbebc01c29060625f428dc12fa0dcd982cf8d315dc041fe011b9fb1677fefaf8ecc8d2f0e524dbf2eff10a091de8f9cdb4af88cfc9101f362f070f1122fedbe04ce1f6dfe63505f5dd044c1e0724091608f2e1f6f8ae00ebc20bc2cc07fe15f3261035f5f32e3c3bccf9db19fb05eee6d3e9f805fccb3bdaeda5d7a1fd472734e3f3f61c0d24f7db0de3aec2c90d362313c4d7281e2e2e25fcb8d75d022221e300bb020cf62e2be618ff18162ed90905e3d800c7c1c0571220dce305072b06fefdd6311de4fa16f0fe0c4f07ffaff205d38121ff293761f51e0c0e55e6e2081ae941693218fe81d9cef30aeba4bd2424343833651f4904d1dbf1def7eadd29bc32), .BIASES(512'hfffffc9500000d400000088dfffffcf7fffffc56000006c000000d0dffffff33000004c000000ea5000005dc00000b4b000001aa000007c1000002a6fffffe8f), .MULTIPLIERS(512'h710000006f0000008d00000117000000960000005c0000009d000000a90000006a000000ae000000ab000000580000009a0000008f000000fd000000af), .PRODUCT_MASK(8'hff), .REQUANT_MASK(8'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .WEIGHT_MEMORY("block"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_11_integer_convolution #(
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
  actor_11_raster_window #(
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
    actor_11_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_11_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_11_serial_product #(
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
module actor_11_integer_sum #(
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
    actor_11_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_11_raster_window #(
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
  actor_11_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(8),
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
module actor_11_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_12 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_12_integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(12), .OUTPUT_CHANNELS(2), .POOL_H(1), .POOL_W(1), .KERNEL_H(1), .KERNEL_W(1), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(0), .PAD_W(0), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(9), .ACCUMULATOR_BITS(14), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(23), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(192'hfe11395de32de214618167dbc615f394f20f7fbc4d0c0ee2), .BIASES(64'hffffffd40000009d), .MULTIPLIERS(32'h19b01a8), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h0), .PIPELINED_POOL(0), .THRESHOLD_BITS(4), .THRESHOLDS(512'h909086907ca072a068b05eb054c04ac040d036e02ce022f018f00f00050ffb108c20827078d06f2065705bd0522048803ed035302b8021d018300e8004effb3), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(1)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_12_integer_convolution #(
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
  actor_12_raster_window #(
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
    actor_12_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_12_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_12_serial_product #(
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
module actor_12_integer_sum #(
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
    actor_12_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_12_raster_window #(
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
    actor_12_packed_line_store #(.ROWS(EFFECTIVE_H-1), .LINE_WORDS(LINE_WORDS), .BITS(WORD_BITS), .MEMORY_STYLE(MEMORY_STYLE)) storage (
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
module actor_12_packed_line_store #(
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
module actor_13 (
input wire clk, rst,
input wire [63:0] in_data,
input wire [1:0] in_valid, output wire [1:0] in_ready,
output wire [31:0] out_data, output wire out_valid, input wire out_ready);
wire available, release_window, select_alternate, active_dot;
wire [5:0] window_address, alternate_address, first_address;
wire [31:0] window_data;
wire [1:0] ready, finished;
reg done;
reg [6:0] output_row;
reg [7:0] output_column;
wire advance_frame = done && (&finished);
assign available = !rst && !done && (&ready);
always @(posedge clk) begin
  if (rst || advance_frame) begin output_row <= 0; output_column <= 0; done <= 0; end
  else if (release_window) begin
    if (output_column == 251) begin
      output_column <= 0;
      if (output_row == 127) done <= 1;
      else output_row <= output_row + 1'b1;
    end else output_column <= output_column + 1'b1;
  end
end
wire [63:0] branch_data;

wire [31:0] bounded_input_0;
assign bounded_input_0[0 +: 8] = 8'(in_data[0 +: 4]);
assign bounded_input_0[8 +: 8] = 8'(in_data[8 +: 4]);
assign bounded_input_0[16 +: 8] = 8'(in_data[16 +: 4]);
assign bounded_input_0[24 +: 8] = 8'(in_data[24 +: 4]);
wire [15:0] stored_0;
actor_13_view_rows #(.OUTPUT_HEIGHT(128), .OUTPUT_WIDTH(252), .KERNEL_H(3), .KERNEL_W(3), .LANES(4), .BITS(4), .OUTPUT_BITS(4), .QUANTIZE_ON_READ(0), .SOURCE_SIGNED(0), .CHANNELS(16), .TOTAL_CHANNEL_WORDS(5), .WORD_OFFSET(0), .WORDS(32256), .DEPTH(1008), .CROSS_FRAME(1), .ROW_WORDS(504), .LAST_USED_COLUMN(251), .FIRST_COLUMN(0), .MEMORY_STYLE("block"), .ROW_ADDRESSES(3840'h1f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e00000000001f8001f87e1f87e0007e0000000000000), .COLUMN_ADDRESSES(7560'h1f47d1f47d1f07d1f07c1f07c1ec7c1ec7b1ec7b1e87b1e87a1e87a1e47a1e4791e4791e0791e0781e0781dc781dc771dc771d8771d8761d8761d4761d4751d4751d0751d0741d0741cc741cc731cc731c8731c8721c8721c4721c4711c4711c0711c0701c0701bc701bc6f1bc6f1b86f1b86e1b86e1b46e1b46d1b46d1b06d1b06c1b06c1ac6c1ac6b1ac6b1a86b1a86a1a86a1a46a1a4691a4691a0691a0681a06819c6819c6719c6719867198661986619466194651946519065190641906418c6418c6318c6318863188621886218462184611846118061180601806017c6017c5f17c5f1785f1785e1785e1745e1745d1745d1705d1705c1705c16c5c16c5b16c5b1685b1685a1685a1645a164591645916059160581605815c5815c5715c5715857158561585615456154551545515055150541505414c5414c5314c5314853148521485214452144511445114051140501405013c5013c4f13c4f1384f1384e1384e1344e1344d1344d1304d1304c1304c12c4c12c4b12c4b1284b1284a1284a1244a124491244912049120481204811c4811c4711c4711847118461184611446114451144511045110441104410c4410c4310c431084310842108421044210441104411004110040100400fc400fc3f0fc3f0f83f0f83e0f83e0f43e0f43d0f43d0f03d0f03c0f03c0ec3c0ec3b0ec3b0e83b0e83a0e83a0e43a0e4390e4390e0390e0380e0380dc380dc370dc370d8370d8360d8360d4360d4350d4350d0350d0340d0340cc340cc330cc330c8330c8320c8320c4320c4310c4310c0310c0300c0300bc300bc2f0bc2f0b82f0b82e0b82e0b42e0b42d0b42d0b02d0b02c0b02c0ac2c0ac2b0ac2b0a82b0a82a0a82a0a42a0a4290a4290a0290a0280a02809c2809c2709c2709827098260982609426094250942509025090240902408c2408c2308c2308823088220882208422084210842108021080200802007c2007c1f07c1f0781f0781e0781e0741e0741d0741d0701d0701c0701c06c1c06c1b06c1b0681b0681a0681a0641a064190641906019060180601805c1805c1705c1705817058160581605416054150541505015050140501404c1404c1304c1304813048120481204412044110441104011040100401003c1003c0f03c0f0380f0380e0380e0340e0340d0340d0300d0300c0300c02c0c02c0b02c0b0280b0280a0280a0240a024090240902009020080200801c0801c0701c0701807018060180601406014050140501005010040100400c0400c0300c03008030080200802004020040100401000010000000000000), .COLUMN_AFFINE(3'h7), .COLUMN_SHIFTS(9'h49), .COLUMN_STEPS(30'h401004), .COLUMN_BASES(480'h1000000000000000000000000000000000000000000000000000000000000000000000000000000003fc), .ROW_VALID(384'h7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .COLUMN_VALID(756'h7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .REQUIRED_ROWS(2048'h7c087c087c087a107a1078187818762076207428742872307230703870386e406e406c486c486a506a5068586858666066606468646862706270607860785e805e805c885c885a905a905898589856a056a054a854a852b052b050b850b84ec04ec04cc84cc84ad04ad048d848d846e046e044e844e842f042f040f840f83f003f003d083d083b103b1039183918372037203528352833303330313831382f402f402d482d482b502b5029582958276027602568256823702370217821781f801f801d881d881b901b901998199817a017a015a815a813b013b011b811b80fc00fc00dc80dc80bd00bd009d809d807e007e005e805e803f003f001f801f80000), .VALID_ROWS(128'hffffffffffffffffffffffffffffffff), .LIMITS(2048'h7ff87e007e007c087c087a107a1078187818762076207428742872307230703870386e406e406c486c486a506a5068586858666066606468646862706270607860785e805e805c885c885a905a905898589856a056a054a854a852b052b050b850b84ec04ec04cc84cc84ad04ad048d848d846e046e044e844e842f042f040f840f83f003f003d083d083b103b1039183918372037203528352833303330313831382f402f402d482d482b502b5029582958276027602568256823702370217821781f801f801d881d881b901b901998199817a017a015a815a813b013b011b811b80fc00fc00dc80dc80bd00bd009d809d807e007e005e805e803f003f003f0), .RELEASE_COLUMNS(128'hd5555555555555555555555555555554), .TABLE_COUNT(1), .CHANNEL_TABLES(16'h0), .TABLES(1024'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffeddcba988765433210)) rows_0 (
.clk(clk), .rst(rst), .advance_frame(advance_frame), .done(done), .release_window(release_window),
.output_row(output_row), .output_column(output_column),
.in_data(bounded_input_0), .in_valid(in_valid[0]), .in_ready(in_ready[0]),
.ready(ready[0]), .finished(finished[0]),
.window_address(window_address), .alternate_address(alternate_address), .first_address(first_address),
.select_alternate(select_alternate), .active_dot(active_dot),
.window_data(stored_0));
assign branch_data[0 +: 8] = 8'(stored_0[0 +: 4]);
assign branch_data[8 +: 8] = 8'(stored_0[4 +: 4]);
assign branch_data[16 +: 8] = 8'(stored_0[8 +: 4]);
assign branch_data[24 +: 8] = 8'(stored_0[12 +: 4]);
wire [31:0] bounded_input_1;
assign bounded_input_1[0 +: 8] = 8'(in_data[32 +: 4]);
assign bounded_input_1[8 +: 8] = 8'(in_data[40 +: 4]);
assign bounded_input_1[16 +: 8] = 8'd0;
assign bounded_input_1[24 +: 8] = 8'd0;
wire [15:0] stored_1;
actor_13_view_rows #(.OUTPUT_HEIGHT(128), .OUTPUT_WIDTH(252), .KERNEL_H(3), .KERNEL_W(3), .LANES(4), .BITS(4), .OUTPUT_BITS(4), .QUANTIZE_ON_READ(0), .SOURCE_SIGNED(0), .CHANNELS(2), .TOTAL_CHANNEL_WORDS(5), .WORD_OFFSET(4), .WORDS(32256), .DEPTH(8064), .CROSS_FRAME(1), .ROW_WORDS(252), .LAST_USED_COLUMN(251), .FIRST_COLUMN(0), .MEMORY_STYLE("block"), .ROW_ADDRESSES(4992'h7a13b11e84ec47233b11c8cdc87233721a94dc86a53331a94ccc627333189cbd06272f416a4bd05a92b516a4ad452b2b514ac9d852b27612b49d84ad23712b48dc42f23710bc7e042f1f80ec47e03b11b90ec46e43331b90ccc5e833317a0ad45e82b513b0ad44ec23713b08dc3f02370fc06e43f01b90bd06e42f413b0bd04ec1f813b07e02f41f80bd03f02f40fc03f03f00fc00003f0001e840007a13b11e84ec47233b11c8cdc87233721a94dc86a53331a94ccc627333189cbd06272f416a4bd05a92b516a4ad452b2b514ac9d852b27612b49d84ad23712b48dc42f23710bc7e042f1f80ec47e03b11b90ec46e43331b90ccc5e833317a0ad45e82b513b0ad44ec23713b08dc3f02370fc06e43f01b90bd06e42f413b0bd04ec1f813b07e02f41f80bd03f02f40fc03f03f00fc00003f0001e840007a13b11e84ec47233b11c8cdc87233721a94dc86a53331a94ccc627333189cbd06272f416a4bd05a92b516a4ad452b2b514ac9d852b27612b49d84ad23712b48dc42f23710bc7e042f1f80ec47e03b11b90ec46e43331b90ccc5e833317a0ad45e82b513b0ad44ec23713b08dc3f02370fc06e43f01b90bd06e42f413b0bd04ec1f813b07e02f41f80bd03f02f40fc03f03f00fc00003f0001e840007a13b11e84ec47233b11c8cdc87233721a94dc86a53331a94ccc627333189cbd06272f416a4bd05a92b516a4ad452b2b514ac9d852b27612b49d84ad23712b48dc42f23710bc7e042f1f80ec47e03b11b90ec46e43331b90ccc5e833317a0ad45e82b513b0ad44ec23713b08dc3f02370fc06e43f01b90bd06e42f413b0bd04ec1f813b07e02f41f80bd03f02f40fc03f03f00fc00003f0000000), .COLUMN_ADDRESSES(9828'h3ec1f40fb07d03e41f40f907c03e41f00f707c03dc1ec0f707b03d41ec0f507a03d41e80f307a03cc1e40f307903c41e40f107803c41e00ef07803bc1dc0ef07703b41dc0ed07603b41d80eb07603ac1d40eb07503a41d40e907403a41d00e7074039c1cc0e707303941cc0e507203941c80e3072038c1c40e307103841c40e107003841c00df070037c1bc0df06f03741bc0dd06e03741b80db06e036c1b40db06d03641b40d906c03641b00d706c035c1ac0d706b03541ac0d506a03541a80d306a034c1a40d306903441a40d106803441a00cf068033c19c0cf067033419c0cd06603341980cb066032c1940cb06503241940c906403241900c7064031c18c0c7063031418c0c506203141880c3062030c1840c306103041840c106003041800bf06002fc17c0bf05f02f417c0bd05e02f41780bb05e02ec1740bb05d02e41740b905c02e41700b705c02dc16c0b705b02d416c0b505a02d41680b305a02cc1640b305902c41640b105802c41600af05802bc15c0af05702b415c0ad05602b41580ab05602ac1540ab05502a41540a905402a41500a7054029c14c0a7053029414c0a505202941480a3052028c1440a305102841440a1050028414009f050027c13c09f04f027413c09d04e027413809b04e026c13409b04d026413409904c026413009704c025c12c09704b025412c09504a025412809304a024c1240930490244124091048024412008f048023c11c08f047023411c08d046023411808b046022c11408b04502241140890440224110087044021c10c087043021410c0850420214108083042020c1040830410204104081040020410007f04001fc0fc07f03f01f40fc07d03e01f40f807b03e01ec0f407b03d01e40f407903c01e40f007703c01dc0ec07703b01d40ec07503a01d40e807303a01cc0e407303901c40e407103801c40e006f03801bc0dc06f03701b40dc06d03601b40d806b03601ac0d406b03501a40d406903401a40d0067034019c0cc06703301940cc06503201940c8063032018c0c406303101840c406103001840c005f030017c0bc05f02f01740bc05d02e01740b805b02e016c0b405b02d01640b405902c01640b005702c015c0ac05702b01540ac05502a01540a805302a014c0a405302901440a405102801440a004f028013c09c04f027013409c04d026013409804b026012c09404b02501240940490240124090047024011c08c047023011408c0450220114088043022010c0840430210104084041020010408003f02000fc07c03f01f00f407c03d01e00f407803b01e00ec07403b01d00e407403901c00e407003701c00dc06c03701b00d406c03501a00d406803301a00cc06403301900c406403101800c406002f01800bc05c02f01700b405c02d01600b405802b01600ac05402b01500a405402901400a4050027014009c04c027013009404c0250120094048023012008c0440230110084044021010008404001f010007c03c01f00f007403c01d00e007403801b00e006c03401b00d006403401900c006403001700c005c02c01700b005402c01500a005402801300a004c0240130090044024011008004402000f008003c01c00f007003401c00d006003401800b006002c01400b00500240140090040024010007004001c00c007003001400c0050020014008003002000c00400300100040040010000004000000), .COLUMN_AFFINE(3'h7), .COLUMN_SHIFTS(9'h0), .COLUMN_STEPS(39'h4002001), .COLUMN_BASES(624'h100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000001fff), .ROW_VALID(384'h7ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .COLUMN_VALID(756'h7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffe), .REQUIRED_ROWS(2048'h7d047d047c087b0c7a1079147818771c762075247428732c7230713470386f3c6e406d446c486b4c6a5069546858675c666065646468636c6270617460785f7c5e805d845c885b8c5a9059945898579c56a055a454a853ac52b051b450b84fbc4ec04dc44cc84bcc4ad049d448d847dc46e045e444e843ec42f041f440f83ffc3f003e043d083c0c3b103a143918381c372036243528342c333032343138303c2f402e442d482c4c2b502a542958285c276026642568246c237022742178207c1f801e841d881c8c1b901a941998189c17a016a415a814ac13b012b411b810bc0fc00ec40dc80ccc0bd00ad409d808dc07e006e405e804ec03f002f401f800fc), .VALID_ROWS(128'hffffffffffffffffffffffffffffffff), .LIMITS(2048'h9b889a8c999098949798969c95a094a493a892ac91b090b48fb88ebc8dc08cc48bc88acc89d088d487d886dc85e084e483e882ec81f080f47ff87efc7e007d047c087b0c7a1079147818771c762075247428732c7230713470386f3c6e406d446c486b4c6a5069546858675c666065646468636c6270617460785f7c5e805d845c885b8c5a9059945898579c56a055a454a853ac52b051b450b84fbc4ec04dc44cc84bcc4ad049d448d847dc46e045e444e843ec42f041f440f83ffc3f003e043d083c0c3b103a143918381c372036243528342c333032343138303c2f402e442d482c4c2b502a542958285c276026642568246c237022742178207c1f801f80), .RELEASE_COLUMNS(128'hfffffffffffffffffffffffffffffffe), .TABLE_COUNT(1), .CHANNEL_TABLES(2'h0), .TABLES(1024'hffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffecb9865320)) rows_1 (
.clk(clk), .rst(rst), .advance_frame(advance_frame), .done(done), .release_window(release_window),
.output_row(output_row), .output_column(output_column),
.in_data(bounded_input_1), .in_valid(in_valid[1]), .in_ready(in_ready[1]),
.ready(ready[1]), .finished(finished[1]),
.window_address(window_address), .alternate_address(alternate_address), .first_address(first_address),
.select_alternate(select_alternate), .active_dot(active_dot),
.window_data(stored_1));
assign branch_data[32 +: 8] = 8'(stored_1[0 +: 4]);
assign branch_data[40 +: 8] = 8'(stored_1[4 +: 4]);
assign branch_data[48 +: 8] = 8'(stored_1[8 +: 4]);
assign branch_data[56 +: 8] = 8'(stored_1[12 +: 4]);
assign window_data = branch_data[0 +: 32] | branch_data[32 +: 32];
actor_13_integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(18), .OUTPUT_CHANNELS(8), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(8), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(2), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(11), .ACCUMULATOR_BITS(15), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(26), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(7776'hf06d8304e03bf8be8ae79f50f39ac1d85f4813f18148930a0f014202ff8810fd50d3b204e41d7ecc90bad05e01b3bcbf173ab0f3614e13ff1313017ddc40bc1890034402382c633530ad38dccf0a086c79876fc22c2dffa46e37a022acff38c4fc346707417d0f708027422af4ad87fc6dfa206c89c12289e87c3ef933450c64c740523cfc1e880b5f86143f900d04041eceb71fa0fb141df0d74006107c8307a0ce0fddcbc3f03cdf82d10801031baeb340e1bdf44cbcd7ee79fb593cfb92c2271e8dcc9d7c846e3ce868cf1000370352012eae2befc12517beffc7ed6fffb13be0bf7ae79ffbed33390762f34941ca1c9f00001cbf2bad36d811f70f31f20be0f80bbe45ec413f247bfe0b6e42ebff7ecb90eb1fbe8c2091023bd184310ebfbc3d89e07ff01b1d88e32db2002bbce0e009b92e44efac0f177df0bcafc5280843f740731a785f0baf79ec5845c78fcbcbcc10d0bfcde8a012292e8dfa710c1e3e0e396c06e444863f91c5f7fd40e39ef8cb9d351b707f139102c7a18ff7dc3ddc038d2b7f081fb1ceed1fb7e8618104010a0bdd73ca853c336080a83df9e4530007fffc202cbfea10bd029baa9fed61300f9a3fc0415fa231b02486abbf8a1cc20c1883bf18b112dc15072ff0ba4ccec114518e57a185ec90f60c7d07c3810dfc9c78e35fc4e71036d09d32f3c1570c81151791c8196eb9e150bdf820f9643ab51ba27f53efd1d8bcfcc43a81102c92e72106cb708edeeaf4e3bdf1c52dc918084fffd0b2c44f87e0b0fe0cb047d8458015624ce4b37e104ef40fbc34c7f3faeb7e46dfdef8fbbf83ff7183e8bf44db7fc1d3ddfa002cf6e382461bc2d3fbb04b21d3bedd5fbbf39e6c475a00fff1bae7704acfd140c92c44cb4c05ffa101f022c318c00afca0cdd6998b0b6037012f07e37f4cd39e7de440cae3fd8223c276fbe2003ecf491d1dd0bba006f43d44e09dbc001101ab614804bc2eef8fc3e69ebcccdeb51fb0fd2faffbef41b71440f7dcdfb924630f4420c8da537e3be26ac3cdbc2731772bc1453839f9b2af86dedff69b9ba40b0b52232f3517dfe7dc32fcf3df86f8c2c408717f40fd41c062bf33adb627cbb5dc02440aff0becd004cc1dcecc3c901cdd7feffdba0b0f2be4ddbbd02fc81be246e4038900a340287e390411fa2ffb7ad7a3f37faf3fdf5ac8b08c0707eac3af4038ceffc3c7eeab0c9f6dfcfe4eec4f08dcb1b5d07f4cc4ac8400fec4f83332347e37efa10144103243cf73ffd384f7cd05f4fec4106bc0f78cfff3ba75ef2f05173cc4f7ff2bec01020b004b40314818f4b110dd01fc5ef9e72955036debff40faaf91c3c89d0eff5a3abedefdfc407cd4bfb52cc102), .BIASES(256'hea000001cc000002150000004500000101000002f800000254000001cf), .MULTIPLIERS(128'h61403b101cd0614020903b8022701b4), .PRODUCT_MASK(16'hffff), .REQUANT_MASK(16'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(2), .EXTERNAL_WINDOW(1), .WEIGHT_MEMORY("logic")) actor (
.clk(clk), .rst(rst), .in_data(32'(0)), .in_valid(1'b0), .in_ready(),
.out_data(out_data), .out_valid(out_valid), .out_ready(out_ready),
.external_available(available), .external_data(window_data), .external_release(release_window),
.external_address(window_address), .external_alternate(alternate_address), .external_first(first_address),
.external_select(select_alternate), .external_active(active_dot));
endmodule
module actor_13_integer_convolution #(
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
  actor_13_raster_window #(
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
    actor_13_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_13_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_13_serial_product #(
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
module actor_13_integer_sum #(
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
    actor_13_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_13_raster_window #(
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
    actor_13_packed_line_store #(.ROWS(EFFECTIVE_H-1), .LINE_WORDS(LINE_WORDS), .BITS(WORD_BITS), .MEMORY_STYLE(MEMORY_STYLE)) storage (
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
module actor_13_packed_line_store #(
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
module actor_13_view_rows #(
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
  input wire [WINDOW_BITS-1:0] window_address, alternate_address, first_address,
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
  wire [COORD_BITS-1:0] coordinates [0:WINDOW_WORDS-1];
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
    for (word=0; word<WINDOW_WORDS; word=word+1) begin: coordinate
      localparam integer Y=word/(KERNEL_W*TOTAL_CHANNEL_WORDS);
      localparam integer X=(word/TOTAL_CHANNEL_WORDS)%KERNEL_W;
      localparam integer CHANNEL=word%TOTAL_CHANNEL_WORDS;
      if (CHANNEL >= WORD_OFFSET && CHANNEL < WORD_OFFSET+CHANNEL_WORDS) begin: present
        assign coordinates[word]={row_included[Y] && column_included[X],CHANNEL_BITS'(CHANNEL-WORD_OFFSET),
                                  row_taps[Y],column_taps[X]};
      end else assign coordinates[word]=0;
    end
  endgenerate
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
    requested <= active_dot ? coordinates[window_address] : coordinates[first_address];
    alternate <= coordinates[alternate_address];
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
module actor_14 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_14_integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(8), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(4), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(2), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(10), .ACCUMULATOR_BITS(13), .INNER_BITS(19), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(22), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(4608'h2feff0000ff0200fcfe01ff0200ff00fcf7fe02ff00fe00fefc02fe010000ff01feff0000ffff02fdff00ff0002fc00fdf8ff01fefb00fcfefd03ff01ff020000010000ff00fd02fcfc00fe00fffcfefffd00ffff0003ff00fe030003ff01fe00fa000001000201fbfa01ff020000fefcfefcfd00fcfe00fbfb01fd0000fffe7ffb007f01ff0101fefdff017f02ff7ffcf7fe01fefbfefffdfb03ff01ff02ff0000ff000000fd00fdffffffff01fc01fdfeff00fe00fbff00fc03ff02ff01fa00fbff0100010201fa00020002ff0000fefcfe0201feff02fefc00ffff01fdff00fcffff00000100fdfb01fd01fe02fefcfbfe00fffdfffefffb01ff020001ff010000ffff01fefffc0200fe01000300fd00fffdff00fcff02fd0100020001ff0000fffdff00ff0003fdfe01010203000004fc01ffff0004000103fb01ff010100fffeffff00ffff0100fbfeff0201000103fe00ff000003010102fd01ff0201ffff00feff00ffff01fffefe00fd01000100ff02fffe01020301030001ff0201010000faff00000103fdfeff010003fe00fcf8fdfdfd00ffff0000f900fd00000001fefeff0100010000fafffe0100017ffffd7ffe000001020001fc7ffd017fff0000fcff00ff00ff04fdfdffff000300feff00fffe0000020001ff01ff0100010100feff00010102000000020003fe00fffd03fe010002ff0001fdffffff00ff01fefeff00ff0101fefcfc00fe01fd00ff0001ffff0101020000ff00ff0101fe01fefcfefffe010001fdfb00fe010100ff0000fffd01000300010100ff0201), .BIASES(256'h2fffffffcfffffffdfffffff8fffffffdfffffffafffffffefffffffe), .MULTIPLIERS(128'h21c0215021402150213021402160213), .PRODUCT_MASK(8'hff), .REQUANT_MASK(8'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .QUANTIZER_LANES(2), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(3)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_14_integer_convolution #(
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
  actor_14_raster_window #(
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
    actor_14_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_14_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_14_serial_product #(
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
module actor_14_integer_sum #(
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
    actor_14_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_14_raster_window #(
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
  actor_14_window_storage #(.WIDTH(STORAGE_BITS),.DEPTH(DEPTH),.BANK_WIDTH(STORAGE_BITS),
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
module actor_14_window_storage #(
  parameter integer WIDTH=8, DEPTH=1, BANK_WIDTH=8, PIPELINED_READ=1,
  parameter MEMORY_STYLE="auto",
  localparam integer ADDRESS_BITS=DEPTH<=1 ? 1 : $clog2(DEPTH)
) (
  input wire clk, write_enable,
  input wire [ADDRESS_BITS-1:0] write_address, read_address,
  input wire [WIDTH-1:0] write_data,
  output wire [WIDTH-1:0] read_data
);
  genvar bank;
  generate for (bank=0; bank<(WIDTH+BANK_WIDTH-1)/BANK_WIDTH; bank=bank+1) begin: banks
    localparam integer BITS=WIDTH-bank*BANK_WIDTH<BANK_WIDTH ? WIDTH-bank*BANK_WIDTH : BANK_WIDTH;
    (* ram_style=MEMORY_STYLE, no_rw_check *) reg [BITS-1:0] memory [0:DEPTH-1];
    always @(posedge clk) if (write_enable) memory[write_address] <= write_data[bank*BANK_WIDTH +: BITS];
    if (PIPELINED_READ != 0) begin: synchronous
      reg [BITS-1:0] data;
      always @(posedge clk) data <= memory[read_address];
      assign read_data[bank*BANK_WIDTH +: BITS]=data;
    end else begin: asynchronous
      assign read_data[bank*BANK_WIDTH +: BITS]=memory[read_address];
    end
  end endgenerate
endmodule
module actor_15 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  actor_15_integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(1), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(8), .WEIGHT_BITS(8), .OUTPUT_SIGNED(1), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .MULTIPLIER_BITS(9), .ACCUMULATOR_BITS(18), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(26), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'hffffffffffffff80), .HIGH(64'h7f), .WEIGHTS(576'hacab9aba5d0bda434c8c2af99b3a8c141e4bec8cab6bbbeeab0a081b7c0cfc435a6b7add8c9b5d14a8dd3b7b78f9ab7ffd4baa6b6c7c2ce2abaaaa4cca9b4ba31c0b6d6d7c3bbb4), .BIASES(32'hffffffe1), .MULTIPLIERS(16'h122), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h0), .PIPELINED_POOL(0), .OVERLAP_QUANTIZER(1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("block"), .PACKED_LINES(2)) actor (
    .external_available(1'b0), .external_data(32'(0)), .external_release(),
    .external_address(), .external_alternate(), .external_first(), .external_select(), .external_active(), .*);
endmodule
module actor_15_integer_convolution #(
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
  actor_15_raster_window #(
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
    actor_15_integer_sum #(.WORDS(REDUCTION_LANES), .BITS(DOT_SUM_BITS)) dot_adder (
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
      actor_15_serial_product #(.VALUE_BITS(ACCUMULATOR_BITS), .COEFFICIENT_BITS(MULTIPLIER_BITS),
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
module actor_15_serial_product #(
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
module actor_15_integer_sum #(
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
    actor_15_integer_sum #(.WORDS(2*GROUPS+REMAINDER), .BITS(BITS)) next_level (.values(reduced), .sum(sum));
  end endgenerate
endmodule
module actor_15_raster_window #(
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
    localparam integer DEPTH = 1 << $clog2(SPAN);
    reg [INDEX_BITS-1:0] write_index, origin;
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
      if (rst) begin write_index <= 0; origin <= 0; end
      else if (commit) begin
        write_index <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+1'b1;
        if (pending_output) origin <= DEPTH == 1 ? INDEX_BITS'(0) : write_index+INDEX_BITS'(1-SPAN);
      end
      if (!rst && commit) memory[write_index] <= pending_data;
    end
    if (PIPELINED_READ != 0) begin: pipelined
      reg [INDEX_BITS-1:0] requested, first, alternate;
      reg use_first, use_alternate;
      wire [INDEX_BITS-1:0] offset = ALTERNATE_READ != 0 && use_alternate ? alternate :
        STARTUP_READ != 0 && use_first ? first : requested;
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+offset;
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
      wire [INDEX_BITS-1:0] location = DEPTH == 1 ? INDEX_BITS'(0) : origin+coordinates[window_address];
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
module actor_16 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  
  integer_lookup #(.CHANNELS(1), .LANES(4), .TABLE(2048'h101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010101010100)) actor (.*);
endmodule
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
// DEPTH counts all live words, including the output register. The memory has
// one spare slot, avoiding ambiguous same-address block-RAM reads and writes.
// Readiness depends only on registered occupancy: a retired slot is reusable
// on the following edge, breaking combinational backpressure across actors.
module stream_fifo #(
  parameter integer WIDTH = 8, DEPTH = 2,
  parameter MEMORY_STYLE = "auto"
) (
  input wire clk, input wire rst,
  input wire [WIDTH-1:0] in_data, input wire in_valid, output wire in_ready,
  output wire [WIDTH-1:0] out_data, output wire out_valid, input wire out_ready
);
  generate if (DEPTH == 1) begin: single
    reg [WIDTH-1:0] data;
    reg valid;
    assign in_ready = !rst && !valid;
    assign out_valid = !rst && valid;
    assign out_data = data;
    always @(posedge clk) begin
      if (rst) valid <= 0;
      else begin
        if (out_ready) valid <= 0;
        if (in_valid && in_ready) begin
          valid <= 1;
          data <= in_data;
        end
      end
    end
  end else if (DEPTH == 2) begin: pair
    // Two registers sustain one transfer per edge without a RAM read stage.
    // Ready depends only on occupancy; downstream ready does not propagate
    // combinationally across the FIFO. A full queue releases credit next edge.
    reg [WIDTH-1:0] head, tail;
    reg head_valid, tail_valid;
    wire push=in_valid && in_ready;
    assign in_ready=!rst && !tail_valid;
    assign out_valid=!rst && head_valid;
    assign out_data=head;
    always @(posedge clk) begin
      if (rst) begin head_valid <= 0; tail_valid <= 0; end
      else begin
        // The three reachable states are empty, head only, and head+tail.
        // Direct next-state equations avoid cascaded pop/push priority muxes.
        head_valid <= in_valid || tail_valid || (head_valid && !out_ready);
        tail_valid <= !out_ready && (tail_valid || (in_valid && head_valid));
        // Select data using registered occupancy. Downstream ready controls
        // only the enable, keeping it off the data mux and its fanout.
        if ((out_ready && tail_valid) || (push && (!head_valid || out_ready)))
          head <= tail_valid ? tail : in_data;
        if (push && head_valid && !out_ready) tail <= in_data;
      end
    end
  end else begin: buffered
    localparam integer ADDRESS_BITS = $clog2(DEPTH);
    localparam integer COUNT_BITS = $clog2(DEPTH+1);
    (* ram_style = MEMORY_STYLE *) reg [WIDTH-1:0] memory [0:DEPTH-1];
    reg [WIDTH-1:0] data;
    reg valid;
    reg [ADDRESS_BITS-1:0] read_index, write_index;
    reg [COUNT_BITS-1:0] count;
    wire pop = out_valid && out_ready;
    wire push = in_valid && in_ready;
    wire read_word = !rst && (!valid || out_ready) && count > COUNT_BITS'(valid);
    assign in_ready = !rst && count < COUNT_BITS'(DEPTH);
    assign out_valid = !rst && valid;
    assign out_data = data;
    always @(posedge clk) begin
      if (push) memory[write_index] <= in_data;
      if (read_word) data <= memory[read_index];
    end
    always @(posedge clk) begin
      if (rst) begin
        valid <= 0;
        count <= 0;
        read_index <= 0;
        write_index <= 0;
      end else begin
        if (pop) valid <= 0;
        if (read_word) begin
          valid <= 1;
          read_index <= read_index == ADDRESS_BITS'(DEPTH-1) ? ADDRESS_BITS'(0) : read_index + 1'b1;
        end
        if (push) write_index <= write_index == ADDRESS_BITS'(DEPTH-1) ? ADDRESS_BITS'(0) : write_index + 1'b1;
        case ({push, pop})
          2'b10: count <= count + 1'b1;
          2'b01: count <= count - 1'b1;
          default: ;
        endcase
      end
    end
  end endgenerate
endmodule
