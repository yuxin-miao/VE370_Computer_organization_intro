`timescale 1ns / 1ps

`include "alu.v"
`include "alu_control.v"
`include "control.v"
`include "InstrMem.v"
`include "registers.v"
`include "DataMemory.v"
`include "sign_extend.v"
`include "pc.v"

module single_cycle (input clk, reset);

    wire        [31:0]  pc_in,
                        pc_out,
                        pc_plus_4,
                        instruction,
                        jump_addr,
                        bracn_addr_result,
                        branchaddr;

    wire                branch;

    wire                regdst,
                        jump,
                        beq,
                        bne,
                        mem_read,
                        memtoreg,
                        memwrite,
                        alusrc,
                        reg_write;
    wire        [1:0]   aluOp;

    wire        [4:0]   reg_dst;
    wire        [31:0]  reg_write_data,
                        regReadData1,
                        regReadData2;

    wire        [31:0]  sign_extend,
                        alu_in_rt,
                        alu_result;
    wire        [3:0]   alu_control;
    wire                alu_zero;

    wire        [31:0]  data_mem_data;

    assign pc_plus_4 = pc_out + 4;
    assign branchaddr = pc_plus_4 + (sign_extend << 2);
    assign branch = (beq & alu_zero) | (bne & ~alu_zero);
    assign bracn_addr_result = (branch == 1'b0) ? pc_plus_4 : branchaddr;
    assign jump_addr = {pc_plus_4[31:28], instruction[25:0], 2'b0};
    assign pc_in = (jump == 1'b0) ? bracn_addr_result : jump_addr;

    assign reg_dst = (regdst == 1'b0) ? instruction[20:16] : instruction[15:11];
    assign reg_write_data = (memtoreg == 1'b0) ? alu_result : data_mem_data;
    assign alu_in_rt = (alusrc == 1'b0) ? regReadData2 : sign_extend;
    
    // assign pc_out = (reset == 1) ? 32'b0 : pc_in;


    PC pc(.clk(clk),
        .reset(reset),
        .in(pc_in),
        .out(pc_out)
    );

    InstructionMemory instrmem(
        .read_addr(pc_out),
        .instruction(instruction)
    );

    Control control(
        .opcode(instruction[31:26]),
        .regdst(regdst),
        .jump(jump),
        .beq(beq),
        .bne(bne),
        .memread(mem_read),
        .memtoreg(memtoreg),
        .memwrite(memwrite),
        .alusrc(alusrc),
        .regwrite(reg_write),
        .aluop(aluOp)
    );

    SignExtend signExtend(
        .in(instruction[15:0]),
        .out(sign_extend)
    );

    ALUControl aluControl(
        .func(instruction[5:0]),
        .ALUOp(aluOp),
        .alu_control(alu_control)
    );

    Regs registers(
        .clk(clk),
        .read_reg1(instruction[25:21]),
        .read_reg2(instruction[20:16]),
        .read_data1(regReadData1),
        .read_data2(regReadData2),
        .write_reg(reg_dst),
        .write_data(reg_write_data),
        .regwrite(reg_write)
    );

    ALU alu(
        .a(regReadData1),
        .b(alu_in_rt),
        .alu_control(alu_control),
        .zero(alu_zero),
        .Result(alu_result)
    );

    DataMemory datamem(
        .clk(clk),
        .addr(alu_result),
        .write_data(regReadData2),
        .read_data(data_mem_data),
        .MemWrite(memwrite),
        .MemRead(mem_read)
    );

endmodule 
