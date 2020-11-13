`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/31 21:32:11
// Design Name: 
// Module Name: top
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

// determine whether there is a data hazard of lw
module hazarddetection(reset, rs_id, rt_id, rt_ex, rd_ex, regWrite_ex, IDEXmemread, PCwrite, IFIDwrite, hazard, PCwrite2, beq_id, PCwrite3);
input [4:0] rs_id, rt_id, rt_ex, rd_ex;
input IDEXmemread, reset, regWrite_ex, beq_id;
output PCwrite, IFIDwrite, hazard, PCwrite2, PCwrite3;
wire pc1, if1, ha1,pc2, pc3;
// pc2 used for beq data hazard, one previous R-type 
// pc2 for beq data hazard, with lw

assign pc1 = ((IDEXmemread == 1) && ((rs_id == rt_ex) || (rt_id == rt_ex))) ? 0 : 1;
assign if1 = PCwrite;
assign ha1 = ~PCwrite;

assign pc2 = (beq_id && (regWrite_ex == 1) && ( ((rs_id == rd_ex) || (rt_id == rd_ex)) || ((rs_id == rt_ex) || (rt_id == rt_ex)))) ? 0 : 1;
assign pc3 = ( beq_id && ((IDEXmemread == 1) && ((rs_id == rt_ex) || (rt_id == rt_ex))) ) ? 0 : 1;
assign {PCwrite, IFIDwrite, hazard, PCwrite2, PCwrite3} = (reset == 1) ? 5'b11011 : {pc1, if1, ha1, pc2, pc3};
endmodule

// determine whether contents in rs and rt are the same 
module comparator(reset, I1, I2, res);
input [31:0] I1, I2;
input reset;
output res;
wire ress;
assign ress = (I1 == I2) ? 1 : 0;
assign res = reset ? 0 : ress;
endmodule

module control(inst, equal, IFflush, regdst, jump, branch, memread, memtoreg, aluop, memwrite, alusrc, regwrite);
input [5:0] inst;
input equal; // output of module comparator
output IFflush; 
output regdst, jump, branch, memread, memtoreg, memwrite, alusrc, regwrite; 
output [1:0] aluop;
reg regdst, jump, branch, memread, memtoreg, memwrite, alusrc; 
reg [1:0] aluop;
initial begin
branch = 0;
jump = 0;
memread = 0;
memtoreg = 0;
memwrite = 0;
alusrc = 0;
end
always @ (inst)begin
// r-type
if (inst == 0) begin regdst = 1; jump = 0; branch = 0; memread = 0; memtoreg = 0; memwrite = 0; alusrc = 0; aluop = 2; end
// addi
else if (inst == 8) begin regdst = 0; jump = 0; branch = 0; memread = 0; memtoreg = 0; memwrite = 0; alusrc = 1; aluop = 0;end
// lw
else if (inst == 35) begin regdst = 0; jump = 0; branch = 0; memread = 1; memtoreg = 1; memwrite = 0; alusrc = 1; aluop = 0; end
// sw
else if (inst == 43) begin regdst = 0; jump = 0; branch = 0; memread = 0; memtoreg = 1; memwrite = 1; alusrc = 1; aluop = 0; end
// andi
else if (inst == 12) begin regdst = 0; jump = 0; branch = 0; memread = 0; memtoreg = 0; memwrite = 0; alusrc = 1; aluop = 3; end
// beq
else if (inst == 4) begin regdst = 0; jump = 0; branch = 1; memread = 0; memtoreg = 0; memwrite = 0; alusrc = 0; aluop = 1; end
// jump
else if (inst == 2) begin regdst = 0; jump = 1; branch = 0; memread = 0; memtoreg = 0; memwrite = 0; alusrc = 0; aluop = 1; end
end
assign regwrite = (inst == 0) || (inst == 8) || (inst == 35) || (inst == 12) ? 1 : 0;
assign IFflush = ((branch == 1) && (equal == 1)) || (jump == 1) ? 1 : 0;
endmodule

// IF/ID: Din={PC+4, mips} 64
// ID/EX: Din={rs, rt, rd, (rs), (rt), signEXT, memread, memtoreg, aluop, memwrite, alusrc, regwrite} 118
// EX/MEM: Din={forwardB, aluresult, dst, memread, memtoreg, memwrite, regwrite} 69 
// MEM/WB: Din={readdata, aluresult, dst, memtoreg, regwrite} 67
module register(write, flush, clock, Din, Dout);
parameter N = 32;
input write, flush, clock;
input [N-1:0] Din;
output [N-1:0] Dout;
reg [N-1:0] Dout;
initial begin
Dout <= 0;
end

always @ (posedge clock)begin
if (flush == 1) Dout <= 0;
else if (write == 0) Dout <= Dout;
else Dout <= Din;
end
endmodule