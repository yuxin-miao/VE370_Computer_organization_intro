`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/11/01 21:09:40
// Design Name: 
// Module Name: simgroup
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


module simgroup;
parameter half_period = 50;
reg clk, reset;
reg [4:0] Input_Readreg;
reg Input_ReadPC;
wire [31:0] PCout, RegOut;
PipelinedProcessor_bonus UUT (clk, Input_Readreg, reset, Input_ReadPC, PCout, RegOut);
initial begin
#0 clk = 0; reset = 1; Input_Readreg = 1; Input_ReadPC = 0;
#60 reset = 0; 
end
initial begin
$monitor("Time: %d, CLK = %h, PC = %h, \n [$s0] = %h, [$s1] = %h, [$s2] = %h, \n [$s3] = %h, [$s4] = %h, [$s5] = %h, \n [$s6] = %h, [$s7] = %h, [$t0] = %h, \n [$t1] = %h, [$t2] = %h, [$t3] = %h, \n [$t4] = %h, [$t5] = %h, [$t6] = %h, \n [$t7] = %h, [$t8] = %h, [$t9] = %h \n", 
$stime, clk, UUT.PC_.pcout, UUT.M4.file[16], UUT.M4.file[17], UUT.M4.file[18], UUT.M4.file[19], UUT.M4.file[20], UUT.M4.file[21], UUT.M4.file[22], UUT.M4.file[23], UUT.M4.file[8], UUT.M4.file[9], UUT.M4.file[10], UUT.M4.file[11], UUT.M4.file[12], UUT.M4.file[13], UUT.M4.file[14], UUT.M4.file[15], UUT.M4.file[24], UUT.M4.file[25]);
//$monitor("[$s0] = %h ", UUT.M4.file[16], );
//$monitor("Time: %d, CLK = %h, pc_in_if = %h, branchjump_if = %h, branchjumpaddress_if=%h pc_out_if = %h, beq_id = %h,\n jump = %h, instruction_if = %h  pcplus4_if = %h, pcplus4_id = %h, if_id_write_hazard = %h \n regdata1_id = %h regdata2_id = %h com_res_id = %h imm_signEx_id= %h branchaddress_id = %h \n regdst_ex = %h rs_ex = %h rt_ex = %h ALUresult_ex = %h \n ALUin1final_ex ", 
//$stime, clk, UUT.pc_in_if, UUT.branchjump_if, UUT.branchjumpaddress_if, UUT.pc_out_if, UUT.beq_id, UUT.jump, UUT.instruction_if, UUT.pcplus4_if, UUT.pcplus4_id, UUT.if_id_write_hazard, UUT.regdata1_id, UUT.regdata2_id, UUT.com_res_id, UUT.imm_signEx_id, UUT.branchaddress_id, UUT.regdst_ex, UUT.rs_ex, UUT.rt_ex, UUT.ALUresult_ex, UUT.ALUin1final_ex);
//$monitor("Time: %d, CLK = %h, datamem_(1) = %h, datamem_(2) = %h, stall = %h, if_id_write_hazard=%h, pc_write_hazard=%h, memread_ex=%h, rs_id=%h, rt_id=%h, rt_ex=%h, instruction_id=%h", $stime, clk, UUT.datamem_.register_memory[1], UUT.datamem_.register_memory[2], UUT.stall, UUT.if_id_write_hazard, UUT.pc_write_hazard, UUT.memread_ex, UUT.rs_id, UUT.rt_id, UUT.rt_ex, UUT.instruction_id);
//$monitor("beq_id=%h, branchaddress_id=%h, branchjump_if=%h, branchjumpaddress_if=%h, pcplus4_if=%h, pc_write_hazard=%h, pc_write_2=%h", UUT.beq_id, UUT.branchaddress_id, UUT.branchjump_if, UUT.branchjumpaddress_if, UUT.pcplus4_if, UUT.pc_write_hazard, UUT.pc_write_2);
//$monitor("Time: %d, CLK = %h, pc_write_hazard=%h, pc_write_2=%h, rd_ex=%h, rs_id=%h, rt_id=%h, regwrite_ex=%h, rt_ex=%h, memread_ex=%h, regwrite_mem=%h, memwrite_mem=%h", $stime, clk,  UUT.pc_write_hazard, UUT.pc_write_2, UUT.rd_ex, UUT.rs_id, UUT.rt_id, UUT.regwrite_ex, UUT.rt_ex, UUT.memread_ex, UUT.regwrite_mem, UUT.memwrite_mem);
//$monitor("eq_mux1_id=%h, eq_mux2_id%h, forwardingeqin1=%h, forwardingeqin2=%h, writeback_wb=%h, registerrd_mem=%h, registerrd_wb=%h,pc_write_3_id=%h, pc_write_3_ex=%h, pc_write_2=%h",  UUT.eq_mux1_id,UUT.eq_mux2_id,UUT.forwardingeqin1, UUT.forwardingeqin2, UUT.writeback_wb, UUT.registerrd_mem, UUT.registerrd_wb, UUT.pc_write_3_id, UUT.pc_write_3_ex, UUT.pc_write_2);
//$monitor("pc_write_3_id=%h, pc_write_3_ex=%h, pc_write_2=%h", UUT.pc_write_3_id, UUT.pc_write_3_ex, UUT.pc_write_2);
end
always #half_period clk = ~clk;
initial #4000 $stop;
endmodule


