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
wire [31:0] data_17; wire valid_17, ready_17;
wire [31:0] data_18; wire valid_18, ready_18;
wire [31:0] data_19; wire valid_19, ready_19;
wire [31:0] data_20; wire valid_20, ready_20;
assign data_0 = in_data; assign valid_0 = in_valid; assign in_ready = ready_0;
assign out_data = data_20; assign out_valid = valid_20; assign ready_20 = out_ready;
wire [31:0] edge_data_0; wire edge_valid_0, edge_ready_0, space_0;
wire [23:0] packed_input_0, packed_output_0;
assign packed_input_0[0 +: 8] = 8'(data_0[0 +: 8]);
assign packed_input_0[8 +: 8] = 8'(data_0[8 +: 8]);
assign packed_input_0[16 +: 8] = 8'(data_0[16 +: 8]);
assign edge_data_0[0 +: 8] = 8'(packed_output_0[0 +: 8]);
assign edge_data_0[8 +: 8] = 8'(packed_output_0[8 +: 8]);
assign edge_data_0[16 +: 8] = 8'(packed_output_0[16 +: 8]);
assign edge_data_0[31:24] = '0;
stream_fifo #(.WIDTH(24), .DEPTH(8)) fifo_0 (
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
stream_fifo #(.WIDTH(16), .DEPTH(8)) fifo_1 (
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_2 (
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
stream_fifo #(.WIDTH(16), .DEPTH(256), .MEMORY_STYLE("distributed")) fifo_3 (
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_4 (
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
stream_fifo #(.WIDTH(16), .DEPTH(128), .MEMORY_STYLE("distributed")) fifo_5 (
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_6 (
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_7 (
.clk(clk), .rst(rst), .in_data(packed_input_7), .in_valid(valid_7 && ready_7), .in_ready(space_7),
.out_data(packed_output_7), .out_valid(edge_valid_7), .out_ready(edge_ready_7));
wire [31:0] edge_data_8; wire edge_valid_8, edge_ready_8, space_8;
wire [15:0] packed_input_8, packed_output_8;
assign packed_input_8[0 +: 4] = 4'(data_8[0 +: 8]);
assign packed_input_8[4 +: 4] = 4'(data_8[8 +: 8]);
assign packed_input_8[8 +: 4] = 4'(data_8[16 +: 8]);
assign packed_input_8[12 +: 4] = 4'(data_8[24 +: 8]);
assign edge_data_8[0 +: 8] = 8'(packed_output_8[0 +: 4]);
assign edge_data_8[8 +: 8] = 8'(packed_output_8[4 +: 4]);
assign edge_data_8[16 +: 8] = 8'(packed_output_8[8 +: 4]);
assign edge_data_8[24 +: 8] = 8'(packed_output_8[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_8 (
.clk(clk), .rst(rst), .in_data(packed_input_8), .in_valid(valid_8 && ready_8), .in_ready(space_8),
.out_data(packed_output_8), .out_valid(edge_valid_8), .out_ready(edge_ready_8));
wire [31:0] edge_data_9; wire edge_valid_9, edge_ready_9, space_9;
wire [15:0] packed_input_9, packed_output_9;
assign packed_input_9[0 +: 4] = 4'(data_4[0 +: 8]);
assign packed_input_9[4 +: 4] = 4'(data_4[8 +: 8]);
assign packed_input_9[8 +: 4] = 4'(data_4[16 +: 8]);
assign packed_input_9[12 +: 4] = 4'(data_4[24 +: 8]);
assign edge_data_9[0 +: 8] = 8'(packed_output_9[0 +: 4]);
assign edge_data_9[8 +: 8] = 8'(packed_output_9[4 +: 4]);
assign edge_data_9[16 +: 8] = 8'(packed_output_9[8 +: 4]);
assign edge_data_9[24 +: 8] = 8'(packed_output_9[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_9 (
.clk(clk), .rst(rst), .in_data(packed_input_9), .in_valid(valid_4 && ready_4), .in_ready(space_9),
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_10 (
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
stream_fifo #(.WIDTH(16), .DEPTH(2048)) fifo_11 (
.clk(clk), .rst(rst), .in_data(packed_input_11), .in_valid(valid_10 && ready_10), .in_ready(space_11),
.out_data(packed_output_11), .out_valid(edge_valid_11), .out_ready(edge_ready_11));
wire [31:0] edge_data_12; wire edge_valid_12, edge_ready_12, space_12;
wire [15:0] packed_input_12, packed_output_12;
assign packed_input_12[0 +: 4] = 4'(data_11[0 +: 8]);
assign packed_input_12[4 +: 4] = 4'(data_11[8 +: 8]);
assign packed_input_12[8 +: 4] = 4'(data_11[16 +: 8]);
assign packed_input_12[12 +: 4] = 4'(data_11[24 +: 8]);
assign edge_data_12[0 +: 8] = 8'(packed_output_12[0 +: 4]);
assign edge_data_12[8 +: 8] = 8'(packed_output_12[4 +: 4]);
assign edge_data_12[16 +: 8] = 8'(packed_output_12[8 +: 4]);
assign edge_data_12[24 +: 8] = 8'(packed_output_12[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(8)) fifo_12 (
.clk(clk), .rst(rst), .in_data(packed_input_12), .in_valid(valid_11 && ready_11), .in_ready(space_12),
.out_data(packed_output_12), .out_valid(edge_valid_12), .out_ready(edge_ready_12));
wire [31:0] edge_data_13; wire edge_valid_13, edge_ready_13, space_13;
wire [15:0] packed_input_13, packed_output_13;
assign packed_input_13[0 +: 4] = 4'(data_12[0 +: 8]);
assign packed_input_13[4 +: 4] = 4'(data_12[8 +: 8]);
assign packed_input_13[8 +: 4] = 4'(data_12[16 +: 8]);
assign packed_input_13[12 +: 4] = 4'(data_12[24 +: 8]);
assign edge_data_13[0 +: 8] = 8'(packed_output_13[0 +: 4]);
assign edge_data_13[8 +: 8] = 8'(packed_output_13[4 +: 4]);
assign edge_data_13[16 +: 8] = 8'(packed_output_13[8 +: 4]);
assign edge_data_13[24 +: 8] = 8'(packed_output_13[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_13 (
.clk(clk), .rst(rst), .in_data(packed_input_13), .in_valid(valid_12 && ready_12), .in_ready(space_13),
.out_data(packed_output_13), .out_valid(edge_valid_13), .out_ready(edge_ready_13));
wire [31:0] edge_data_14; wire edge_valid_14, edge_ready_14, space_14;
wire [15:0] packed_input_14, packed_output_14;
assign packed_input_14[0 +: 4] = 4'(data_13[0 +: 8]);
assign packed_input_14[4 +: 4] = 4'(data_13[8 +: 8]);
assign packed_input_14[8 +: 4] = 4'(data_13[16 +: 8]);
assign packed_input_14[12 +: 4] = 4'(data_13[24 +: 8]);
assign edge_data_14[0 +: 8] = 8'(packed_output_14[0 +: 4]);
assign edge_data_14[8 +: 8] = 8'(packed_output_14[4 +: 4]);
assign edge_data_14[16 +: 8] = 8'(packed_output_14[8 +: 4]);
assign edge_data_14[24 +: 8] = 8'(packed_output_14[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_14 (
.clk(clk), .rst(rst), .in_data(packed_input_14), .in_valid(valid_13 && ready_13), .in_ready(space_14),
.out_data(packed_output_14), .out_valid(edge_valid_14), .out_ready(edge_ready_14));
wire [31:0] edge_data_15; wire edge_valid_15, edge_ready_15, space_15;
wire [15:0] packed_input_15, packed_output_15;
assign packed_input_15[0 +: 4] = 4'(data_2[0 +: 8]);
assign packed_input_15[4 +: 4] = 4'(data_2[8 +: 8]);
assign packed_input_15[8 +: 4] = 4'(data_2[16 +: 8]);
assign packed_input_15[12 +: 4] = 4'(data_2[24 +: 8]);
assign edge_data_15[0 +: 8] = 8'(packed_output_15[0 +: 4]);
assign edge_data_15[8 +: 8] = 8'(packed_output_15[4 +: 4]);
assign edge_data_15[16 +: 8] = 8'(packed_output_15[8 +: 4]);
assign edge_data_15[24 +: 8] = 8'(packed_output_15[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_15 (
.clk(clk), .rst(rst), .in_data(packed_input_15), .in_valid(valid_2 && ready_2), .in_ready(space_15),
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
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_16 (
.clk(clk), .rst(rst), .in_data(packed_input_16), .in_valid(valid_14 && ready_14), .in_ready(space_16),
.out_data(packed_output_16), .out_valid(edge_valid_16), .out_ready(edge_ready_16));
wire [31:0] edge_data_17; wire edge_valid_17, edge_ready_17, space_17;
wire [7:0] packed_input_17, packed_output_17;
assign packed_input_17[0 +: 4] = 4'(data_15[0 +: 8]);
assign packed_input_17[4 +: 4] = 4'(data_15[8 +: 8]);
assign edge_data_17[0 +: 8] = 8'(packed_output_17[0 +: 4]);
assign edge_data_17[8 +: 8] = 8'(packed_output_17[4 +: 4]);
assign edge_data_17[31:16] = '0;
stream_fifo #(.WIDTH(8), .DEPTH(8192)) fifo_17 (
.clk(clk), .rst(rst), .in_data(packed_input_17), .in_valid(valid_15 && ready_15), .in_ready(space_17),
.out_data(packed_output_17), .out_valid(edge_valid_17), .out_ready(edge_ready_17));
wire [31:0] edge_data_18; wire edge_valid_18, edge_ready_18, space_18;
wire [15:0] packed_input_18, packed_output_18;
assign packed_input_18[0 +: 4] = 4'(data_16[0 +: 8]);
assign packed_input_18[4 +: 4] = 4'(data_16[8 +: 8]);
assign packed_input_18[8 +: 4] = 4'(data_16[16 +: 8]);
assign packed_input_18[12 +: 4] = 4'(data_16[24 +: 8]);
assign edge_data_18[0 +: 8] = 8'(packed_output_18[0 +: 4]);
assign edge_data_18[8 +: 8] = 8'(packed_output_18[4 +: 4]);
assign edge_data_18[16 +: 8] = 8'(packed_output_18[8 +: 4]);
assign edge_data_18[24 +: 8] = 8'(packed_output_18[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_18 (
.clk(clk), .rst(rst), .in_data(packed_input_18), .in_valid(valid_16 && ready_16), .in_ready(space_18),
.out_data(packed_output_18), .out_valid(edge_valid_18), .out_ready(edge_ready_18));
wire [31:0] edge_data_19; wire edge_valid_19, edge_ready_19, space_19;
wire [15:0] packed_input_19, packed_output_19;
assign packed_input_19[0 +: 4] = 4'(data_17[0 +: 8]);
assign packed_input_19[4 +: 4] = 4'(data_17[8 +: 8]);
assign packed_input_19[8 +: 4] = 4'(data_17[16 +: 8]);
assign packed_input_19[12 +: 4] = 4'(data_17[24 +: 8]);
assign edge_data_19[0 +: 8] = 8'(packed_output_19[0 +: 4]);
assign edge_data_19[8 +: 8] = 8'(packed_output_19[4 +: 4]);
assign edge_data_19[16 +: 8] = 8'(packed_output_19[8 +: 4]);
assign edge_data_19[24 +: 8] = 8'(packed_output_19[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_19 (
.clk(clk), .rst(rst), .in_data(packed_input_19), .in_valid(valid_17 && ready_17), .in_ready(space_19),
.out_data(packed_output_19), .out_valid(edge_valid_19), .out_ready(edge_ready_19));
wire [31:0] edge_data_20; wire edge_valid_20, edge_ready_20, space_20;
wire [15:0] packed_input_20, packed_output_20;
assign packed_input_20[0 +: 4] = 4'(data_18[0 +: 8]);
assign packed_input_20[4 +: 4] = 4'(data_18[8 +: 8]);
assign packed_input_20[8 +: 4] = 4'(data_18[16 +: 8]);
assign packed_input_20[12 +: 4] = 4'(data_18[24 +: 8]);
assign edge_data_20[0 +: 8] = 8'(packed_output_20[0 +: 4]);
assign edge_data_20[8 +: 8] = 8'(packed_output_20[4 +: 4]);
assign edge_data_20[16 +: 8] = 8'(packed_output_20[8 +: 4]);
assign edge_data_20[24 +: 8] = 8'(packed_output_20[12 +: 4]);
stream_fifo #(.WIDTH(16), .DEPTH(1)) fifo_20 (
.clk(clk), .rst(rst), .in_data(packed_input_20), .in_valid(valid_18 && ready_18), .in_ready(space_20),
.out_data(packed_output_20), .out_valid(edge_valid_20), .out_ready(edge_ready_20));
wire [31:0] edge_data_21; wire edge_valid_21, edge_ready_21, space_21;
wire [7:0] packed_input_21, packed_output_21;
assign packed_input_21[0 +: 8] = 8'(data_19[0 +: 8]);
assign edge_data_21[0 +: 8] = 8'($signed(packed_output_21[0 +: 8]));
assign edge_data_21[31:8] = '0;
stream_fifo #(.WIDTH(8), .DEPTH(1)) fifo_21 (
.clk(clk), .rst(rst), .in_data(packed_input_21), .in_valid(valid_19 && ready_19), .in_ready(space_21),
.out_data(packed_output_21), .out_valid(edge_valid_21), .out_ready(edge_ready_21));
assign ready_0 = space_0;
assign ready_1 = space_1;
assign ready_2 = space_2 && space_15;
assign ready_3 = space_3;
assign ready_4 = space_4 && space_9;
assign ready_5 = space_5;
assign ready_6 = space_6;
assign ready_7 = space_7;
assign ready_8 = space_8;
assign ready_9 = space_10;
assign ready_10 = space_11;
assign ready_11 = space_12;
assign ready_12 = space_13;
assign ready_13 = space_14;
assign ready_14 = space_16;
assign ready_15 = space_17;
assign ready_16 = space_18;
assign ready_17 = space_19;
assign ready_18 = space_20;
assign ready_19 = space_21;
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
.in_data({edge_data_9}), .in_valid({edge_valid_9}), .in_ready({edge_ready_9}),
.out_data(data_10), .out_valid(valid_10), .out_ready(ready_10));
actor_11 node_11 (.clk(clk), .rst(rst),
.in_data({edge_data_11, edge_data_10}), .in_valid({edge_valid_11, edge_valid_10}), .in_ready({edge_ready_11, edge_ready_10}),
.out_data(data_11), .out_valid(valid_11), .out_ready(ready_11));
actor_12 node_12 (.clk(clk), .rst(rst),
.in_data({edge_data_12}), .in_valid({edge_valid_12}), .in_ready({edge_ready_12}),
.out_data(data_12), .out_valid(valid_12), .out_ready(ready_12));
actor_13 node_13 (.clk(clk), .rst(rst),
.in_data({edge_data_13}), .in_valid({edge_valid_13}), .in_ready({edge_ready_13}),
.out_data(data_13), .out_valid(valid_13), .out_ready(ready_13));
actor_14 node_14 (.clk(clk), .rst(rst),
.in_data({edge_data_14}), .in_valid({edge_valid_14}), .in_ready({edge_ready_14}),
.out_data(data_14), .out_valid(valid_14), .out_ready(ready_14));
actor_15 node_15 (.clk(clk), .rst(rst),
.in_data({edge_data_15}), .in_valid({edge_valid_15}), .in_ready({edge_ready_15}),
.out_data(data_15), .out_valid(valid_15), .out_ready(ready_15));
actor_16 node_16 (.clk(clk), .rst(rst),
.in_data({edge_data_17, edge_data_16}), .in_valid({edge_valid_17, edge_valid_16}), .in_ready({edge_ready_17, edge_ready_16}),
.out_data(data_16), .out_valid(valid_16), .out_ready(ready_16));
actor_17 node_17 (.clk(clk), .rst(rst),
.in_data({edge_data_18}), .in_valid({edge_valid_18}), .in_ready({edge_ready_18}),
.out_data(data_17), .out_valid(valid_17), .out_ready(ready_17));
actor_18 node_18 (.clk(clk), .rst(rst),
.in_data({edge_data_19}), .in_valid({edge_valid_19}), .in_ready({edge_ready_19}),
.out_data(data_18), .out_valid(valid_18), .out_ready(ready_18));
actor_19 node_19 (.clk(clk), .rst(rst),
.in_data({edge_data_20}), .in_valid({edge_valid_20}), .in_ready({edge_ready_20}),
.out_data(data_19), .out_valid(valid_19), .out_ready(ready_19));
actor_20 node_20 (.clk(clk), .rst(rst),
.in_data({edge_data_21}), .in_valid({edge_valid_21}), .in_ready({edge_ready_21}),
.out_data(data_20), .out_valid(valid_20), .out_ready(ready_20));
endmodule
module actor_1 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(256), .WIDTH(505), .INPUT_CHANNELS(3), .OUTPUT_CHANNELS(8), .POOL_H(2), .POOL_W(2), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(4), .INPUT_SIGNED(0), .INPUT_BITS(8), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .ACCUMULATOR_BITS(19), .INNER_BITS(16), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(2304'h4071f100472ca3001f02470081d33e00286cbe00001333002016c10025a7ff00d93f1a00ae9e46001a088f002ce2f300ed37d000b690d100585be8009884d8003ffc3b004ca913003607a200d3d2110046e02c004b7ed300942cc300dc5a44001b0d8100e800a5007f662d00ff5bc700cf53c90096ded3008fc6260050090d000c58b7007f7f7800f2bac50058a5bd0061c1cf0036c5d500ab4dce00442d0900770f710070511e0004f7a90040f0e700341a0a0054e803001cf74700c413ad007fbb5700d0c027003327ba00409f1f0036ae07007f15c2001a5fd200e6757f00f087ba004404fb00ba015700b0a80d0061a69d00decb0600eda6fb00a5fd8700a6ee1c00ebe6f40062397f005fd63a00070c13001d531600bdeaac001e26e6), .BIASES(256'hffff907affffffcffffff37800004e6effffb6c4ffff8a37fffff9bcfffff684), .MULTIPLIERS(256'ha00000027000000260000000f000000100000000a000000440000003a), .PRODUCT_MASK(16'h7777), .REQUANT_MASK(16'h1111), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("auto"), .PACKED_LINES(0)) actor (.*);
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
  parameter integer ACCUMULATOR_BITS = ACCUMULATOR_BYTES * 8,
  parameter integer INNER_BITS = MULTIPLIER_BYTES * 8 + 9 > 64 ? 64 : MULTIPLIER_BYTES * 8 + 9,
  parameter integer MULTIPLIER_SIGNED = 1, REQUANT_BITS = 64,
  parameter integer SHIFT = 0,
  parameter [63:0] OFFSET = 0, LOW = 0, HIGH = 255,
  parameter WEIGHT_MEMORY = "auto", LINE_MEMORY = "auto",
  parameter integer PACKED_LINES = 0,
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
  localparam integer ROM_WIDTH = OUTPUT_LANES * REDUCTION_LANES * WEIGHT_BITS,
  localparam integer ROM_DEPTH = BLOCKS * DOT_STEPS,
  localparam integer MULTIPLIER_GROUPS = (MULTIPLIER_BYTES + REDUCTION_LANES - 1) / REDUCTION_LANES,
  localparam integer COEFFICIENT_BITS = MULTIPLIER_GROUPS * REDUCTION_LANES * 8,
  localparam integer PADDED_ACCUMULATOR_BITS = ACCUMULATOR_BYTES * 8,
  parameter [ROM_WIDTH*ROM_DEPTH-1:0] WEIGHTS = 0,
  parameter [BLOCKS*OUTPUT_LANES*32-1:0] BIASES = 0,
  parameter [BLOCKS*OUTPUT_LANES*COEFFICIENT_BITS-1:0] MULTIPLIERS = 0,
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
  output reg [LANES*8-1:0] out_data, output wire out_valid, input wire out_ready
);
  localparam [2:0] IDLE = 0, DOT = 1, DOT_DRAIN = 2, RQ = 3, RQ_DRAIN = 4, POST = 5, POOL_WAIT = 6;
  reg [2:0] state;
  reg [BLOCK_BITS-1:0] block;
  reg [STEP_BITS-1:0] dot_step;
  reg [POOL_BITS-1:0] pool_item;
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
      (state == DOT && !dot_last && dot_step == STEP_BITS'(DOT_STEPS-2) && release_after_dot);
    if (rst) begin
      read_block <= 0;
      read_pool <= 0;
    end else if (state == DOT && dot_last) begin
      read_pool <= read_pool == POOL_BITS'(POOL_ITEMS-1) ? POOL_BITS'(0) : read_pool + 1'b1;
      if (read_pool == POOL_BITS'(POOL_ITEMS-1))
        read_block <= read_block == BLOCK_BITS'(BLOCKS-1) ? BLOCK_BITS'(0) : read_block + 1'b1;
    end
    if (starting_dot) begin
      dot_last <= DOT_STEPS == 1;
      release_after_dot <= read_block == BLOCK_BITS'(BLOCKS-1) && read_pool == POOL_BITS'(POOL_ITEMS-1);
    end else if (state == DOT) dot_last <= dot_step == STEP_BITS'(DOT_STEPS-2);
    if (state == DOT && !dot_last)
      prefetch_step <= prefetch_step == STEP_BITS'(DOT_STEPS-1) ? STEP_BITS'(0) : prefetch_step + 1'b1;
    else prefetch_step <= starting_dot ? STEP_BITS'(DOT_STEPS > 2 ? 2 : 0) : STEP_BITS'(0);
  end
  wire [STEP_BITS-1:0] read_step = prefetch_step;
  // Select the second startup word after coordinate decoding is registered.
  localparam integer SECOND_STEP = DOT_STEPS > 1 ? 1 : 0;
  wire [WINDOW_BITS-1:0] window_address, alternate_address;
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
    assign subword = parts[dot_step];
  end else if (GROUPS == 1 && REDUCTION_LANES == LANES) begin: full_channel_window
    assign window_address = WINDOW_BITS'(read_step);
    assign alternate_address = WINDOW_BITS'(SECOND_STEP);
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
    assign subword = parts[dot_step];
  end endgenerate
  wire [LANES*8-1:0] window_data;
  wire [LANES*INPUT_BITS-1:0] stored_input, stored_window;
  genvar storage_lane;
  generate for (storage_lane = 0; storage_lane < LANES; storage_lane = storage_lane + 1) begin: storage_width
    assign stored_input[storage_lane*INPUT_BITS +: INPUT_BITS] = in_data[storage_lane*8 +: INPUT_BITS];
    assign window_data[storage_lane*8 +: 8] = INPUT_SIGNED != 0 ?
      8'($signed(stored_window[storage_lane*INPUT_BITS +: INPUT_BITS])) :
      8'(stored_window[storage_lane*INPUT_BITS +: INPUT_BITS]);
  end endgenerate
  raster_window #(
    .HEIGHT(HEIGHT), .WIDTH(WIDTH), .CHANNELS(INPUT_CHANNELS),
    .KERNEL_H(WINDOW_H), .KERNEL_W(WINDOW_W), .STRIDE_H(STRIDE_H*POOL_H), .STRIDE_W(STRIDE_W*POOL_W),
    .DILATION_H(POOL_ITEMS == 1 ? DILATION_H : 1), .DILATION_W(POOL_ITEMS == 1 ? DILATION_W : 1), .PAD_H(PAD_H), .PAD_W(PAD_W),
    .LANES(LANES), .BITS(INPUT_BITS), .MEMORY_STYLE(LINE_MEMORY), .PACKED_LINES(PACKED_LINES), .PIPELINED_READ(1), .ALTERNATE_READ(1)
  ) window (
    .clk(clk), .rst(rst), .in_data(stored_input), .in_valid(in_valid), .in_ready(in_ready),
    .window_available(window_available), .release_window(release_window),
    .window_address(window_address), .alternate_address(alternate_address),
    .select_alternate(starting_dot && DOT_STEPS > 1), .window_data(stored_window)
  );

  (* rom_style = WEIGHT_MEMORY *) reg [ROM_WIDTH-1:0] weight_memory [0:ROM_DEPTH-1];
  reg [ROM_WIDTH-1:0] weight_word;
  integer address;
  initial for (address = 0; address < ROM_DEPTH; address = address + 1)
    weight_memory[address] = WEIGHTS[address*ROM_WIDTH +: ROM_WIDTH];
  always @(posedge clk) if (state == DOT) weight_word <= weight_memory[weight_address];

  reg [REDUCTION_LANES*8-1:0] input_word;
  reg operand_valid, operand_rq, operand_last;
  reg operand_first_group, operand_last_group, operand_last_byte;
  reg product_valid, product_rq, product_last;
  reg product_first_group, product_last_group, product_last_byte;
  wire dot_valid, dot_complete;
  generate if (REDUCTION_LANES > 1) begin: dot_pipeline
    reg valid, last;
    always @(posedge clk) begin
      if (rst) valid <= 0;
      else valid <= product_valid && !product_rq;
      last <= product_last;
    end
    assign dot_valid = valid;
    assign dot_complete = valid && last;
  end else begin: direct_dot
    assign dot_valid = product_valid && !product_rq;
    assign dot_complete = dot_valid && product_last;
  end endgenerate
  reg pool_update, pool_commit, pool_first, pool_last;
  reg pool_choose [0:OUTPUT_LANES-1];
  // The emitter proves this width covers the final result, or retains all
  // 32 bits. Modular addition permits the same narrowing at every MAC step.
  reg signed [ACCUMULATOR_BITS-1:0] accumulator [0:OUTPUT_LANES-1];
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

  genvar output_lane, reduction_lane;
  generate for (output_lane = 0; output_lane < OUTPUT_LANES; output_lane = output_lane + 1) begin: mac
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
    assign selected_maximum[output_lane] = pool_choose[output_lane] ?
      accumulator[output_lane] : pool_maximum[output_lane];
    assign group_sum[output_lane] = group_value;
    assign next_inner[output_lane] = group_sum[output_lane] +
      (product_first_group ? INNER_BITS'(0) : inner_sum[output_lane] << (8*REDUCTION_LANES));
    assign next_total[output_lane] = (total_sum[output_lane] << 8) + REQUANT_BITS'($signed(next_inner[output_lane]));
    assign shifted[output_lane] = 64'($signed(total_sum[output_lane])) >>> SHIFT;
    assign quantized[output_lane] = shifted[output_lane] < $signed(LOW) ? LOW[7:0] :
                                   shifted[output_lane] > $signed(HIGH) ? HIGH[7:0] : shifted[output_lane][7:0];
  end endgenerate

  reg [OUTPUT_ELEMENT_BITS-1:0] output_pixel [0:OUTPUT_CHANNELS-1];
  reg output_pending;
  reg [OUTPUT_BITS-1:0] output_word;
  wire output_finished = out_ready && output_word == OUTPUT_BITS'(OUTPUT_WORDS-1);
  wire [31:0] tile_channel = (GROUPS == 1 ? 32'(block) : 32'(block) % TILES) * OUTPUT_LANES;
  wire [31:0] group_channel = GROUPS == 1 ? 32'd0 : (32'(block) / TILES) * GROUP_OUTPUTS;
  assign out_valid = output_pending && !rst;
  assign starting_dot = (state == IDLE && window_available) ||
    (state == DOT_DRAIN && dot_complete && pool_item != POOL_BITS'(POOL_ITEMS-1)) ||
    (state == POST && (!output_pending || output_finished) && block != BLOCK_BITS'(BLOCKS-1));

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
      weight_address <= 0;
      operand_valid <= 0;
      product_valid <= 0;
      pool_update <= 0;
      pool_commit <= 0;
      output_pending <= 0;
      output_word <= 0;
    end else begin
      if (POOL_ITEMS > 1) begin
        pool_update <= dot_complete;
        pool_commit <= pool_update;
        if (dot_complete) begin
          pool_first <= pool_item == 0;
          pool_last <= pool_item == POOL_BITS'(POOL_ITEMS-1);
        end
        // Compare and select on separate edges. The next dot's operand stages
        // leave time to reset its accumulator before its first product arrives.
        if (pool_update) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
            pool_choose[channel] <= pool_first || accumulator[channel] > pool_maximum[channel];
        end
        if (pool_commit) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1) begin
            pool_maximum[channel] <= selected_maximum[channel];
            accumulator[channel] <= pool_last ? selected_maximum[channel] :
              ACCUMULATOR_BITS'(BIASES[(32'(block)*OUTPUT_LANES+channel)*32 +: 32]);
          end
        end
      end
      operand_valid <= state == DOT || state == RQ;
      operand_rq <= state == RQ;
      operand_last <= dot_step == STEP_BITS'(DOT_STEPS-1);
      operand_first_group <= multiplier_group == GROUP_BITS'(MULTIPLIER_GROUPS-1);
      operand_last_group <= multiplier_group == 0;
      operand_last_byte <= accumulator_byte == 0;
      product_valid <= operand_valid;
      product_rq <= operand_rq;
      product_last <= operand_last;
      product_first_group <= operand_first_group;
      product_last_group <= operand_last_group;
      product_last_byte <= operand_last_byte;
      if (state == DOT) begin
        input_word <= window_data[32'(subword)*REDUCTION_LANES*8 +: REDUCTION_LANES*8];
        weight_address <= weight_address + 1'b1;
      end

      if (output_pending && out_ready) begin
        if (output_finished) begin
          output_pending <= 0;
          output_word <= 0;
        end else output_word <= output_word + 1'b1;
      end

      if (dot_valid) begin
        for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
          accumulator[channel] <= completed_dot[channel];
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
        if (POOL_ITEMS == 1 || pool_item == POOL_BITS'(POOL_ITEMS-1)) begin
          accumulator_byte <= BYTE_BITS'(ACCUMULATOR_BYTES-1);
          multiplier_group <= GROUP_BITS'(MULTIPLIER_GROUPS-1);
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1) total_sum[channel] <= 0;
          state <= POOL_ITEMS > 1 ? POOL_WAIT : RQ;
        end else begin
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
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
            accumulator[channel] <= ACCUMULATOR_BITS'(BIASES[channel*32 +: 32]);
          state <= DOT;
        end
        DOT: if (dot_step == STEP_BITS'(DOT_STEPS-1)) state <= DOT_DRAIN;
             else dot_step <= dot_step + 1'b1;
        POOL_WAIT: state <= RQ;
        RQ: if (multiplier_group == 0) begin
          multiplier_group <= GROUP_BITS'(MULTIPLIER_GROUPS-1);
          if (accumulator_byte == 0) state <= RQ_DRAIN;
          else accumulator_byte <= accumulator_byte - 1'b1;
        end else multiplier_group <= multiplier_group - 1'b1;
        POST: if (!output_pending || output_finished) begin
          for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
            if (tile_channel+channel < GROUP_OUTPUTS)
              output_pixel[group_channel+tile_channel+channel] <= OUTPUT_ELEMENT_BITS'(quantized[channel]);
          if (block == BLOCK_BITS'(BLOCKS-1)) begin
            output_pending <= 1;
            output_word <= 0;
            state <= IDLE;
          end else begin
            block <= block + 1'b1;
            dot_step <= 0;
            pool_item <= 0;
            for (channel = 0; channel < OUTPUT_LANES; channel = channel + 1)
              accumulator[channel] <= ACCUMULATOR_BITS'(BIASES[((32'(block)+1)*OUTPUT_LANES+channel)*32 +: 32]);
            state <= DOT;
          end
        end
        default: ;
      endcase
    end
  end
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
  parameter integer PACKED_LINES = 0, PIPELINED_READ = 0, ALTERNATE_READ = 0,
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
    always @(posedge clk) begin
      requested_offset <= selected_offsets[window_address];
      requested_row <= selected_rows[window_address];
      active_address <= wrapped_address;
      active_row <= next_row;
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
      assign offset = selected ? alternate_offset : requested_offset;
      assign next_row = selected ? alternate_row : requested_row;
    end else begin: single
      assign offset = requested_offset;
      assign next_row = requested_row;
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
module actor_2 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(12), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(3), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(14), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(5184'h41ffc1dc1109182cb8d4b0c036be0cf473f1448df9cffd2bffd14fe00eb2d0bd3eb790856b3f0950e1f5d80d7d183fc0b95582efa1442c4016cb0b4ad82e7bc8c228b02bb8db53c567523721fb2538c14414fbf2c72e42e371055834ea61552e237305390d483c568e285cedef70ce0f6009eb3549088c2bd28ff40341be275005c48d0420387c283cf8fc77f3c4831220138214e608078143f73f9027bfb7fbffb420fe72e2e0f4b87c8503dfc80c7df8ff2cc1cec64efb13bdb1ae151ef3b2ffcd76d2f332140e740fa207bfa2022cbe3ff4937e1f5436f189cc0e3f35d41288d4117ec82dc2ffc236fb47f706f750e3170418bfb63061b704310200cf361070ca226ff4f0e04a1fdf84ef6cf7cfc1c73e71e95cb221ebe1b9e06c7c00c3cbe49108f717c006824204bc8c2fd20c4d214ceb6ec8c3e2d6466149eb90c8d81ec308df0602ef0414bdc2db62b13c018004be0a474f81fc617c394cbdfc18790050bbe8261fcff0bc484e4cdfb2fd1eac2824b006f3c03ae46f7bf6eebeffcd49e80c6ff74db8f80d6bdc91c1da1cfdf00078e9aff2cb3d050fefccdcf10bfe6ccdfbb03e431923f46bf3cfa097cf2f2c0c707ce03089db8274dbe184001276dae0b7108174fbfff5494c45d873011fa0fc1c6e3fe7e3f6f40105485869080efe143047011d3abaffb624ef381071902bde00b7ef7c2c6f83bfaa0f205fd6dc4f13f3d86eaffc70eb9ec70704ba13603b0c7fc80ffefececdb118b133008f4954ccc1fcb09f149d4e198f48ebde420bafc063efede48f91bbfaf8149e4e105179d4f073ce833ae82f3bbc5203cb9e022481ba0ca2760bed3507f0d01c92c000cd34fc2086cd1ecf7cc0f9e3d0ca1b823bfc5d09f00143cf55741f5e7c0c2fc137d4cdf3ef480c7f3d), .BIASES(384'hffffff83000000280000001fffffffe60000004000000014000000baffffffdc000001580000006300000068ffffff3f), .MULTIPLIERS(384'h1f300000227000003c2000003d300000229000002aa0000034f000002f1000001ed000001eb000003930000043c), .PRODUCT_MASK(12'hfff), .REQUANT_MASK(12'h333), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(0)) actor (.*);
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
  integer_block_pool #(.HEIGHT(128), .WIDTH(252), .CHANNELS(12), .KERNEL_H(2), .KERNEL_W(2), .LANES(4), .BITS(4), .SIGNED(0), .MEMORY_STYLE("auto")) actor (.in_data(stored_input), .out_data(stored_output), .*);
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
  integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(12), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(6), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(15), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(11664'hbd2dc0000a47c04000190139000b88337000293b8f000d823510000ce193000a40175000d32417000afbcaf000d4e1cb000108d45000e7ae3a0001c1107000f033b7000b3e43e0001f7b9c000cb70c8000ec04010009c6200000e05304000fa958b000f8904a000033ec30001071c00003f0f3e0003c8d40000c750ba000dfae3b000f73fff0000fc04b00000117d0000920ba00002b007000341179000226e40000ff7c9f000d2c949000fb31ff000b7d949000fc1151000ff584100023ef16000840c47000ef900f000e7f03a000de5858000c2a9130001bce880002ff34400030a33a000b3a087000e24d16000e27a3a0001cfdc8000b4ee810002161b8000f7b4fc0000e1f0f0001021cb000ef8d7900038527f00008aa48000e7ffc6000e71f3e000eb1f3a000ff2f0500030bfc500020a143000004ff1000f3e433000fbcf52000e41b05000c77f7b00003e37d000eb7373000348ffb000109205000c41fcd0009faeba00013b0bd000d502fa000e93f8400002dc1a00023ae460001d0cbb000102204000c341f700016bc7a000e120bd0001830d0000a65bfa000e49e41000e98188000ec5e430002053c6000080f7d0004badc300014bcc1000df4000000004c7d0001fc281000ec0f0c0002fdc07000dc8000000efd17e000143fbe0003ec0bb1321b81f3f3f10f3a40f9403d47fc5f78cafdfe139f00e47d5dd3917a1edcfb050eb7084ffde7ae7f9c22ad1300f63060f5febe0bf38ddfe05bb7ebaffcf72345b7349314f26a7f80eef85fb0e074042ea0c9cbdaff27e07c279f3a0ba984f7e1bd16d339dfcf3efb10fdc77ec707813a082e680eef00eae3411be1f6d30ff61c7e44ec4dfbfead460bb1c6079ff3efdf3df4b152d2e101007fc82463f5f351aadad282ffff32cce6491c2f92033ebdc3a2f83bc177179294b1533818132ebc5c408534980353f3a41f0427c0bb1c8f88111cb1f82085ea12d4f5417127a845f862c824330ecc900e647df1e0fb4af4510307ddcc397bc7e73d2b3fd0fee70ac2384fc3f71ff1d13fadd2cfbf1faf8728dff0240be32c908bbf220e24cb7d1400082a10c2f92d3e3c8d79448d85153efd03cb46273fddbbaf83fce204174f8904bef20f5f46e372d616c16a0f8013239ebcfbcfebf061fdfd0f04f0827d0c010927e108df23edfc91c2bb217d17d1f2e3eff4dfb0c6263da9db614930507d20fc50507fbd282ec3ff0288ffff86ed5e0d53dc3803fd8edbe178d8ff5c005eb3132f80fbefb90b9cd8182fc0daf0bfe8cff7e32fbff8ed3abfe00b0fd379443da6441f800b6145f81f4af81f84ec6facfcfb45446e3d3d007b03b2d4e42f120bd1820aeec9ff8d86d7f076dedfecb34c01040cc9f7fff3e08beed40db5035f86324f09e4948a2cb002fcf371cf4e70f08fc1f3f33f3bfdb8e6be831dc076f85dbeb2693dfb4f36f00ab9c7a089856f38009d04f393cb0af2c7e7f3093b7f74df82b5a7e07b0b70f528118d0fcd030b82b81083b9005216afc443185135103361d10bbedc2202d7ae45f72ab9329e49ffcf43001fb62cbeed04feb4efed341f7f8ef7507be7a1b4382dc6df616d1b622c086e25fc3f0cecb1caf75dacec2ef4da1ec05b733b13cf45cf5444d91642d861b233ae73d75eb31853c30b2f0137ff430044f0878845090f80002dc4c52148f87dbbf9628b8814c84820814d2deae79b3dd58235251fb32b3ebcebef73f793b2bc0e382952ff1c81b3dfafdfc47f7edf3e8811a8ae19b5bcffd20acca0ba3920422ff1c314ecc4e401761d2bc2131e02b4430ad7b0c60f7ecdf9a2381004e1676085d392371380281bfd87f831f324e1f51bbf3519024a601ad023c2870034ed0c4ff817b17b98ecb9dbf2741f003df4634503c2f11311482bdfc2d80ef2304037f3fdcae7f243c00c86dbcc7dec40770eb1baffd43b20a0f04370cbf0b33d52f54f2b8fca0bb07b0c6165d7b3ce04c13eff70ae409f3bd751efec41fffb617cf26cf803df7dd860fd18afba000fb3cf9078140e352c4137e7decae5c), .BIASES(576'h15500000106000000f9fffffeae0000009effffff6800000048000000daffffffb00000011700000080000001b700000089ffffffceffffffffffffffe5), .MULTIPLIERS(288'h16f01f702190332048902a103310200023d023102b701c1028603db030f026e), .PRODUCT_MASK(6'h3f), .REQUANT_MASK(6'h3f), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
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
  integer_block_pool #(.HEIGHT(64), .WIDTH(126), .CHANNELS(16), .KERNEL_H(2), .KERNEL_W(2), .LANES(4), .BITS(4), .SIGNED(0), .MEMORY_STYLE("auto")) actor (.in_data(stored_input), .out_data(stored_output), .*);
endmodule
module actor_6 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(3), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .ACCUMULATOR_BITS(17), .INNER_BITS(17), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(27648'h2cfffaf316d2fbfefaf9f611c2b0b7f1e1d85ed8e6e0131031a7e1fa4020be2021ecf4011b00bb04fecb080dfb0db71e30132cdf2f0911ebdee703fd3605ea1229d4f5ad10d80cd12cfc0bef0ff7d82121fee4fc11f4d4e8e91be003d526bf001e0c18fbfe100fbcc3e0c6177d59ee3d020f34f703eff10d23cb20c4fe16f7297ff5ecc224f01df2d40ef91527fcf314101de503d8f3fce6f7ffe11103e1061d28d9562e1af739ad3802e01436e504f90e101fe7157110ea1a0bef0bb4c9e1250e2f40e02e0cf5f6d9cadef4e8735101f21527267129efe5351104590af9f525ca4fe4f74449db141afb0816f3c2fa34e4f9131ef91d3df0f40d1833014a2c1a12face622efad2284720d63923ed241bfe0914f3ff29370fe936f11c41dbf80618c8dc211ad5dbffe7b705c91ccae101e70f16eb210000fd26210918ddd249ee0b35af2e0532ffc9eb1d1812e5f2212b3cbb1531cf0301cd0fc905f0ad2650e304f791334f4fb63a19241518f7c43ed2e434db2c131720e73d1119ebfecfdc2720e526dbf408f02e99c30722ec02e9bb1bfc817ff3ece44dcd1bea2afaf4341e0035eafafaebeec5edf81bd944c806cb94e4f618f312f0fb1f01170ad92603bc11092113a441111c024aed4eb1033ceb3635e1e441fbe51900d90cf203f02507f1c5ce4afcd8c300fff2f7df79d3e1ebd0f39bd1b6e4cfdf0ae3cf0d26e725f3181fefefe6070cb9250add290f28b9ebc41fc7ceece99917e3baf9f1dd94df3bbfec7fa0e6cbf7352fce250e7fdb2521c7f00c1b2d0c249f0808f5e127e8ccf400c8d8170e351815f70cc6dba4f8d2af54189b468133e0e6f603f925c5e5fcc10d03e10994d0eaf30d07d8fc0bed30fc14c987fd31f6a8f821d91d09dce2d1bf1e0fd6f6e5292430e9faceca10d91d0410fcd2eaf3170828051f302738f6f2e1e5d9cffffc2be204d60904d75c2206fde800e9d9e2ea3b212ae0eead2c175416e0171b1262160f1dd115d7fcfd41ded0f5d4ce36eb0ef0ffe9051b05f8cfbeb64a10e10fc60d33ddce08353ce20a35ea3e25f6e8405cc326fee9db3add15220015fab2ed3312ea0ce5c2eae52c19f0ef2c16df71a4d4692bcee5100a09142cf139370c02dc2d0b250414d92dea20e60fcffbe0f57c1f0aefd663fbf14f010d0fcd2eba1e00f403131cd408d8d03041180b1022e409232415fdf943cc2353f104d0810dc00bf2b7e9e510e5f1f5e4f03631fe4d1bd814ad1c30cafcc5fefe55f72403e52b1fce31f2a10846413ccacf09e7da120dd71f1ff2c5d02ed9ed3515201ece51fff925d540f8e3f4cd37e8ce00f90b231d2c4d02b81b1177f01618cd090af7f8e22d25b0e4c3dbd61908f62859d8f0dab11e0b1803c2c20e0d1cfcdd1c2dd8ea1213bafafc0be736f32508c213bd85fd0afb37f50100e8032527c5dedf5a041a141d2b080c0a31fff139235f30f7f4e5211f4f03d24e15ea2727b0bceebaf7fcc615d5e72ad9821421f52f532e5114eedce4ff121a005427c4fcf1082c0035f60fcc6142815b25e20a0cf728e101fbf3ea1bbdf3f9f9f3ee13b2ef1e59d2f1ca3b23ef27d1e0b425360fffd33bca4a2e0fddf224f74a001c3ef5290402e5b2f5d532ffaaef1207d2f9271200f21eb2f1e3ee1bf8022adcde27f030fbceff0e101cbdf72907f03c9bc7f12498f219c0e1bdfcc7e8c8ecf9110c1d397ff002e41b102704ede31b24ea25bef3e9aece430ae3cdf4d2931410a9e4f8dec7e9169001df15d0da92f9f2d6d506cee767f702bd0e27e3f5f106033105dce4d0d0d030ce202d13332c08d71a0321d1a416cbbc30bd2116e3fdffeb2a3a1256ec1adf0b2ce7027ffee3f73b11180be4cb11f70c1be8fbdbb9f3f0f42a24eedfe21e0902f4182fddcefc1d00f532f60bd124e7f80c002107f0fef60eff07fdbdfe00daf70222bfeed6e0fbeb0b10063315f92dd11034bb190b01f3edf8ffca81e9cb0be22223e31ad5f002d9de24e2d8143bfe031321cc0e2617061fb22df044d819c21f4d8af3161f3318ed05ffe33fdd01d7d44f21db2014feed08d8f02953a44b2a052d23d7ead9eb3e0be6f8f9d8ecef23d421c32ef82cdb27f50e3ae51917cef0c81b0f8e2c3df3ffdcccbbf429c3e2fae755079606fcf7cfffeffddb59ede65e010ebe1d2934cc021f141ca9bd10bcfefead3381e322e934ebe604fc2409cefcfa220893e6ea11af0c0e0cf770330ef2012befdf2bd702ed32eef0c1ff0a34220cfd60f9104324071702073935d64c0535dc0bd02d08fff83de4f9041ef8f003fb2db426f9c1efedb801212523081602081ceddafe2b242a25e4d5e21fcac81b2402188d47f217c00ff315ff0c2123233126dec8f616dcdef5ebf1d6dad912e21806ddfb9c1415192413a6fe09ecb804f4250b8d25d209f5f61c21065e60f928f0f501cee9e9e606f924e5e6fa2d27371c334b111416eced35ed0c232fb0fb18d9ffefb6e9b4eb09e8582020c6e41143edd3fe1fcf3629110b02eade2ef5df1fe7f818fff9dd30170e02faf1d78117fde7f3edeed6fd4140c21901514bf20ff281ead90dfc00e007c4ec0bddebb9dd27e5be090b9cd5ff1e2ce118ccaf6ef119f305e61da82badeffef626481a11241eec1721fe4707021312b0231cefe20e0213eb0b2f0ef0eeb53dd7d6c748aff1f80ef605c7bde012d31f59f408faeee167feecd2cd3c13ebf8370b0fec080308ebcfb95bdbe6b3f01d3ba0ea0afe8eea5dc706d91f240e6d00c5220e070e12ccb10c811d0f2e0c34ceca1b1a16ddfdfb3cf3eaf2f425e0ee240ce408d8ee5c165e9f1c0fa1cfc18ffe0d000e0eea1d0904c7031cc51cfce9e5e7e6fddb2204295217650af019e9d7e950ee393a63bbe4ed3be82f2025e3044ffe153202ca1300fa0efa45dc1410fe0a25cfe5f911bbef39e018309e15f206fe0ee4311eed18041827f63b2032d4fcf5b41533e4df1cb6d408a2f2ee13ca1e1ad409e71ed181dd1cbadff0cf2ce815081acd0772d73fec12c4d017d415f1df2c96d7f7d4d516c3fc27cc0c0618d626073a40404aafc5f848dfbbf7d4da18e8eaf30d3332ec2bfa00085ac3031917f1ba23ccd61a1e09e0b51e01edf8fef4301a00095802ebd7fdea1ac6d3e321d21fd101ecf717e34621ff301fdd30edde2e09fc3fb8c3eaeffec9ecd3daf822a00d37d900391149f3bff32bdaed0705a517f5fc02b52af2370f1529192523b4c2fced013ff6edfef610fdbef866e41819f1dc2eccf323da21fddcf821eb2cef1e2ddeeaee002c13271016d9eedbf57f5c6512f5fd13f7d3d01db402c74d18092200cf4ff5cd1835be0af6eeebe5c50fc1e90bf5951c3afb52c0e50ebb1a30e7d5511fdb302b40fa2facd813ed14040bee1900fa18c08196b52821cef42db951ddde0bcd9beec03270eff5191e1109e0f721b7813117e2f5d3dc02ddec12402acfeaf3dded96ee6233e3db1600d219b3462234f23bcdc411d9110bbeabd9c8341f090cefd91bfd0a5f08f5b0d4f5ee34e1ed29d5fcf8b9b4e8db01f8f00afad3e81b2bd0cbef060fe6f1e4c5c20fa510c7d810b0e603ecb515e7b844052904f6c24ce933d5db0020f7f53334d9e3ebf4fbfcf71e07ce4712edfab6e129dc2c00f6f716d9160ee0f4f9e42c811019d60007d7261fd0e0a9db403cecf62795f61a06fad7ce0be4fc07bcf5f3e922feb6a4de81c7f90f3a0edccfba189e400407e81223f53e1e179f1633b220f49c16f7fde33300032d16ebe721b8cc30eac5d7fbe19af3ecc62eb307d1051602192cc7dc12f6cfc902fbed223fb4fc3d87fc07d9baf58b162125fcebd9d7da4340f62e1a3aa70211d4c623e7330512d1331b1e4439a00c16e4050df13cee291ac29fb2f1370afbabfd080e7f1400251e311db8e3e660c5fedb28d7b2f1ac3cb009f42cc3e9101835f721e0f35affdf188e3aeae7191dc2bc0f50361ef4f5de240ad3eaf60d25f41df64708c80d0e0a061cd1eaf703d70b04e8fca55710bafd72fd0ef12c2628c825ee4fe0f619f0eb2604f0400516c6f1e632cd49b407ca759c42c112e73bcdfde20cf9c9fb07000bff2ea2a2000ebfe9d2eb0ae10ff9df474e1eed06073619fb24ea3d280ebae235b81dac364204c3cb2e1b02efdedcf339e50cce160e09ebfe08fb3806e24df6c4fe04d6e31c0af1ddce27341f0b06dd241a21da2143b9faf9091ded0d1ac61404fc1f1c1c24ef2132f7b1142b243223fa0cf5f232e9e32039d73cdc1c4ff8eb0916e2023e25f9130ac6231c1b09d8df221ccef51111112f1412d504fe67e0f84225e2dd2f2221074309110df6f8fd1cd2daf8d6ce2a360faebc1ef8fd1ffb1bcbc40b0809b1422b0d01fe1beaf6db00e4f6ce05c231109cfff9970dcac70417ed11b49bd43131f318ba13f597ac18af03042e3d1d131101e511241f1edfd43ac7f60115c93ae38116088f1fcb041107fd324eed052c1beefff40b2922ac27f0112800100e2626f7fedf36da1b4cf5043d5d0f08031806cdea4e2efd2ad7fbd92419fbf762dcd62017ea19efda7f6818280ab0c31108c7ceeb344204d706baf3d52fe5f49bf3d3b3ded6a82601f11b5948e503aa08f1fccf31a1c89ba9b89c04262f0217572df806ddf760f7e51ef1e0b70dfbfafe3c09ca0d42d657c4bc061f1bee2115b7e801d704e9120413d3c0fca31cddb5da2601041bb2bf1b017ffc072e46110d15d32152e4db30f34306c9b0080c243035e4d8e3ecec9fd2380e584bd7fec3aa28dbc8adfeccd708db0d28d107c91ae40ec2c33fff0b30134a25ee1a20e0f6f031cfbdf233f401d1eb60dd5c14c913ee20e42ecc11e3521de02925f3e3f747b51518271fddc92943eafaf704), .BIASES(768'hfffffc5bfffffcc3fffffd8fffffffe6ffffff7f0000058b0000040c0000012efffffc2d0000062bfffffd3d000000f1000001a0fffffba8000006bd000000e40000014c00000896000004c10000051ffffffe3a0000077f00000064fffffbbe), .MULTIPLIERS(192'h9f88c78198b58866b774fcdbac696790f2645aa0ab569bb4), .PRODUCT_MASK(3'h7), .REQUANT_MASK(3'h7), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_7 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(24), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(18), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(41472'ha6ffefec352af3441dd9022c7f133eeb25f024f5fb3713d2bef3d1be4d0dcee6e3ddf1d5ea2f1af4e0cbfc19fe130aec3511c61af1ee2a24f5e6b508f81fdef0f9fef3f1cbeca82af506e1c20e04db30e91322da78e63d34df09202a5b26fcf3c807befa0e3b04f7fad0dbd1e6f610e6e4151311ea3315f8040dcfd9badfc40d1bdde4100b35c4122e0f293a13f6e63c1bdfdfb0ee2e08e7f2f1eec51e092c2308effa56140aff07c3fd1d04f0ffeb1dffd8e708091b0b1e02f7c0eaeb063edd2a10cc0fa401eb17f4d1fb0c01fcea0a10231afef9d7fc18ffaaf001cb19b2c7dafe02d19837f0943c213aa30120ef1dd3b7af54fdf5aca9bb2d99e8bfe5dbd6d7171001de16caef0ecadc01cbdeb2ffe4f9e9abfa16e0b9efd3fc1e04e5e634d7c32206acf3d38904efff11e023fa93c14913e20c1db925fdcde7f503dfaf810af2dbf1d120d1d1f43ff0f6f8068afc1bebd728bcbc94afcff930c708edc78103faf93a281516eea21134f9dff5a6bccb1b28f7c99bf5af29fff930134fdff0cdca362cc015a7eaf21e2f1218e017903320fec2e129bd1b0bcbfba9b018a309fd310ddbe2b00ad97f152468ca35b8f71db759e6121059ff0ef6252460211d2dfde9ce0232eb07eb0edc01f9f3e429ded00ff007fb0f00c3690c09ece725f50d0c1022e1f2e002c50b41c41ee5e611c12e2def09cb05c62cf4e019f3341a23ecacff4ffc1bff0611fced48d9eee518d3f937f5bd2c0528e80b031aefe7d508e9393ecede2cece9d80a00110117f822e4e8f025dbe105dcaf4b0cea73f139fb050dffcae017174001ebf92b14eaeb08f717e8e31304e72312d814edefec0660f60cf010e3fa0210f2edff2523642931f6c6fb100e01de22fdf3ef3fcf0e1213f705062c7f26340cea29fc0c2de802f3ddf1033224f9a9d1d6add4ff2adf123613d5fc20f0db982c02f93f141c001af9fb27112bc413dc03fadae1fa2b18e161f8ea3616d5e508101d1f2141a4f80dd70afcd33c1ad92a0ce22016e84a12f7211415ff0e36382d1e1eeead6f26bcc001233650ff260639242d50c810f90e0333fb1401024ef10beaf81ff7eabd3af9193f03d9c9e81f2f2bdbc60f04d6e20ee21af02cfab2ddebecbe5881407c0504dff9e3002e0115f1d0f9e839eed20900cdeb36b6e346e81b11dbcbfd0a13e5dbddf31ed62dca4c48043d028bf8fb4304d1a91ece0df8051bdddf28082413d4eb3e1207090cc11efe7f0ffece05d9f6f0fbb7ea0ef5271b1def00f71d1df30e112fe13adc0e20dfe2fed2f31adf000e3015a20ee60b2f02f606fbf913f41fe20ec6cfd6d61423afcc01f4f3233604111c52dfd91713f6f216cebdc9fbd11de5ed15bb1d450701f8212dd141de50d1ef01dce0ba01de4901de0eda250d08e5f512dff9fffff0f3e41cd5ec03e9f4cfc2dc00fcdf0a09f83801feec47e9f40cec18f7c8ee15cfd1e8e331f8fd40fa1603f1f4d450db2be709e8f5fedee004f5c9c61a00fe2cfaf0efd5002d35bdc7d51812e3f006f3e77f28fd22fc1efd132f38fc3d0f2bf3c6f4d10c281ef7ebd027d91b2523d5d300e5eef21b3f0ae9e81c96f8fdeb3df6051ffd35b5f7afd9f604ffcdec2731f9f2cff125ec0beedee40213dc293b405c333103ed0ee61c13cf08e5fe1f110fc3fd432af4ec1cd2eefeede0efe8e6f50fe5eddbc502df15c90707c801d417cee9e00303b9261ec70dd0dd0903d5e8ece9e92508110228ee13df1c070913e7c91ebaebddddfa2afde91c410530de1535f920ea000ed215f01ee204c7d6042215f70f0cf428ac1ef92c10daf3f8edf631d409ee1bb90dd425f0144ffbe121d9fa172ae2eae7e20201b20818b1242228eddfff30ffe12c30bfd9d907060e312230f5ff11c2064fd405ef33d8e50c5020fcc6fd0a17d54d00fdf60d05e4e422dbd3ec2c06f9b0eed7ee7423f6ce34edef0aecf266002e45a3ce0bdd1fe6cb05e381431e36212603ebe4fc4141cc19051020f61a26f2d2d605f81442f809f92beff000e445f4e4edcb17f61f394cd2bee815d250ecb64df7c8b5f11d25163ceee1410c1fecd3bec7f5b3ac15fdf8f7eff7cd2a4e391a1f37301921415934e8cbf93bf257074ed9e1d511011dfcf6adcb01181106f2f12e2e51f6f6feb828cff3e919250de819124af6e1fdf1cff9d4402f65eac94a2ea949d552edf5d109f823d3d2fa1d0b40ba4fd1f900da3c5ceb3612daec6bdd27ee3becf00a0ed6d2291321282cb7a2abe115e2dab530ecdb0153f3c2e32a1ee3293144db5fdcfdeabbe1bce6fbbbaa411e3bdabee1164ba9d641d8ee6602faf2b2bd89b44746e312dbfccaf748c0d7ba5798971a3a288bb431a01bf63b6bb929decdd4d4ba5705e12eb60d126efeeb1d34d1e4dbe0aded2814440ff7be2618b7ede733f43054f3a97fd3efb447ee3f18f5cc160f2130cd3e1122da07faac33bc0ccd2706aa233b1909bbd3fe085e14f7f4bbf496f6c9f2f2ea113823b3e24f178501a4ee422a5daf2df0e1c5bee1ff010dc0331209f8190cd40e3c424ecd10ef07ecf36514f92f370e0636091f186463e7dacb01f2521a5eeecdeb3ff62436022c0722510afd06f6a3f5d0b23b057fe0cfe0c8f60436fbab0bed0cf1fdca35040bed1bf6fe25f85e0cddfef1f6973e5cc21d35d21d46fe0716d5eb0c30e7842f0cb4e447afc44bd7c126d919ecb25d18efe6f0e64a29f44beac090b90ba56486ca94db20f9d21db833fcced6dfa30cd424fc25e6f404290df50900cedee4fe39ffe6462115b41bf60612021b10d6341be42edff323fdaa360edc152dd920172dfce2741304ddb6f6b70bbe25bfe8d9fbf6af1737b9cbd1cad532f193fdc11900d0f130d7e20be111bec92af7e1ee150df114ecfd5fe814293311ccd8f6dbc7c3f612c80de55e1deafb2725263ad3df021a40e3fdcc0e0f811112dc25a6e620e7de4b0906f7d6241cd31bdef498ff19c11924e010c530e4f1c93bd2c468c9fef7fefbe94a9f1cb0c8e117d3030fbd44ebee0bd4017f0bf6002c3f2e2dc0133916dc19cfd1cbeffce8ef6d0714130301ec12f5d439de10368cf85be8baf0e2effd0720e0e90bf0bde7f202d7062cebbfd8ea1f39f6afe4abdc37dc0ebc9ff4c9d39e62ff14fd19fdfa4e4cc7aa004b572a035bc7563f3b15ed510acdfca6de12aa543de9ec22e76a18d6f5d4f33417120d71a5b64bd2113903330714ff0dd5fc13f80f9bcad2ef1ef8f50eb98106caeade06260a350b1209f00c0cf0e1943b12cb30072bb943a9bb0f01ee22d519fdf511f7f4d8c0a2e137fc2c022bfb3aeaf928cf0a2ce1001a0cf32ac8e4fcdbed031bf5f5f3cbfe20d713c5eb01fd163df31d2fe7f07ff1b53841dcfe0119de38f6f0e4520820f82d2128d24f31e8edf020dc011ac7e3c61bdecf142d1ce8d50ade2ee532312b0d1ef2f53f26c026ea19e913bfe2fdc4132222f7f9f4ffb901e0fa26e6edec4dec0827bbfa30d90aeaf914d3d42debd5f5c40a08f536e623bc140120103304c7d6c9c540dc3cfa21dfd70b05ee389a9aea55f400e6aa9cf51325440feefe8e0703d4fd0244b2c8fdcfc0c322f909c4fc06fedeafe8da8a2b2dd2cf2637cf55f0080cec4428d807e9f4ea3efcf2fad5ec2738121a0d0439e344c70148bbc6fff3e727e41a1eafeeefd644e022e60acef444154c01b8fa19fcd1f1d5ebcff1f3150508e6e5f98f15f6300e2301b009e9f7e4c5a006dfcd06fb2c5e00e3efed1d13e2d92c13cadfc4d6effd04e5e6d4e7d9f10ce8d5e4e9b305daff002cb6d3acecc63db7f12ad3ecd3ce0613e12800f1eed81d242881dcf904da33e622ce0e2fea39fd10d4f233d7deb11cf7f713cabf42ef11d2e2f3e7cc08f3f933e222f40f3bb228de47fdbbcc03e832c2f8fcf7d0c50adb5a0309c0b7f9e917b1f7a2bedecce634dd39b2b0a5ff10fa480d049da6cd07f40ab697013f35e9ccf60eecf538eadfbdd0d2ccdb1432fa3190ecd61c130a2dd3c6fcf9e51e0f0efd96cffef2f1401a24be351f3201050af61933f71b1c8630e6f8c7d2e5c11bfb0f3af1d4ee16cc02f3063cfdd7f80bfcfbdcf0bd21f85fc833211c0bdf420afeddf14e3107160ae900b4e407ee1a2bb204e92d3114ee19f7ecf7f7f1190dc3dd23eecbdff8d715dddb101ac62cf802254ff74bf71ec1aad5ec04cbc5e81934f3f6111521e1f6f826531012e813dccc1ef5bc0beb7f1402dd15281e0906f3170e0d15d2fc1d1e34fa2b22311464e1ee2eccffdcfdca0b0f12a325c9e410e0eeea1e35d2e70d08f021f4e2e8ffd2110acf11e00527f3c20ee12b5a16fadbf50122e60702102113f0ec24eeed3d040a22daff2f0911e320f83dd6f7f3d5e51917fadc0cccdcfa1125e911fd10fedde70244d8f6f50105182aebeafa2701ee2bc5fb112e09002b442f23ce39ebee150d1afde2ba203edf2081eedef34c16122e37fcf20ea42c2cdb1afadbf4c3cc07f9f9042e2ab82bf9f34c2bd52fa7f73df327b2e2cefa25ecd30be72c24183346f13a3f08f0a6dd02e312d44d2b2f11fc14d5dc38f0552f3205d50618319da58eabf0feabd5bed3c7ae141101c30e1ae4f30c08f23527c90481ba05dbe9fcedeffbfef8e8b20a17f62af81fca2108b1f4edafe5d40b04ded610effff6d7f3f7d3c117e11703edd3afefe8f8cbcb072509f41f1bf4d1e60bcf241e150012e525fddfeb0fc8b1e4f1f519f301e109ecf2bec503fdf8063704be332ceff0fd09eefa232c29d8e7d7d6b7e403f215fda309faade6ef00da03f84fcbdf1e20c2b13d483e33112011fd0701b63ce7fad9f42b1df7110803fde54205fbe70b3ee0482cc40444ef0d20ec13ef0dfc3fce02e5d506151a0fe44eedf005f6d2f3d409a622c8fd3f17e7f45dfcfb664be2ee3aea34eeeee52a2ce40007cbe80a095d293c56f0063d81ecfd0e4002e4db2b323fd20c119406077e361745d2aa17d81508fce9dbcdc8feef05a62bf403cfe8bdcd2003e2c81db51e1e291cacfeeb02431d261afdd9f8ed2df8f350d5c003c41bdf0a14e801fb011527e7d0eef8fbe74243323ef1edb2fb03f805ee0618eb13daf6e6e01646c1bdcfc3e7c5c3fad10117dbfdfb18330315ec3133f11f401105d6f400edfffcee24defde40c1afe28032e1334e1254129c21ef834e5c804b9c426130bf81a04e21e11ce8110f4e7cf0beef0f356e801ea19071044f83819093b101e01edd2c4122cd402e31ae51b42193c1d2de01303fe35021600120fe2f3e91f3db6fec9f508040edace4b160aeb41dbd1ace608de32eae6023c152027403c35fa1707ebfb162de80ee81eb0e5f00ddcfb1420fcfa3a440a09fae1d62e1632fdd81008d20e35040120ef14df0734e6081a134be1acab4b041702f605d3f0efc73c59e8e5fbffe610eadf1221f2e32bdcb51914fcf40e00e715ecc0f9fb2b13fd1e5be1f82337fab6df30df0be52fef20500935113106eff5f9e9b13707e8eb05e30d24fb0d1dede5b8da81f411eedaebf1d6f80e1b24f115c918d62fdef125b3c8ecc70b1c10fe05ff0a0cfc292efe0deb2cdd3508cefcdc0609c815e922fa38ff0bd7ef0ec6d90ef50827e7fae12adbd6f20cd3fc12e8e3d61027f6fa01f8ca15112ae230f11005eee636e6f31609ecc81b64e70307f2d5ec02ef39301eedfbf3260f2d0911f8f4df0ad1f0f9cef802cd1c17e6e1c906d7f6fb0fe7132afbe5d13d00ed33f405da07ebf4f810e5efe0f92c0a01e1e633d5de4335ed1eee03ffdafb041be41f100a1e33e10ee1ce0ad0d339345f27f3d4f7fad5132717ceb348d1283b051ab21ee5d03a43d04b26d55db73c25fed8239c640b120b17cef70cc121f34fee12a2c3f9b7091221bcf0fdf03f0792ce33dbf9c9df11f2d52b1bda271a49261e18d8d23a0943240ef227fce5fc2f0ff27f1ee50ad51f15060718b53b240befe7b7e8dcbbdd212c0f4f0cce13cf230252f058dfcb18e2d8d2e52f2defea2400f40537f020f2000332c0e2fa2d182a1f0b042cf7f0e52f0fdd01129d45d202284d00b6f00de3e5163d0ad9d1db87e917eb1ebf8cf320f0c4150ee41dd4e7d120e1f2d320b8fb0e1d1117052513ce0cb939e84abffd38eff02bdc1b0c13fa0cf83ffd11e4f2fe38e72ff408be26120ae0f90d171cff23c5d8fce62ae601fcff14f5fae2bd12f9e0c63b231d00de05f033b2401cf7f2ff12da1b04e2fbe1070d16f217ecfadd81f7032128cee0fa08f2eaff2a2fef11e114ece5b30f2de506e814f6edded6e50a950cea1fce04e2e612f5e10d14ea0519ee33ece9d707fb0752eb100cc30be0220bfe04fefeed1bc81920c40ec9f8cebe05fb070dd9c902e4f3dbe4cfcf19cf17b8f6000323fbef0f9cf1de22e2aeffd5cec3dcf4190defc3e8df2201d6dfe90def28fd2403110c8105e6d4ec10153fd4e2ece810fdf32b27f11301eeef1e14000418fd2dddea45cd00f204010bd231fef104ef1ad0d4310d31e023e62cfd15cc32f3152310d9111f4001021ed01e46d0dc22bd1f0c1a00cb28f1e43d04e1f421092eeffdffea17aa201dcdf7f0fe01ca3b04bd2929ed3b2d1df52726f108360f37f8210de817fc950cd0c7f91db50e1b030de20d09ea3ee0035b0019ed1b0ed22ae4e13130cd0b1fec29e509d7eb16cb0c43ea050f2ad307f0ddc1ff1eab1305f10fde160cf8fa151e2ed6e622db2b01dc1314efee1ce5ed27d24d0105f4f4fddbcbf41126291f20f9f2f1e8e907fd0e32cefbe9f4ea1927dbb3061c71e5dfed2bf50c01d1102281fdd5faf119fc0aa7b503fcf91c2d19e5e2400b01efefe05afbcf1c36505a59eb22192138d8fbd03abc251232d0cdde18efb60c3304e21811ee1af4f60f1ced1a0a2ce0341710fea0a0e5a8ce9dd0cbbaf0d0ed0bf00b0204b10106f6bee3d20c18ea0dde1c2612fafe0ff3dbf902e2ff0c3dc316fffcf2ddedf9ee0713a8dd3338ebfe302013d4eff81b15fe34f0fdb7f237cc37efc6cefd24fc43e5d9f3d90bdf12f7dc00ea15fdbd00d011b7d4f30912fee91117f0c900d8ff260414f6f4b70824fcf011edded331d916fdf010f31511ac1c11d0e5f5bff5fbfdea22fde3d9faf92710dc15bdd2f1190ffbfaecf423bb11f9f11bc304062e04090e16e1e8fefcdefbf5fae9e5d3fa1f16d9eec2fcd910db422912f915e219beff1fcbe9d9df12f0fa00d817dc0ddd1ceeebe423aaf2ea372defdecc012adb1eedf97fd91a1903e809e50b201ffb24f3ec13effc1dfbe9f50cf7ddeec11f0ef7031e0d070e0616f2ec110af3fa041e1d08e8f1e2dbf5f7f7aff3), .BIASES(768'h10b00000913fffffcf1fffffc850000003900000171ffffff4900000115ffffffe8000003020000014d0000006c00000938000000eefffffe1100000603fffffe97fffffd690000029d00000006000004fafffffed6000001ae00000417), .MULTIPLIERS(768'hbe0000003c000000c80000009700000083000000d60000007b000000830000007b000000800000007700000092000000840000009d0000009f0000007e000000a8000000b4000000fe0000006a000000c700000085000000c700000103), .PRODUCT_MASK(4'hf), .REQUANT_MASK(4'h3), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_8 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(32), .WIDTH(63), .INPUT_CHANNELS(24), .OUTPUT_CHANNELS(24), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(2), .DILATION_W(2), .PAD_H(2), .PAD_W(2), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(1), .ACCUMULATOR_BITS(18), .INNER_BITS(17), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(41472'hd81df03724011af6d22e0ff015fe2cebf817f90803d4f2f9d92ac93ae0e9ff0eff1004030d13ab36daecb71914d6d3df1d28f70bf01bd5cad8d51781fde21d24f9b0e22419c72dfaf513011203ee0bd8f0ee0f193afa27021d24f2e508dce7f106f9f7063d3a57f6dcd94a50382213216deb0ad605044502ee3f20ca2835e504de1a360439f82dfcfbd9c4100de644011c0fe313fff5d4fe034d090347e0b03e06fa11dda8c718fa1e2e28d7fbebda050f45ead723dcde37d8e3e9111cf307e62a27f4f642fca301ce27171961df254f2000d41635d931152d26d81305f8eef8031124ebef05caf32903c410e92703e21ff3d5dd2e2711fa0bfd021618bcf40581ddd51f1109e43fdefdd7f5f2bbe5fffb03e60df5d8c825eeef0ecff9f621643927fb090119cfe42a39d91e051402e5e63b1bfe05eab7e1f519d502289df5e5f3f115fef202f9e023f9eb242ee5f9f2e22a13131f0edffa0ee32f1229c6f1f90fd617f51c240dc2e202e6082bd3d6bbe1f2bf0dcee8e008201ceaf502e30d3ffef8cf0c03fcf8cc4a062613d610eee1f6de34e4ec1ba1852128feeef939f309c12d24b00b2d060ce5e0b6f2cf26e107001b30d217f61417eeed18f3f2f0f9005b183102e135f7f205e3fd0add1007290cff7f1adfa7fafd4cc1f5f0050732fa2624f60edd100db22cdf42d41bdae6d0ce20cfed10ecd70fe7ec04f9d1e5ebfcdfd6f0faed040a05f51e2d1bf62fe8102dfaf7fbebf5cac7212d2e09efed15ff28f60432360e1ee81fcc3411da33cec4fc18f5efcaee21dbd304c3f4e7f20107efde0cb30cea2f40e2d303131312e8e9eed8480100f0f8f0e6fbf600f8fd2f51e95e181ad5f602e0e2eef8020fd5d5fc1501ec00235305fefcf82c18d7ee0cdbd93bc6f70cde25d1e1f3b21ccfdce2d6ffddd88fead51b040810e0e4da0cf8cd0b10ed081d18ecc5e8ea0ec10f40200a30191af3f6e814f4f1e6e0053a2d0528e3fbe7cafaf90feed4f6f334e2094b06fb0f9f3cc5c0df0803eea01b2404fc1206332b28070bfccc041bc82121fcf62fc80c0d3905f42244eb0926182c1b093141fbeb041af017d40bf90aceec002ff1d00bf73f1ae8281fc903daffb4f7d6e7d5e7fbe9d1dbfdb681de09eaf50f3e04d1fee8efe724da24d649c341e30525f6bf1b0c15121bdf09fee006d6ec1c22ffd6d3f0c8dfe0f801e60b2303fe03290e9f0c07061dc649052cdb4ae0e320f710463d0be19be3210616d508e51ee00dfee4ddeef518fb08e04beac6f30c2304c703085bd4f7970efa37e9f6cf70150f022ee3cc1912fbdd3291d8d1fb2f187f2bc6072a2fda0e1edbf209e2ddcdfac55409f9c43fb45f1438fe222046f8fa5412c20f4efad33916ef011049a105fcd24542440ff0d6efddb32bf42529f9dd0317aabd93030d002701081c181e16de10e70d1121e9b7379d1d2ecbe7ecd1f83d0bd2e81d38e6430809d8c306c1c80032d60d061df934efed3b01d5174b0715feeb1f23d00913afee30bab02f0bed16fcddcdd93cd297ff5dc7a2c7a50eff054a1b56f806ebcb1c4a341e1dbf04dc2f3a00cf170c1b0807a109c4a01b05f9c702f4e52603379d1eca2418c515edfa42fe09471ae5cb186d53fbf62c611a12080bfee2eae9fa3b054cd4f1d91f4b3dac1a19c039e88108c518ee0d3604dcd9d2184f2df80f4212ed315cab0c1f21343312fe24f850392b18edb0dbf41d34423fd9b78bca4fc3b6dd481e221898f929f7f93fc4fff4e913cacef107acdd65e8fc339b49fbf5e118f44a5c03e330bddabe2130c3611d48f006abec009c1732fd62a5bafc13114147004211f0df2e142c451321d0221c8fedf8042de50cebfbfc15110ef9d99a41fbebd9eea049c9d9c4fe230cac3332e842fe903049130fb6282708e4b36eefe9e431f2d418e11fd5e52b1c41d1bb12b7078120feb9335022e5da1853280ed724cd550cc321dd1fd2d6ddfbcd54f242dc4dc7280427ecf714ecbab2482a111f9edde0559a3ee5f4f6e72c13132519c3cff101581617db17e433d71a25a3e2f1fa4220b9f5261fe0181d9e12eadeaff8e940130afcc5bc0b1bc9d8ecbf1c0d294a453b3360de33e7f13e1e24db42e7e7d4340539a518c1badb87c7f25b5305c30fc9083481f9132b252314dff9d2d9fed11113edf865f3f6fda99ffbb13e04011a0af047dc160c5729147ff4032bdf0ef6fb311c81bd3dfef8361df101ee96f49ac3febd21f93924f11718f2d4f5ba32c5b6e6221a15e513f5f9424635c3fe4f24e2c7c02906b32114235029f0c2ce17220222fff3990d0ad315fa14f6dac729325ff36533281fe4c29d154c4b7fbfd0220efffbfc4e3304fa4121540416b84bf4d5a50e45c1fcd4f6fdcabae105adc41a0623c833d4cb24f1fb62d206e29366e21af442c3dbee0df6e0cc7022e505e4d943d33411f1db3b13cd8f120f2e9cd8f4344af30627f73cc8ea24220cd32ff8b8ea4106d8ecef0933e8fdada9f0eef93b19f3e031f42e161b2320014236c61509f7d641484241e70ecf2e14fe0a4436051358bf25350a3a32d757460717fbd81b2deb8bf810d7dcbb20f04202c1dbc05bf1f31917440356e042f22ed0c4040b614bd1024233145b0f3af0e11f59d9243cedc9ff3fe5b0cae0dbd210a01cf4dce5d6dfc8cb051f0417255e3ee9e2b84026e22c34e9eac14ff21c0f3ae21dfb3631f043e5e69ed1282a32b5ccfd4329ce12a61dd37fbb1832fa35f9ece509d9f90cda46f730eddd28e3bb1afcc70d05344ff6451eb5bd4b05f1f43805fd14f123089327b981e71211ee174bfbf3cc0596d6ac1af1a89d13a7f798f8c4381937b29ffaf51f3e9b1a38261616fef4c3183a44de2cd20f41f82ac927b405f3d9ebe50f22e8c1e71ee38a10f0d352a5d946f44a26ebf4191dbd3ddf18029220252106e51119ae241dc736c0b5e11c1655b7f725e238971932fb3300e016e1e3c3ee132d05541bb626a56402f9bbd21ff80dddbf1ce620d1b234f5d5bfe23bbe1220d42310d5d3c4030ac6c12ffccf5d0b0cd9ea0f00e3f2d0fdeaf602fee3efffd23bf3e7cb23cf00f0d0d603451112ea0533c60ac6e9f00207fe252bfc59e916200fd8193b551e19f51dce0cc01e0403eed1282821f2c2f30e2efc22e1e8f8d4f114d8dfec0ee5cb0325e1e9e509d9d6d6ddffe7e9f2d4e8581a03f50c0c22e621140dd4fc0ee4d8f0001905c3dbefec0dbb0ff113fbec043cd20acf31e5e3c0effc0af00118261c18e5520e8107000c2305f5e6fb13e0e40e29fb17eb0f002b3800ff1bfbf506ce27f801bfd8ebf4edee0a2e07191b271eb4112e112dfe2bd5f0dce2d7ac333bcf07d814e58134efdce20de434dbc405e942efe5f2ecf917261207f6cf261aecf8b90bc118f615db3e21fe152c1b0a0de9f0dafbd722e7210002e1e513b9310ed81b051f521e00b4f91ac50f3020e3e514d6b31110c6fe031c232ccbe831eb2c21d5bac8b70020d6e00f0942f719e0e1e7f00d30db1b1cff0deae9dcd500121dfffca205e6f71cedf404f6d8f2e1d8dc0d09c7d327dfd8ddfe1d1938e544c7151f041034e0bb13f8e926c2f5e607f310060c15fafd0cf71b0df0da09f0d2f812941a1f0029e1ecfd144bc11530f8de05ce432abd00ed47a0e5a941f3270404e7def4db9bc042c7ae5c1cd804a7220efbfed738f1b700060ec0cd08cd94e61cb015f916022028e2c7fbe151d43417dee9411536efd8dee2b40ff4e824ba1adb1bff1005ebef0c6358c814327f00f6e9091c2a5f13e43c24160ef909e9eb0dc9410d0befea2a0919d2f41e31004ae4e3dcedfc11072f02191604f5f915fafd0d32d4e6fbf6fafac023d0cfe318f50a3e67e8eced16a832f8c635f51af8d1ed0702f304eafedc784be8dfff4a0af6d71bfeeededfe5ccda35010de002f9da39240420ead7cac6c428e60dbce5e61312e41741f11d06f6fdc32b28e7d5f3e4f331ed4ce102572ef5e7a50ca2e305a440f5f0e2b48620120e52fcab27d3e667f624a1d0280c2b4b2fae1d2e60b13216f91d10ce12e8c7f3ef05fb3f110b340800cb2a1f212223db16fa20cb252f0af3f1fe10ef15da31ff383f22d2f8f7110149eaf3ea2b69fed11430e6f508feb3fce3f0cd5dc232fc390e8103afc6e2df20f6fb1e1df73933dd9fcd38535edef2bdf62a19f947cd25fede1b2822e03217ea0732feffb0cf1fe6d72c202950e4ceb5f0d3d517feea1d02e1ce4d31c5223d32030666dffdccfebd0ce7d12135dc402fa8f834cbfa1c086beec90fff0e1e0603e1d6e4215fe1f5ebd7ce1df00654255ae2dc75f4ebbf1312c6ec0a1c5ed2e6e5f3eceaccf713fc7fd0f36dfdbce31430ca0fe3e528211f3dccef0d0d2826096405b51706fd19d8e5d7c9ba1a6411f318f42efcdf0c22100a041a241abfd5ff28dc22cdf35006f0013008dcc7f11bc246d8fddcf3a9c81711d22ce32f26122a46c4eeea0c1dd4142d0c8735d6ca5bd9e1ab228f2f0629eb1dd1ec21c605e90007f9ea3af5f9fd3602a31dd6241f1be20408af0ed2350bfa4be9292413d1431f1ad92cb4e9f212b5ecefe40f43df1af9ece9e805fde3d819da3235ce46f30fef0f08e9d90af3edfcf5d4d3e524f4f9f209ecffb2e0f0eb0a0f1f2c10d81920fbe4cd0ef82105fbd82bfa20090903ecfb081609ddf5f12222181cc8e927f5e1f5d420130bedffebe90aee25f106ff2df5f9f71316ef0fdbe9eae9ff1dcefcfe0b2003fac11b071cf3fff00b19f3290600cd08d324f1fad126f5ebd306efe2ace411ece815fd1bec38f80fe05bd915d3f9fff7d202f3192be7e73405e8d5fe26253b1081dcfd0d22e223fdcf2cfb082ce9e905e90dcf00e02af10cf23bf567f213fffe323caf0b294a51e6af38baf9ff1c09a8c302cb559d08f71cf81a221c434a430e351feec0effdf8f1034b1b74b0b8cca8da06c60f1ae354ce1c7f0b9a0507f18106c2fb311c2725dd0b0af7fc09f67fbcc239cc4b29a6d9cd03a4fa0e120e07c708f0aa063719773322550ed9ebb331e025db361501062814ed04fcf8f7e870badb18dcb1edf243d7edf2e959e22f5a910b1ef16ad610631a9743aa2b2dd8c3ce02a821080c251fbfb302b243d3ff3e04a23ccbcb11f2deabcad7350932011cd2b8d6b9511afb4e304814f4f61e2eeacffbc4df1b144a1705bfee36eccecb13ebf809cd30fefa31e13d2c33e042270ef792dd392cea172af5b8e40f12e6cff7b91d1db9e7f716e020c327f7240fe11d0b87d90514d5a9c6d524efe2d34638beccd90ff8b3f2e49afacad8f41809c915ca3022e2df49f4cc2c9e65ffc93c0bd4d7b20ebf06dfd43c2549f4c7d7e7dbdef90a0331ade4f91af881e8c9ebecdfeccb29e917c52228afd5e01611d1e7e4d22f09dddc3e24fd34db17ef14d11934b9e4df2e0cceefe20df3c2d330e3c0fb040ef90bd2d80131fadeba1a31eebfc60f0600f4f60cfbddecee3ff7ecf700ced2b0eab2d3c0fbd119f7ecfd201d15f603f0091e3630f5cd1e1cd563f714df2343d30fd42313ff0c3d112cfd2312f106036918ae250ae7ed48ed3a1c043cdfe4512ecc81c5c42ad8d58d35e40ffeedc0fb1ec8b1e81316f8e9ad1a4c38f64fc6d3f0f4b2202f53d2eab923c8670eedfd47faff123f30ad56e1b6f48b093271c707fffa8410aac71e2a03dcebb6e70ce7032a1d1490b648d921b7e0111ad6082ce4e5ae40c1c6133003121a0221246467b284161eded3cf45f2e7d00dd846631be99cd30461242047be3ee0f10f21c012fcca4b542517d941eada0f8115f808bcfaa4ef1dda3eec1f349413f1ce01e7f4e1ccc3d22103f7c61cc1891bdc17c0e7efd0dff9b0eae93bdae0200725ac01f83e05cef8fd051a17c1b40f1ab116cf3e44db0ffb1afe01b7ea90c4f6196fe6abe18dd104f8bf2fe8d8d7183f04031f4fc801e7f0ee26f2b31fbf2021e3e711fa18db22c81fb924e31b03fef0045312d0fed3f81aebe11aebd8c8bbceea0503d1fbdd9d08321121cb33b1e9c8c8b64aec0014da5ee6e53604e5f89fd90027179eecd8150e13014cf1f3ecd807e2ca180834d7e5c60df851fd2d1301fd6afa46e8bdeced3dffbefd2ede1f04f735ca2b3e394f00f413252dd70bd0ca0631ef0abfe3c4a428e6d9dffbf49edcb323f19ad9d45b1eb8e017fbc04bcbd9f5c80ebcca4ddf0c5cdfc0391add14a43b0400c626c7d2c7aef908370ff017cab617ae1cace122a237e3def35504ac06ce92d2d3fbfe813fedd4d0a2baea0c99d7342ae4e522ebaedae0c4e0ba4ce332bc610b3b0d26241c431cf6163132cccb29d6d62309f41ae4f319cdf0f13aeb0151fb0324fcf0e897d6c1e9fdd1dabcfa29efe9cce3460fb5cf46e8d2ec47dbb629e33318aff4f94bc0f3bfcffe00dfd310ddc70df1c6b9fee604dc0a0af52016be1ce9241cc15a0428d70046fad2eff7e2e0ecf1ff0829e2c4e6012e1213e505f5ac46be00bff2ea02e4ef04f202f61547f00feff4de08080003274247171deaf7c70b2810530a52f00b0610160fda81b8f4cd9fc61bee2bc7c6e7cc18cbf601113508f4e402eb10b4d22d206d1ae61958205413e53b19de0ffb02eafb00f7c746d62e23eded162dd0f4e1d8f0e0c321c209f403082b2af509fd1108221e000be0fcef011133f701f6f11921e7f3f10610d4ff153a0afe09e40aeaf408eafaa410fedafc16d2d8f314bbf439f61eff0e34e81e060cecc10fd334e8e4193f5d439ef434b235fd0122d8212baf10f61306d7ede716dd24b6cfac320af606080d0019dcf90cf0ff105c34f0fcf1d71ed6c51f55e3dc0323a09928ee1bce274608275ae4e9d3c210703d15ed39181cfc81f6f9a80210e1d8d52dd9daf4203ece00e0c300c43e170357d555f00dfe0ff7b81d1e45170ffc153fd7153c2719f5b822e2c740a8fa0c1defe2f9d114010e3ddd11f50a0bfc122a151ce40c01eb1b2a3ded1204d5c895f1e2385c34fdd447ebefe12bff230306acfc0e2acbdde6f853f340e62524b20efc189b04365235e4b9b8d7c3e4d8ba0324d9ff4b1546f87fb4f9f7b5330df2f529dcf30a3be346ebcbf203100b12f529d6fe48efd92147376bd635e2dfd1c81bc6cab72409df09fade18ab0c1a1fdb0ce1dddbd928fd1fee9f1035fdb526722502fec71319d535c5160106db209e272e90260104e4f103b8e5b62faf33ee4f0b3f1f0d40bf37d2b73dfbfb06e920f9f51bf4f50a2f2d2510d6510ff850f3bf8e11c5d0bc14dd30b9d2f6f80f0c08f22901d90af1f50411d4dc0ed84dcf220928d8287aeac9ba1d08ffdafa04), .BIASES(768'hfffffc1600000233ffffffff0000027efffffeebfffffe14fffffe500000010bfffffb44000002c400000161000001f70000009dfffffe29fffffd9600000150fffffe750000083d0000000c0000089f0000075a000001bafffffefa000001e4), .MULTIPLIERS(768'h93000000c9000000ad000000ca000000ab0000007b000000d500000075000000a500000088000000cf000000d30000008b000000a300000068000000f4000000580000007f0000009b0000006b00000076000000e8000000d2000000af), .PRODUCT_MASK(4'hf), .REQUANT_MASK(4'h1), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_9 (
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
  integer_nearest #(.HEIGHT(32), .WIDTH(63), .CHANNELS(24), .OUTPUT_HEIGHT(64), .OUTPUT_WIDTH(126), .LANES(4), .BITS(4), .ROW_BUFFERS(2), .MEMORY_STYLE("auto"), .ROW_INDICES(320'hfffdeef79cdef5ace718bded6ad6949ce528c6107bdce6b58c5ad4a4a50839cc62948418c4208400), .COLUMN_INDICES(756'hfbef7df3cefbebae79e38df7db6d75d34cf3cb2c71c30befbaeb6db2caebaaaa69a289e79a69659248e38a28618207df79e75d71c6db69a6596185d75965555144d34924514103cf38e34d30c2cb28a2492081c71861451040c3082041000)) actor (.in_data(stored_input), .out_data(stored_output), .*);
endmodule
module integer_nearest #(
  parameter integer HEIGHT = 1, WIDTH = 1, CHANNELS = 1,
  parameter integer OUTPUT_HEIGHT = 1, OUTPUT_WIDTH = 1,
  parameter integer LANES = 1, BITS = 8, ROW_BUFFERS = 1,
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
  function automatic [HEIGHT-1:0] used_rows();
    integer row;
    begin
      used_rows = 0;
      for (row = 0; row < OUTPUT_HEIGHT; row = row + 1)
        used_rows[ROW_INDICES[row*ROW_BITS +: ROW_BITS]] = 1'b1;
    end
  endfunction
  generate if (ROW_BUFFERS == 1) begin: single
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
  end else begin: buffered
    localparam integer BANK_BITS = $clog2(ROW_BUFFERS);
    localparam integer MEMORY_WORDS = ROW_BUFFERS * ROW_WORDS;
    localparam integer MEMORY_ADDRESS_BITS = $clog2(MEMORY_WORDS);
    localparam [HEIGHT-1:0] USED_ROWS = used_rows();
    reg [ROW_BUFFERS-1:0] full;
    reg [BANK_BITS-1:0] write_bank, read_bank;
    reg [ROW_BITS-1:0] input_row;
    reg [OUTPUT_ROW_BITS-1:0] output_row;
    reg [OUTPUT_COLUMN_BITS-1:0] output_column;
    reg [ADDRESS_BITS-1:0] write_word;
    reg [CHANNEL_BITS-1:0] write_channel, read_channel;
    reg output_pending;
    wire [ROW_BITS-1:0] selected_row = ROW_INDICES[32'(output_row)*ROW_BITS +: ROW_BITS];
    wire [ROW_BITS-1:0] next_row = ROW_INDICES[(32'(output_row)+1)*ROW_BITS +: ROW_BITS];
    wire [COLUMN_BITS-1:0] selected_column = COLUMN_INDICES[32'(output_column)*COLUMN_BITS +: COLUMN_BITS];
    wire [MEMORY_ADDRESS_BITS-1:0] write_address = MEMORY_ADDRESS_BITS'(32'(write_bank)*ROW_WORDS + 32'(write_word));
    wire [MEMORY_ADDRESS_BITS-1:0] read_address = MEMORY_ADDRESS_BITS'(32'(read_bank)*ROW_WORDS +
      32'(selected_column)*CHANNEL_WORDS + 32'(read_channel));
    wire keep_row = USED_ROWS[input_row];
    wire store = in_valid && in_ready && keep_row;
    wire issue = !rst && full[read_bank] && (!output_pending || out_ready);
    wire last_word = read_channel == CHANNEL_BITS'(CHANNEL_WORDS-1) &&
                     output_column == OUTPUT_COLUMN_BITS'(OUTPUT_WIDTH-1);
    wire release_row = issue && last_word &&
      (output_row == OUTPUT_ROW_BITS'(OUTPUT_HEIGHT-1) || next_row != selected_row);
    assign in_ready = !rst && (!keep_row || !full[write_bank]);
    assign out_valid = !rst && output_pending;
    reg [LANES*BITS-1:0] masked_input;
    integer lane;
    always @* begin
      masked_input = 0;
      for (lane = 0; lane < LANES; lane = lane + 1)
        if (32'(write_channel)*LANES+lane < CHANNELS)
          masked_input[lane*BITS +: BITS] = in_data[lane*BITS +: BITS];
    end
    // Full and free banks are disjoint, including simultaneous row turnover.
    (* ram_style = MEMORY_STYLE, no_rw_check *) reg [LANES*BITS-1:0] memory [0:MEMORY_WORDS-1];
    always @(posedge clk) begin
      if (store) memory[write_address] <= masked_input;
      if (issue) out_data <= memory[read_address];
    end
    always @(posedge clk) begin
      if (rst) begin
        full <= 0;
        write_bank <= 0;
        read_bank <= 0;
        input_row <= 0;
        output_row <= 0;
        output_column <= 0;
        write_word <= 0;
        write_channel <= 0;
        read_channel <= 0;
        output_pending <= 0;
      end else begin
        if (out_ready) output_pending <= 0;
        if (in_valid && in_ready) begin
          write_channel <= write_channel == CHANNEL_BITS'(CHANNEL_WORDS-1) ? CHANNEL_BITS'(0) : write_channel + 1'b1;
          if (write_word == ADDRESS_BITS'(ROW_WORDS-1)) begin
            write_word <= 0;
            input_row <= input_row == ROW_BITS'(HEIGHT-1) ? ROW_BITS'(0) : input_row + 1'b1;
            if (keep_row) begin
              full[write_bank] <= 1;
              write_bank <= write_bank == BANK_BITS'(ROW_BUFFERS-1) ? BANK_BITS'(0) : write_bank + 1'b1;
            end
          end else write_word <= write_word + 1'b1;
        end
        if (issue) begin
          output_pending <= 1;
          if (read_channel == CHANNEL_BITS'(CHANNEL_WORDS-1)) begin
            read_channel <= 0;
            if (output_column == OUTPUT_COLUMN_BITS'(OUTPUT_WIDTH-1)) begin
              output_column <= 0;
              output_row <= output_row == OUTPUT_ROW_BITS'(OUTPUT_HEIGHT-1) ? OUTPUT_ROW_BITS'(0) : output_row + 1'b1;
            end else output_column <= output_column + 1'b1;
          end else read_channel <= read_channel + 1'b1;
          if (release_row) begin
            full[read_bank] <= 0;
            read_bank <= read_bank == BANK_BITS'(ROW_BUFFERS-1) ? BANK_BITS'(0) : read_bank + 1'b1;
          end
        end
      end
    end
  end endgenerate
endmodule
module actor_10 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(4), .POOL_H(1), .POOL_W(1), .KERNEL_H(1), .KERNEL_W(1), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(0), .PAD_W(0), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(15), .INNER_BITS(19), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(24), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(512'hcfcdbb818171453ecdc3c5b63fe1003b6257ea7f5663c4c9f9e8d5182eea28ddd9c78189c20b25382deafeb9351dd2e415767ff80fee3038f36233b3251043ff), .BIASES(128'h16bfffffec500000196fffffe67), .MULTIPLIERS(64'h1d8017702e2025e), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("auto"), .PACKED_LINES(0)) actor (.*);
endmodule
module actor_11 (
  input wire clk, input wire rst,
  input wire [63:0] in_data,
  input wire [1:0] in_valid, output wire [1:0] in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  wire [63:0] bounded_input;
wire [31:0] input_0 = in_data[0 +: 32];
wire [15:0] packed_0; wire [31:0] bounded_0;
assign packed_0[0 +: 4] = 4'(input_0[0 +: 8]);
assign packed_0[4 +: 4] = 4'(input_0[8 +: 8]);
assign packed_0[8 +: 4] = 4'(input_0[16 +: 8]);
assign packed_0[12 +: 4] = 4'(input_0[24 +: 8]);
assign bounded_0[0 +: 8] = 8'(packed_0[0 +: 4]);
assign bounded_0[8 +: 8] = 8'(packed_0[4 +: 4]);
assign bounded_0[16 +: 8] = 8'(packed_0[8 +: 4]);
assign bounded_0[24 +: 8] = 8'(packed_0[12 +: 4]);
assign bounded_input[0 +: 32] = bounded_0;
wire [31:0] input_1 = in_data[32 +: 32];
wire [15:0] packed_1; wire [31:0] bounded_1;
assign packed_1[0 +: 4] = 4'(input_1[0 +: 8]);
assign packed_1[4 +: 4] = 4'(input_1[8 +: 8]);
assign packed_1[8 +: 4] = 4'(input_1[16 +: 8]);
assign packed_1[12 +: 4] = 4'(input_1[24 +: 8]);
assign bounded_1[0 +: 8] = 8'(packed_1[0 +: 4]);
assign bounded_1[8 +: 8] = 8'(packed_1[4 +: 4]);
assign bounded_1[16 +: 8] = 8'(packed_1[8 +: 4]);
assign bounded_1[24 +: 8] = 8'(packed_1[12 +: 4]);
assign bounded_input[32 +: 32] = bounded_1;
  integer_concatenate #(.INPUTS(2), .LANES(4), .OUTPUT_CHANNELS(28), .CHANNELS(64'h400000018), .TABLE_COUNT(2), .CHANNEL_TABLES(28'hf000000), .TABLES(4096'hf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0d0b0a09080605040301000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0d0c0b0a0a09080706050403020100)) actor (.in_data(bounded_input), .*);
endmodule
module integer_concatenate #(
  parameter integer INPUTS = 1, LANES = 1, OUTPUT_CHANNELS = 1, TABLE_COUNT = 1,
  parameter [INPUTS*32-1:0] CHANNELS = 1,
  localparam integer TABLE_BITS = TABLE_COUNT <= 1 ? 1 : $clog2(TABLE_COUNT),
  parameter [OUTPUT_CHANNELS*TABLE_BITS-1:0] CHANNEL_TABLES = 0,
  parameter [TABLE_COUNT*256*8-1:0] TABLES = 0,
  localparam integer PORT_BITS = INPUTS <= 1 ? 1 : $clog2(INPUTS),
  localparam integer OUTPUT_WORDS = (OUTPUT_CHANNELS + LANES - 1) / LANES,
  localparam integer WORD_BITS = OUTPUT_WORDS <= 1 ? 1 : $clog2(OUTPUT_WORDS)
) (
  input wire clk, input wire rst,
  input wire [INPUTS*LANES*8-1:0] in_data,
  input wire [INPUTS-1:0] in_valid, output wire [INPUTS-1:0] in_ready,
  output reg [LANES*8-1:0] out_data, output wire out_valid, input wire out_ready
);
  reg sending;
  reg [PORT_BITS-1:0] port;
  reg [WORD_BITS-1:0] input_word, output_word;
  reg [7:0] pixel [0:OUTPUT_CHANNELS-1];
  wire [31:0] channel_count = CHANNELS[32'(port)*32 +: 32];
  wire [31:0] input_words = (channel_count + LANES-1) / LANES;
  wire capture = !rst && !sending && in_valid[port];
  wire [LANES*8-1:0] mapped_ports [0:INPUTS-1];
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
  genvar input_port, lane, channel;
  generate for (input_port = 0; input_port < INPUTS; input_port = input_port + 1) begin: scale
    localparam integer PORT_CHANNELS = 32'(CHANNELS[input_port*32 +: 32]);
    localparam [PORT_CHANNELS*TABLE_BITS-1:0] PORT_TABLES =
      CHANNEL_TABLES[offset_for(input_port)*TABLE_BITS +: PORT_CHANNELS*TABLE_BITS];
    for (lane = 0; lane < LANES; lane = lane + 1) begin: map
      wire [TABLE_BITS-1:0] table_index = PORT_TABLES[(32'(input_word)*LANES+lane)*TABLE_BITS +: TABLE_BITS];
      wire [7:0] value = in_data[(input_port*LANES+lane)*8 +: 8];
      assign mapped_ports[input_port][lane*8 +: 8] = lookup[32'(table_index)*256 + 32'(value)];
    end
    // Each byte has exactly one statically known writer. Expressing these as
    // variable-address multiport writes would synthesize needless priority muxes.
    for (channel = 0; channel < PORT_CHANNELS; channel = channel + 1) begin: store
      always @(posedge clk)
        if (capture && port == PORT_BITS'(input_port) && input_word == WORD_BITS'(channel/LANES))
          pixel[offset_for(input_port)+channel] <= mapped_ports[input_port][(channel%LANES)*8 +: 8];
    end
  end
  endgenerate
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
    end else begin
      if (capture) begin
        if (32'(input_word) == input_words-1) begin
          input_word <= 0;
          if (port == PORT_BITS'(INPUTS-1)) begin
            port <= 0;
            sending <= 1;
          end else begin
            port <= port + 1'b1;
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
module actor_12 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(28), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(3), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(16), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(27216'h286578000000000000476086000000000000d08c77000000000000dff1820000000000008c453400000000000027aab7000000000000e393fe0000000000000cd1850000000000000771c4000000000000c82b4e000000000000fc5dc3000000000000cf6301000000000000344eb6000000000000fbbec300000000000090ead7000000000000f53d88000000000000fc2140000000000000dffdc2000000000000ee92a6000000000000186cfe000000000000dfee4e00000000000023d44d000000000000faccd1000000000000dc3ebc000000000000d7a434000000000000a8637200000000000003ddad00000000000033f5540000000000003bc0c0000000000000302005000000000000b88c82000000000000fb4186000000000000bf45b80000000000000fc4b900000000000027a209000000000000b0ed95000000000000004c4f000000000000f04184000000000000ff91f4000000000000da1270000000000000178db80000000000002bceff000000000000f45fcb000000000000304eff000000000000b432f8000000000000d3b440000000000000d9a4b20000000000001ff43d0000000000002ff188000000000000e04f82000000000000148e04000000000000f4cab10000000000000bde040000000000000ff0f3000000000000ff44fe000000000000183d3500000000000023e4ae000000000000e45b060000000000004053bd000000000000f7cfc1000000000000d6742f00000000000032ef4100000000000017d87517b9c308c0fe27f045d3d17d1c1e480b9e86dc3204d7dcfccbdf46e7ff3217df7607f3fccfdbb1e34108fccc44dc4ec01b9c679c4bc1fc3377f430baebd305c859801c33702b9086f3f07b2fefc7ebbfc6f83e8fe03c82f84191fba27a0c7fbf14743ffc3c2e1f117f14ba7af94cfa139f2fb0603bfc4f3ecbedefe800bf0bd1023052bc07d074002e32106108ebff8e107f84d81e80f411ce1410c7e09bbd249206381d41f3a0c52c3cbdf48dbc23b1749bd044f87cc8e88c7303bf0be74bc20078460f9d840041fb0bcfc6c34f451482c8f85f02fbb2ce1c007c03b0fd13a1b4f82c4113a3c9fccb46034ffd27adf090ee4314a03ae092790f81b993f8481be234f40e83fbe0bc2021c7b80e4d147fce041d7de84109345f37ffce782c9276d45cc60c120200aa7fdbdf381b5ef9a85d3e084f02f05f7df020830b9fff57c3bd3f40ff102e371481c1cbce0aec4200081fbbf4cf8707c13f004f4503e0c737ae43ff933e3bda40f401bd03c0b9ac9d82108fc4d0007d2b810b0820391c8eb2184445003037183206e39dfa3c7139e02d3fd3f0c2ec5f72181df44043b7dfde3e0bd3be1b9cb4c4410203be7c842e40f4cdb0040039fba1bae071fd0be076f851c9fc81b5301205a3bcff08defe0fbf04f8a10100befc042f7c3c716dbb804cffd1bc083bc0cfd4310bb1b187ce02fbfbb2dbedf7f38ebe1c446d38d0393f6140fc6f7213e186afbd83003e7cf78fc0304476300d4ae40efc0c1eb7ec3fc60fb1f6283b45df547f17d2b7b02c4908ab86d3bf8613f210001ec8fb53031ccf85076fc11bcc03e3becbf38e870bde051ce28c237db614bc7fd97cc50ff0c9182ffc0f6b34082f3e105ec5971ef6f810bef34bedc989fd10043bebeb012c953bf3518c1fe0bcd4bf04eb7fc22440c5dccdd71b9f4300df4cd1f1792fd18913cf8cefcabd0bee350c1e7d9ee180d441c0ef4cb0f3cd47efb13a1c004ab8bcd316d342f38ef9bf50faef007f0c5ed5bfb0d80b9f3ef01e45e9303947ff010c4f79e2e86e0b8fb6201efd9372c1e85ffc131177ac5f3ce80147db217c2b2204f7b182fc0c3cc3540c27bf47e4bf7e2c82c627d0710cfdc7247086200f0217a1b837dd040c0ef827df04a323cafb7f05fc5eb3d03c0d03d1be33e18468847af3320c142f49d45f40f7fe82181101efbf780390830c1f48cc400918720522f1beff8af40c407b07f0bebfb3c400307a047f75d44f0004417ae85211a0e186f7217c23a0cabbe0c0efc1fc048e4e175d550c1dc200cfd2ccb0753c8f4b0fd0c00b0a7b0bc0f92fdfbeaf74b0e462392b1ef4f38e3cdc0f7ce81ffbefad09f362c4fc7ab8eb038cf6fe40f85f780bb1841432b21c6c7df3e2f3f33fb72c0133d01cbce46f3f079ffffeffc1d80c44e46fe10f2c7ce06dc81f90fc381e2ce6624b03ad07b42f88ef4d7ef3f26fcbd53413a033e04f88d7b1041790380f01c2e2ccb4e42f7eec0042bfd23cec8fbbd8a07904827fdcab3f03507fb7f36aea10cb23de86f3f2c6036201c080488fd05023703cf01f1cc053bc38523fdb5f8b980d4a0bae8303e145a7d5bae90132cfb0fae70fb7001005dcb9c5e00107f8754610d254340b841f863b137d0af81b760b8fcadb73c9087c83543d8008424bd882c4efc2c1f01f730b49b7ef1ccbaccefcfd25edd8cdcae70af248f2b2d8054600be3634dac51fe0520c713b215d7cd2ce7d303dbeebdb70f3dd8100800926c210e4a1fcfb90ff0afc2e0bfec6e02f86f52fa7bc4c7e2352ee2bb502e3c5c514bfba141c3a178d4bfc10b6c85370028ff6407f72c80e3d0c6d790b9102f6d3c8e3cebafff07dfea0ee2bef4eec5f06a31c700ba24407cce9b0e92dfc9641e4f043ff7d901ff1bb188efddfcd2df7f146eccf753430bb27ef7713d14817e180ec613500c1bd2eeb801380458cd0f7dc32ebf7e0432305741c3435f0660bf100793cd97e002d40e090c9e52ee81bd1b72cbc7c24bb43047c011bfe4646e407c87dbadc93073f620317afbca012b9d44f76f3e07c1b6d4657853bd86408ebb0c24c8c77179d8807d082ad32370b02f807f13bc10fcdf00b85e07033333400cfcfbef81f45f66ebc147f881323cbdc21b91fa0fd23133da47df7c86235152cc9546afd343235dc8d47cc7fc5f7df40045e8358ecac341c73271e81e8210adc62bdf0b281232db6f000c3dc70ff3050e1e38b0be76fc22f92be03d502f070b7651a4c18cbf903ef4fb8aeb3fbbf8d0c7e83539a45106cb3177140df3682dc3d7a0c9f4a430c351014ffcf5443f3ecfcc46ec4cca84c5ac5830087c1f832b8645c0527dc8bf72f02e8f3752b6f7def503ce82e09f07dfcdc1d7d0ee6bbcfe070d89c84172f031c32c20b0104fb4ff3149abbebb0c3045409e34ac038b08f0badbbe43d07102bb7d4acbff3527fec600afb42b4fb7bfe0ff2cbb4a103b49bfe031b681ecb73c782bde0916b08d583fc0336f320450b9304cfc97f08bcce044e91c4ad42dff034343c772b91cd03fa06131dfe1f8c450fa44dd75f49b02a7d339070f7e07715016bac10b0f454f4e89ef9138289fee273ed09f418fe381d0df9f95277d880742072bd2c1011e86d3effe85133bc8b0770493382c8cc69f20751af0bfd3d0c1d78a01fc0005c42d7ba3ea80db8e43055100e85245fcbfc3d8fc7e240c3bd3710ed3e04d36f101d49136df6f03c37e0e08df8df06dffb37334fa9141b2edbdc4200c1a909070f0b806e63c4c6bbac88e05d3e088bc0146fff87f179e0727b142f04f01f79f88b40d41c7a145ffd03628bdfc17eec4c4223512d2ffff61c62fec781edfc2f0722a0b71ba4b52c5104fcaa4404acc8192e7bf01ff60f818743d202208093fbdf3f144e8703be3e06f34717c1c5d13bfd2b70780f70390b81c6ebe0023fcfcfd04272cd9c3b106f7207b273fbfb4d2fef46bff3d1a3fb3aa93e45ccc2a830acb9eb6ce7e84bf3dc30fdecdec8c43e0713eef613a1ed13ae38e051a1a86391f04bba34753f2be441ec8dc8f0394923d5ffe0123fdbb078bbd9d8148172205c05f76d2d447f83ff9332b03041ebf2401a9bb132f5ea23d025e35078fb3000ec0c083863810bdd6ae35c83209bc518127de8e07df3f04137edbafc4492e03f7cbc5e7a2410050f61413873f8d85b37fb1070fb223b2be001b693b907a3f6bc3c382341411b91e5ff8c73ffbfb7001a4ae7acb9efaac3abe961cb3e7e086f06d0400b85f37a02e14fff709538a304f4f07607cf2cf6d0c7e89d4cbb9eaac73ff9e8211906b36a001fec1b6dbd27b237bff982f3ed7ed41cfaefcc80ec1c8e90abdb8492ba3f3f48fb001323838a1f4e81ebdcc4379e87c00d740f71273851ba84acd2bc1ed0076efb1c2fbbeb74b2bbb07cfbba8ddc535617fe0ac47c0bfd5b4bc0420734b092f34e8c3b3f4bfaec43ac61060bb18acbbfb73b3ef0c77eb8043bc517dec1200d72fb7e46241c8ddb7cfeebfe03c4cbe5f06b0704214ff86cbd8c63f737f1cd278e861bd04f08e43ab1537a0bdf030c40c8d3537d0f92472f52b00214b41fef6d180007eccefbd7ea86008185d07eb604ccc8dcaf8cd4ac88ebd3bb234f4d0f6d102fa0cd2411c1f47245fc4e02b4304c23a5390f9341201576e00c0fe7cffbf0a13dbc41cdc7eebf003d3808618df41ecdc88d10f47fd5fc22c63c5093eb3dd20f9fcc180387d42fba04cfffb10d78f732f5c21ab2e0c035c82191dc5df4f72fcdc7bed0c36a35fac185ef7d62d0af0c041232298bb2881079201144efec09284f8d08f278a01fc1bc7d73fc8e0cea7db1f76271efde03b40b0f13626efb8e7bb75d03e37b3f035041002beee83fc7fbbf41144dfee4727c5ba10903a0ba0fbe89f3afbbf3d07d10ee74b03e86e053b23b937736e474167ebdfffeb003b13f937c02cfefc1e0017507d504006d89f36bd1f80f49ef427e2af011eb1d46074e4ddc4182cc3d10ec4032a5420210517b), .BIASES(576'h390000012f0000004e00000106000000bcfffffffc00000286000000ec0000000f00000044000002f000000147000000000000033bffffff9e00000353), .MULTIPLIERS(576'h1de000002f4000001f100000120000002eb0000027c0000015100000187000004120000010b0000020e000001310000023e0000011e000003b5000001e4), .PRODUCT_MASK(12'hfff), .REQUANT_MASK(12'h333), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(0)) actor (.*);
endmodule
module actor_13 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(64), .WIDTH(126), .INPUT_CHANNELS(16), .OUTPUT_CHANNELS(16), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(2), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(17), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(25), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(18432'hec2fd1bfd62381ecebe0daefdb02c8e30331131fb5d41bc510471db4c40c001fefe937b0dc02c9f150e3d4ed4318f9bf3b2702243efe2029150770ebe10b22330d87eea79fd320211646fb023218baedffd2c504212ddfe1272b4ce3f313343a303418a58deab0ea380b2222d227ebfe4c2a15191510d6a1eb2ae6f2e52104132b23f9adae019fd50b0ee8e023262cb8e65b0605e2240bd10b20f8efdae4c9250db90a819a4207f91c2a43dcf6d1b6d40a022527c9e506d9d80649470ed605c5e32e26c2c92405e8d4b3102a0ef706daf505c1fbd3e8bab8f426b7da00fee0e9080427988c02e4d9d4e9bc24e51b54d1f6fcfe1529f711d42c29f306e91b252359c3bdaedcfb49d71c0f0b42a741febf021d541fdcfaeadbf5ff0c0dfbe0f8e8de05c7f416ededf4cfc40409a6f0c2feebbbebec0a353052fd27fff649f118ef030fe3fafd03f409eb10ebf722dff139ece4f21316102435f3091d13c1d10308d3f7d0d7efecdf09cb21dbe70bda2c14fa9fd6046cebfb00fef813feaeadb5da0515f2ff57214111f1f90208aafabd5cfae11ed7295bf030f90328d9252c0140e6ecf702fe20f01713071fd5e75b3849e01024164323f7231ff1f9e6b51c9b33d5d910e5e64cbff9e1e210eee9f846f7e4a2edd9e4f6ddf9d508f9ebc9d2d4c9f4e405f55d2c09fdf8ddd811eec6c824fec1f8c00fffe910fc113af6ff12200fe2051aef81e716e1281b0b0401511b0711cb05fa9b0d1d241a084308e4d566f0cfd305d6cc41d1f517d00e1fa4fefae5fb81dfc32950ec36f416ff030bba5ca0b5ed47f5ed2aea171e263421faef0d10d4edc0092cdcfbe5d881332efa30dd0bd1e96ab4cefcd21c0805f11e210ae004ded6c73821fcf7ec1894361bef0eec14f81148ec15e8d6fff929241630ecda22391b1c17e2b803e41ff3c8e9fef0eff7e632fb52e3ffaae72afaf0f9d2fcf8ffdbfce0fb21c6fdb61ca1331cff14c71c0dfa5318dd0ec804fd181025e61817f62e17153ed8140fd410b33848f70b0140e1d73ed91bfbeedb2943fc1bf20ed806fdbae4f100e7fad8dff90d53dc020a26182229280d0781083aeee0ceee1630fe1b12fa17eab6fc993bb5caf2f004cc0c24eb4616051db9f858ca17e4f40d2b132038fbfa14d7199cfdb0ab122afce5f70b9a1b01f308c4033432ee09d50cfc1c8fdbd210ddbe0097dff6f9311308e70db320dee8d52bd3d4e76c250f021bf1ee439adc14f70815d71b29fc22ab2624bcb5efefbc1a0d2d060a11da21f3d0d2ff36ec15ee1222241cb44dd1cbef0652bbe60619e233ee13e468f016f2e019ff9f0307dab35f48384c14222beeeff21b06abbadabd1409f5f6c4e6c51fd54f04f0cb819cf52639fa1e07320fdb313af01aeec0b5ea19040d0f22e2babbfed2e707a692f2d942301f1107f1d69f0836f421cf05ee01cdfb24e3f11de7d2371703d7d009b6134906f727121bf8f1e7fb000fc7ec1aecf29c2dc6ed26188fd20f1fe8009cc3021fefd24c1a160ce44c00b649bcf6dfe90981ecd031db2bcaf6b22a1ef9c2feeef3b1d9e5c3040f120901c02c1bf3f0fad6cef0e34dde00c20107fd5916ee4ef5a7e0cdfbeed301e9c9e2dfd3ea0f0bc12a02c6ba1ac7ec180105e3fb0eebadf5dfabe9fedb3a388afceec0f9e1d42df40ce2f7c2f8b7fe25dad80ccaded6b2f903eae30de0200e09f91c280dceea1dfb0debcabd16f723f6d4fccfc4e181b2ebffc1e1ed04f4d5db1dedecf112b429d4ea1006d017f10420f1282adecfd0d602d40af9ded1fa36d1c50e05c7c4ce1236e617e5b33bc440f80509070134defc17f823d3e2003a4e0b012823e92e072fd4c605e2c7450f001926061ba547b5fb031723f418ccd501ffefe319eb03f71ee6d106efb501ebab25e7c2ecafffe5d727d918e3d8dffe279418d0eee60ac717000e1ffaac52fee905fc1905e123f4c0e700f40ed01cf5eb052bdbddf913dd20fdd8f5fb8150bb0629e4ed068b1e81d6e4faf0ecdafbe0b122f8dfd0f2b2fd1708aa0605c8db1a263708304202f0aca3e1de9be8d9158eb4d9e2810a1346f9ce0b811af1cde3badf21c3f81ee93ff14900ca9033ecf3c5ece0fdc8e4bdf215dc02153512eaf147e409e4caf6e0bc4e284f28c9032b36c8efe2d19ae3ce4d05e40cc22efa0a0226593ddbceee0c14e3a20e31c916dcebded5f423d43829100aeaee9c0b282a231e26eeff19321c12e3451851d21e24fbb6cb19dac32d1d235439f311cae61feb25bad5000d2ddff43b3f0102c5f5fe09ce593514a0f8e3caee02eecb121a0dfaf458060eca1720d3c9b8fc3ede030ecca8491ec0e9b417f331dbc59fec23deca06d7df01a2e8c93d8faaf717d7f803e406e2b5e2e7e6ffe64f12aafae2d018c2cdaf21030b29fa73813b1bc0cffaf20bccdefd04b628e809141514d8ecfdff0eecfbaa21e8fd06a7173ad80bd92408dcb906f3e7ff09d112e0160ed8edea05c6f023b805e6f1f2b544c12e05daf7e5501a0e14e20a090318f4f9bfd9dd0bf6d80a0dee23ed020d49e7eb1df381f9e1dbcdcddfe6eedaf7464ffffaf0efed274ac3c4c61305f6feb32d31ec01eaff20f019cbd6e2ee17d605c5f727fefeee31fb0e13dd0e120a0c39532aeb04ee080e3aed362d08e6e91deccb02bdc1f1060bd15b23241ef7f4f6f7edaf1e07cafe04d315f1f8e3e6d10f2c38eff7d3f909f00a0cc325ed0c00f0e538cc17ed190a0803d8fca1f1e028ec35fbe61bf3dc070a0bbcd8d6fb3aecf929220b15090b01f8cbd718e6f1f3e611dc81c2deccf9df02a72525d2f624e4d4cd44cf23fcbf05d7cc052616f409d9df3b242a39f02705dfd8ea26dcefc6fa3d143e392adef9e0b3280dcf21beff05bbebc01c29060625f428dc12fa0dcd982cf8d315dc041fe011b9fb1677fefaf8ecc8d2f0e524dbf2eff10a091de8f9cdb4af88cfc9101f362f070f1122fedbe04ce1f6dfe63505f5dd044c1e0724091608f2e1f6f8ae00ebc20bc2cc07fe15f3261035f5f32e3c3bccf9db19fb05eee6d3e9f805fccb3bdaeda5d7a1fd472734e3f3f61c0d24f7db0de3aec2c90d362313c4d7281e2e2e25fcb8d75d022221e300bb020cf62e2be618ff18162ed90905e3d800c7c1c0571220dce305072b06fefdd6311de4fa16f0fe0c4f07ffaff205d38121ff293761f51e0c0e55e6e2081ae941693218fe81d9cef30aeba4bd2424343833651f4904d1dbf1def7eadd29bc32), .BIASES(512'hfffffc9500000d400000088dfffffcf7fffffc56000006c000000d0dffffff33000004c000000ea5000005dc00000b4b000001aa000007c1000002a6fffffe8f), .MULTIPLIERS(512'h710000006f0000008d00000117000000960000005c0000009d000000a90000006a000000ae000000ab000000580000009a0000008f000000fd000000af), .PRODUCT_MASK(8'hff), .REQUANT_MASK(8'h13), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_14 (
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
  integer_nearest #(.HEIGHT(64), .WIDTH(126), .CHANNELS(16), .OUTPUT_HEIGHT(128), .OUTPUT_WIDTH(252), .LANES(4), .BITS(4), .ROW_BUFFERS(2), .MEMORY_STYLE("auto"), .ROW_INDICES(768'hffffbef7df3cefbebae79e38df7db6d75d34cf3cb2c71c30befbaeb6db2caebaaaa69a289e79a69659248e38a28618207df79e75d71c6db69a6596185d75965555144d34924514103cf38e34d30c2cb28a2492081c71861451040c3082041000), .COLUMN_INDICES(1764'hfbf7e7cf7efd7af3e7c78efdfb76ebd7a74e7cf972e3c7870dfbf76edbb766cd7af56ad3a7468cf9f366cb97264c78f162c387060bf7ef5ebb76e5cb76ed5ab366c58af5eb56ab56a54a74e952a3468509f3e74e9b3664c972e54a93264488f1e3468b16244870e14283060407efdf3e7af5e3c76edd3a72e5c386eddb366ad5a3466cd93262c58305ebd72e5ab562c56ad52a52a54284e9d3264a95224468d12242850203e7cf1e3a74e1c366cd1a3264c182e5cb162a54a14264c91222448101e3c70e1a3460c162c50a12244080e1c3060a14204060c1020204000)) actor (.in_data(stored_input), .out_data(stored_output), .*);
endmodule
module actor_15 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(12), .OUTPUT_CHANNELS(2), .POOL_H(1), .POOL_W(1), .KERNEL_H(1), .KERNEL_W(1), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(0), .PAD_W(0), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(14), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(23), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(192'hfe11395de32de214618167dbc615f394f20f7fbc4d0c0ee2), .BIASES(64'hffffffd40000009d), .MULTIPLIERS(32'h19b01a8), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("auto"), .PACKED_LINES(0)) actor (.*);
endmodule
module actor_16 (
  input wire clk, input wire rst,
  input wire [63:0] in_data,
  input wire [1:0] in_valid, output wire [1:0] in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  wire [63:0] bounded_input;
wire [31:0] input_0 = in_data[0 +: 32];
wire [15:0] packed_0; wire [31:0] bounded_0;
assign packed_0[0 +: 4] = 4'(input_0[0 +: 8]);
assign packed_0[4 +: 4] = 4'(input_0[8 +: 8]);
assign packed_0[8 +: 4] = 4'(input_0[16 +: 8]);
assign packed_0[12 +: 4] = 4'(input_0[24 +: 8]);
assign bounded_0[0 +: 8] = 8'(packed_0[0 +: 4]);
assign bounded_0[8 +: 8] = 8'(packed_0[4 +: 4]);
assign bounded_0[16 +: 8] = 8'(packed_0[8 +: 4]);
assign bounded_0[24 +: 8] = 8'(packed_0[12 +: 4]);
assign bounded_input[0 +: 32] = bounded_0;
wire [31:0] input_1 = in_data[32 +: 32];
wire [15:0] packed_1; wire [31:0] bounded_1;
assign packed_1[0 +: 4] = 4'(input_1[0 +: 8]);
assign packed_1[4 +: 4] = 4'(input_1[8 +: 8]);
assign packed_1[8 +: 4] = 4'(input_1[16 +: 8]);
assign packed_1[12 +: 4] = 4'(input_1[24 +: 8]);
assign bounded_1[0 +: 8] = 8'(packed_1[0 +: 4]);
assign bounded_1[8 +: 8] = 8'(packed_1[4 +: 4]);
assign bounded_1[16 +: 8] = 8'(packed_1[8 +: 4]);
assign bounded_1[24 +: 8] = 8'(packed_1[12 +: 4]);
assign bounded_input[32 +: 32] = bounded_1;
  integer_concatenate #(.INPUTS(2), .LANES(4), .OUTPUT_CHANNELS(18), .CHANNELS(64'h200000010), .TABLE_COUNT(2), .CHANNEL_TABLES(18'h30000), .TABLES(4096'hf0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0c0b090806050302000f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0f0e0d0d0c0b0a090808070605040303020100)) actor (.in_data(bounded_input), .*);
endmodule
module actor_17 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(18), .OUTPUT_CHANNELS(8), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(4), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(6), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(15), .INNER_BITS(20), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(26), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(8640'hf06000d8300004e00003bf390f0ac1142d8502ff48f88e41173d7eab0cc9f360ba14edc430a0bcd38189dcc003f0a2c2fc3dff467a46074e3717d000f4a000d87000fc6000dfae87fc1c3ee88f930b5345f861ec107eb7c831fa07a0fb0cedf8f442d1cbc080d7e103e79271100e8d037cc9035d7c20100017b000eff000c7e000d6fe791c9ffbf00ed3001339cbf0f32471f2bfe0be0b60f8e421fbbc3e8cd89209e07102ff0002177bbcdf0e0ebca009fc50001a700085f0000ba000f79cbcfa7c1010cd0b1e3fcde0e3f91b71c507ff7f139d40102dc0e8638d1812b7040f0810a336202080cbfa83ea1df90bd000300000f9a0003fc000041abbdc1f8a5071cc2ff20c0ba57afc9185c78ec9e350f6fc4f3ce151570bd0c8f821150f953ee72fd1106d8bcb7cfc08e000c52000dc900018000084fe0be4b0fe37e0cb104047ef4eb7e8be46f44dfddb7ef8fc1e38dd5246fbb1bcf392d3e6ce77ffa04a101cfdf021402c3000d6900098b0000b6000037d39fbee7d200e443ec0caf49f4304bd44c2ee09ef8dbcfc31fbdcd0fdfb92fa246ffb30f3be38326a9f9c3cb2adbcf860000b0000b52000232000f35f3dc06f862bff8c33a2c4db60af1cdf0bd7fecdeff004dbad02287fc8e391be0412461fa7faaf4f3f038df5cefac8fc3000fcf000e4e000ec4000f08c4aefac8410100f441ec4032f7cf3bd05a75f4fef2ec4f05ec010d102d010b0fc504bef9ff4bed0faefdaf9fc41c307c000f8b000e8a000e79000f5013f10f181d50489d3b30a204d0513fe01f13b3b130cbf17d440086238c792c6876335fc2a020f72ac080ff32748c422a000206000c89000c120002890c61434c7f904050d023c4041410fddf0dcbd74c3f00603c1bafb5eb393c40efb91bd2c28462eae3ce2be86efc8cf125000ffb00013b000e0b000f7a0762ba2f3d36494d811ca1f70bbebfe45f7eec4cb913f0eb3bd1b1184d88310e32ebfdb2b92280e44843efaf74c0f073000ec5000845000c78000fcbe8a396012c06292e44e8d486e39c7aef818fcb9f7dd35c3d1fb0bd1ced73ed1ca8fb753ce45029300baa07f9feffcd610005fa000231000b020004861884cc3bfec118b14511218e0c7e71d07036c38d0910dd321796431c8ab51961baeb927fc43deea81af4102e3bc92df1000ffd0000b2000c44000f87d840fb580c34156c7f24c3fafbbd3df83dfaff7002183cf6fbb47504ba0021dfff3be1bac9218cc4400acb4fcac050cd000012000f07000e37000f4ce3f1d1d82dd023cbba276006001e69101ebcab6ccd148eb5ef44421b70c8144da50f737e273ded177ff62bc9b9145ba400017d000fe7000dc30002fc08727c17fbb540fdc0d41244cc10b0dcef2bcc3e4dc90dbbe402ff389b7a00ad7a3403f3b08c7ec07eab07e0c9ac3f6d000dcb0001b5000d07000f4cf8343c332f73347ffde37384106173bc0cc4f78f7fcfff2b403e7214895518f0364b1debc89d4bd0efb5ff52cca3a102), .BIASES(256'hea000001cc000002150000004500000101000002f800000254000001cf), .MULTIPLIERS(256'h614000003b1000001cd0000061400000209000003b800000227000001b4), .PRODUCT_MASK(16'hffff), .REQUANT_MASK(16'h3333), .WEIGHT_MEMORY("auto"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_18 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(8), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(2), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(4), .WEIGHT_BITS(8), .OUTPUT_SIGNED(0), .REDUCTION_LANES(4), .ACCUMULATOR_BYTES(2), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(13), .INNER_BITS(19), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(22), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'h0), .HIGH(64'hf), .WEIGHTS(4608'h2fefcfeff0001fffcf7fefcfe0202fe01fefdffff0000fffdf8fefdff0103ff0001fcfc000000fefffd00fe00ff030000fafbfa000001fffcfefbfbfcfd01fd7ffbfefd007fff01fcf7fdfbfe0103ff0000fdffff00fffffdfe00fcff0003ff00fbfa00ff010200fefcfefcfe0200ff00fcfdfbffff01fdfcfbfffbfe0001ff0100fc0200ff00fefd0002fdfffd010000ff02000200ff00ff000100fe0000ff00ff0002ff02fc00fefb01ff00fc0200ff0000fffd02fcfeff0003ff03ff01fe01000200020100fe00fc0000fe00fffe01ff7f020101ff7ffefb01fffeff02ff0000ff01fd00fc01fe0002fffbff01fa000102ff0201000001feff01ff02fdff000001fe010002fefffd0200fffe01ffff010100feff0300ff000200fcff01ff000003fdfffdfe0100040001fc0103fb00ff0100fefffbfe01030101fe0002fdffff01ff00fefefe01000301ff020300010003fd00fafeff00fcff00f8fd00f900010000fefefaff7fff0200fd7f01fcff00ff0400fcfdfd00fe0200ff0001ff0101020000fe000000ffff00fd0301fdff0101fefefefcfc00ff0200000100fffe010001fefcfdfb00ff030000000101ff000102ff000300ffff01ff00040101ff00ff02ffff0100ff0001ff00030201ff0000fdffff0100fffe01ff01020201ff000100000103fefdfd00fd00ff0000ff01fe0100010001fe007ffd0001017fff00ffffff000003fffe01ff00000100ff000200010103fefe01ffff0002ff00ff0000feff0101fdffff00ff01010101feff00fefe010101fffd00ff01000201), .BIASES(256'h2fffffffcfffffffdfffffff8fffffffdfffffffafffffffefffffffe), .MULTIPLIERS(256'h21c00000215000002140000021500000213000002140000021600000213), .PRODUCT_MASK(8'hff), .REQUANT_MASK(8'h33), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_19 (
  input wire clk, input wire rst,
  input wire [31:0] in_data, input wire in_valid, output wire in_ready,
  output wire [31:0] out_data, output wire out_valid, input wire out_ready
);
  integer_convolution #(.HEIGHT(128), .WIDTH(252), .INPUT_CHANNELS(8), .OUTPUT_CHANNELS(1), .POOL_H(1), .POOL_W(1), .KERNEL_H(3), .KERNEL_W(3), .STRIDE_H(1), .STRIDE_W(1), .DILATION_H(1), .DILATION_W(1), .PAD_H(1), .PAD_W(1), .GROUPS(1), .LANES(4), .OUTPUT_LANES(1), .INPUT_SIGNED(0), .INPUT_BITS(4), .OUTPUT_ELEMENT_BITS(8), .WEIGHT_BITS(8), .OUTPUT_SIGNED(1), .REDUCTION_LANES(1), .ACCUMULATOR_BYTES(3), .MULTIPLIER_BYTES(2), .ACCUMULATOR_BITS(18), .INNER_BITS(18), .MULTIPLIER_SIGNED(0), .REQUANT_BITS(26), .SHIFT(16), .OFFSET(64'h8000), .LOW(64'hffffffffffffff80), .HIGH(64'h7f), .WEIGHTS(576'hacab9aba5d0bda434c8c2af99b3a8c141e4bec8cab6bbbeeab0a081b7c0cfc435a6b7add8c9b5d14a8dd3b7b78f9ab7ffd4baa6b6c7c2ce2abaaaa4cca9b4ba31c0b6d6d7c3bbb4), .BIASES(32'hffffffe1), .MULTIPLIERS(16'h122), .PRODUCT_MASK(1'h1), .REQUANT_MASK(1'h1), .WEIGHT_MEMORY("logic"), .LINE_MEMORY("auto"), .PACKED_LINES(1)) actor (.*);
endmodule
module actor_20 (
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
