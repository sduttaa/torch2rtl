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
fifo_actor_0 fifo_0 (
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
fifo_actor_1 fifo_1 (
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
fifo_actor_2 fifo_2 (
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
fifo_actor_3 fifo_3 (
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
fifo_actor_4 fifo_4 (
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
fifo_actor_5 fifo_5 (
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
fifo_actor_6 fifo_6 (
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
fifo_actor_7 fifo_7 (
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
fifo_actor_8 fifo_8 (
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
fifo_actor_9 fifo_9 (
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
fifo_actor_10 fifo_10 (
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
fifo_actor_11 fifo_11 (
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
fifo_actor_12 fifo_12 (
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
fifo_actor_13 fifo_13 (
.clk(clk), .rst(rst), .in_data(packed_input_13), .in_valid(valid_11 && ready_11), .in_ready(space_13),
.out_data(packed_output_13), .out_valid(edge_valid_13), .out_ready(edge_ready_13));
wire [31:0] edge_data_14; wire edge_valid_14, edge_ready_14, space_14;
wire [7:0] packed_input_14, packed_output_14;
assign packed_input_14[0 +: 4] = 4'(data_12[0 +: 8]);
assign packed_input_14[4 +: 4] = 4'(data_12[8 +: 8]);
assign edge_data_14[0 +: 8] = 8'(packed_output_14[0 +: 4]);
assign edge_data_14[8 +: 8] = 8'(packed_output_14[4 +: 4]);
assign edge_data_14[31:16] = '0;
fifo_actor_14 fifo_14 (
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
fifo_actor_15 fifo_15 (
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
fifo_actor_16 fifo_16 (
.clk(clk), .rst(rst), .in_data(packed_input_16), .in_valid(valid_14 && ready_14), .in_ready(space_16),
.out_data(packed_output_16), .out_valid(edge_valid_16), .out_ready(edge_ready_16));
wire [31:0] edge_data_17; wire edge_valid_17, edge_ready_17, space_17;
wire [7:0] packed_input_17, packed_output_17;
assign packed_input_17[0 +: 8] = 8'(data_15[0 +: 8]);
assign edge_data_17[0 +: 8] = 8'($signed(packed_output_17[0 +: 8]));
assign edge_data_17[31:8] = '0;
fifo_actor_17 fifo_17 (
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

module harness(input wire clk, input wire rst, output wire observed);

  wire core_clock, clock_locked;
  inference_clock clock_source(.clock_in(clk), .clock_out(core_clock), .locked(clock_locked));
  wire reset_requested = rst || !clock_locked;
  (* async_reg = "true" *) reg [1:0] reset_sync = 2'b11;
  always @(posedge core_clock or posedge reset_requested)
    if (reset_requested) reset_sync <= 2'b11;
    else reset_sync <= {reset_sync[0], 1'b0};
  wire core_reset = reset_sync[1];

  reg [31:0] source;
  wire in_ready;
  wire [31:0] out_data;
  wire out_valid;
  reg [31:0] checksum;
  inference core(.clk(core_clock), .rst(core_reset), .in_data(source), .in_valid(1'b1),
    .in_ready(in_ready), .out_data(out_data), .out_valid(out_valid), .out_ready(1'b1));
  always @(posedge core_clock) begin
    if (core_reset) begin source <= 0; checksum <= 0; end
    else begin
      if (in_ready) source <= source + 1'b1;
      if (out_valid) checksum <= (checksum << 1) ^ out_data;
    end
  end
  assign observed = ^checksum;
endmodule
/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the gowin-pll tool.
 * Use at your own risk.
 *
 * Target-Device:                GW2AR-18 C8/I7
 * Given input frequency:        27.000 MHz
 * Requested output frequency:   108.000 MHz
 * Achieved output frequency:    108.000 MHz
 */

module inference_clock(
        input  clock_in,
        output clock_out,
        output locked
    );

    rPLL #(
        .FCLKIN("27.0"),
        .IDIV_SEL(0), // -> PFD = 27.0 MHz (range: 3-500 MHz)
        .FBDIV_SEL(3), // -> CLKOUT = 108.0 MHz (range: 3.90625-625 MHz)
        .ODIV_SEL(8) // -> VCO = 864.0 MHz (range: 500-1250 MHz)
    ) pll (.CLKOUTP(), .CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0), 
        .CLKIN(clock_in), // 27.0 MHz
        .CLKOUT(clock_out), // 108.0 MHz
        .LOCK(locked)
    );

endmodule
