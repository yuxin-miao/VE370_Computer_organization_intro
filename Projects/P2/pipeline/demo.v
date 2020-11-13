`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/08 16:40:29
// Design Name: 
// Module Name: demo
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module Decoder_2_4in (I, D);
input [1:0] I;
output [3:0] D;
reg [3:0] D;
always @ (I) begin
case (I)
2'b00: D=4'b1110;
2'b01: D=4'b1101;
2'b10: D=4'b1011;
2'b11: D=4'b0111;
default D=4'b1111;
endcase
end
endmodule

module counter_2_bit (reset, clock, Q);
input reset, clock;
output [1:0] Q;
reg [1:0] Q;
always @ (posedge reset or posedge clock) begin
if (reset == 1'b1) Q=0;
else Q=Q+1;
end
endmodule

module ring_counter(clock, reset, P);
input reset, clock;
output [3:0] P;
wire [1:0] Q;
counter_2_bit bb(reset, clock, Q);
Decoder_2_4in cc(Q, P);
endmodule

module divider_1 (reset, clock, clock_out);
parameter N = 50000000;
input clock, reset;
output clock_out;
reg [33:0] Q;
reg clock_out;
always @ (posedge clock) begin
if (reset == 1'b1)
begin
Q = 0;
clock_out = 0;
end
else if (Q == N-1) begin
Q = 0;
clock_out = ~clock_out;
end
else begin
Q = Q + 1;
end
end
endmodule

module ttop(clk, reset, clock, shuzi, SSD, A0, A1, A2, A3);
input clk, reset, clock;
input [15:0] shuzi;
output [6:0] SSD;
output A0, A1, A2, A3;
wire [3:0] A;
wire [3:0] sh3, sh2, sh1, sh0;
wire clcc, clout;
assign A = {A0, A1, A2, A3};
assign sh3 = shuzi[15:12];
assign sh2 = shuzi[11:8];
assign sh1 = shuzi[7:4];
assign sh0 = shuzi[3:0];
reg [3:0] sh;
reg [6:0] SSD;
divider_1 #(200000) N4 (reset, clk, clcc);
ring_counter MM(clcc, reset, A);
always @ (sh)begin
if (sh == 0) SSD = 1;
else if (sh == 1) SSD = 79;
else if (sh == 2) SSD = 18;
else if (sh == 3) SSD = 6;
else if (sh == 4) SSD = 76;
else if (sh == 5) SSD = 36;
else if (sh == 6) SSD = 32;
else if (sh == 7) SSD = 15;
else if (sh == 8) SSD = 0;
else if (sh == 9) SSD = 4;
else if (sh == 10) SSD = 8;
else if (sh == 11) SSD = 96;
else if (sh == 12) SSD = 49;
else if (sh == 13) SSD = 66;
else if (sh == 14) SSD = 48;
else SSD = 56;
end
always @ (posedge clcc) begin
case (A)
4'b0111: sh = sh0;
4'b1011: sh = sh3;
4'b1101: sh = sh2;
4'b1110: sh = sh1;
default: sh = 0;
endcase
end
endmodule


module Demo(Input_Readreg, Input_ReadPC, switch, SSDoutupper, clk2, reset, SSDout, SSDdigit);
input [4:0] Input_Readreg;
input Input_ReadPC;
input switch;
input SSDoutupper;
input clk2;
input reset;
output [6:0] SSDout;
output [3:0] SSDdigit;
wire A0, A1, A2, A3;
wire useless;
wire [31:0] pcout, regout;
wire [31:0] out;
PipelinedProcessor_bonus M1 (switch, Input_Readreg, reset, useless, pcout, regout);
assign out = (Input_ReadPC == 1'b1) ? pcout : regout;
ttop M2 (clk2, reset, switch, out[15:0], SSDout, A0, A1, A2, A3);
assign SSDdigit = {A0, A1, A2, A3};
endmodule

/*
module Demo(clk, reset, clock, switch, SSD, A);
input clk, reset, clock;
input [5:0] switch;
output [6:0] SSD;
output [3:0] A;
wire A0, A1, A2, A3;
wire [4:0] readreg;
wire [31:0] pcout, regout;
wire [31:0] out;
wire useless;
assign readreg = switch[4:0];
PipelinedProcessor_bonus M1 (clock, readreg, reset, useless, pcout, regout);
assign out = (switch[5] == 1'b1) ? pcout : regout;
ttop M2 (clk, reset, clock, out[15:0], SSD, A0, A1, A2, A3);
assign A = {A0, A1, A2, A3};
endmodule
*/