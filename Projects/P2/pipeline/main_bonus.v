`timescale 1ns / 1ps
/*
`include "PC.v"
`include "InstrMem.v"
`include "RegFile.v"
`include "SignExtend.v"
`include "MUX4_2.v"
`include "ALUcontrol.v"
`include "ALU.v"
`include "DataMemory.v"

`include "Forwardingunit.v"
`include "top.v"
*/
module PipelinedProcessor_bonus(
    input clk,
    input [4:0] Input_Readreg,
    input reset,
    input Input_ReadPC,
    output [31:0] PCout,
    output [31:0] RegOut
    );
    //WIRE IF STAGE  
    wire    [31:0]  pc_in_if,
                    pc_out_if,
                    pcplus4_if,
                    instruction_if,
                    branchjumpaddress_if;
    wire            branchjump_if,// if there is branch or jump, then 1
                    if_id_write_hazard,
                    pc_write_hazard,
                    pc_write_2; // beq + data hazard, R-type

    //WIRE ID STAGE 
    wire    [31:0]  pcplus4_id,
                    instruction_id,
                    regdata1_id,
                    regdata2_id,
                    regdata1final_id,
                    regdata2final_id,
                    branchaddress_id,
                    jumpaddress_id,
                    imm_signEx_id,
                    eq_mux1_id,
                    eq_mux2_id;
    wire    [25:0]  jump_inst_id;
    wire    [5:0]   op_id;
    wire    [4:0]   rs_id,
                    rt_id,
                    rd_id;
    wire    [15:0]  immi_id;
    wire            branch_id,//if there is successful branch, then 1(beq or bne)
                    beq_id, // delete bne 
                    regwrite_id,
                    memtoreg_id,
                    memwrite_id,
                    memread_id,
                    regdst_id,
                    ALUsrc_id,
                    com_res_id, 
                    jump,
                    pc_write_3_id;
                  //  regdst_id1, ALUsrc_id1, regwrite_id1, memtoreg_id1, memwrite_id1, memread_id1, ALUop_id1,
           // regdata1_id1, regdata2_id1, imm_signEx_id1, rs_id1, rt_id1, rd_id1;
    wire    [1:0]   ALUop_id;

    //WIRE EX STAGE 
    wire            regwrite_ex,
                    memtoreg_ex,
                    memwrite_ex,
                    memread_ex,
                    regdst_ex,
                    ALUsrc_ex,
                    pc_write_3_ex,
                    exzero; // seems like useless?
    wire    [1:0]   ALUop_ex;
    wire    [31:0]  regdata1final_ex,
                    regdata2final_ex,
                    immi_signEx_ex,
                    ALUin1final_ex,
                    ALUin2final_ex,
                    ALUresult_ex,
                    ALUin2_ex;
    wire    [5:0]   func_ex;
    wire    [4:0]   rs_ex,
                    rt_ex,
                    rd_ex,
                    registerrd_ex;
    wire    [3:0]   ALUctrl_ex;


    //WIRE MEM
    wire    [31:0]  ALUresult_mem,
                    regdata2final_mem,
                    writedata_mem,
                    dataread_mem;
    wire    [4:0]   registerrd_mem;
    wire            regwrite_mem,
                    memtoreg_mem,
                    memwrite_mem,
                    memread_mem;

    //WIRE WB
    wire            regwrite_wb,
                    memtoreg_wb,
                    memread_wb;
    wire    [4:0]   registerrd_wb;
    wire    [31:0]  writeback_wb,
                    memdata_wb,
                    ALUresult_wb;

    //WIRE FORWARDING
    wire    [1:0]   forwardingeqin1,
                    forwardingeqin2;
    wire            memSrc;
    wire    [1:0]   forwardingALUin1,
                    forwardingALUin2;

    //WIRE Hazard
    wire            stall, // =1 when hazard 
                    IF_flush_id;

// blocks

    // in IF STAGE 
    PC PC_(
        .reset(reset),
        .clk(clk),
        .stall(~(pc_write_hazard & pc_write_2 & (pc_write_3_id & pc_write_3_ex))), // when hazard, pc_write_hazard=0 // stall=0, write 
        .pcin(pc_in_if),
        .pcout(pc_out_if)
        );
    InstrMem InsrtMem_(
        .reset(reset),
        .address(pc_out_if),
        .instruction(instruction_if)
        );
    assign pcplus4_if = pc_out_if + 4;
    assign pc_in_if = (branchjump_if) ? branchjumpaddress_if : pcplus4_if; // MUX: decide which is pcin

    // IF/ID Reg       
    register #(64) IF_ID(
        .write(if_id_write_hazard & pc_write_2 & (pc_write_3_id & pc_write_3_ex)), //  when hazard if_id_write_hazard = 0 
        .flush(IF_flush_id), // if need to insert bubble or fulsh, zero all (?)
        .clock(clk),
        .Din({pcplus4_if, instruction_if}),
        .Dout({pcplus4_id, instruction_id})
    );

    // in ID STAGE
        // wires 
    assign op_id = instruction_id[31:26];
    assign rs_id = instruction_id[25:21];
    assign rt_id = instruction_id[20:16];
    assign rd_id = instruction_id[15:11];
    assign immi_id = instruction_id[15:0];
    assign jump_inst_id = instruction_id[25:0];


    RegFile M4(
        .clk(clk),
        .reg_write(regwrite_wb),
        .read_reg1(rs_id),
        .read_reg2(rt_id),
        .write_reg(registerrd_wb),
        .Input_Readreg(Input_Readreg),
        .write_data(writeback_wb),
        .read_data1(regdata1_id),
        .read_data2(regdata2_id),
        .RegOut(RegOut)
    );
    
    
    MUX4_2 firstComparatorMUX(
        .control(forwardingeqin1),
        .in1(regdata1_id),
        .in2(writeback_wb),
        .in3(ALUresult_mem),
        .out(eq_mux1_id)
    );
    
   MUX4_2 secondComparatorMUX(
        .control(forwardingeqin2),
        .in1(regdata2_id),
        .in2(writeback_wb),
        .in3(ALUresult_mem),
        .out(eq_mux2_id)
    );


        // in top.v
    comparator com_id_(
        .reset(reset),
        .I1(eq_mux1_id),
        .I2(eq_mux2_id),
        .res(com_res_id)
    );
    control control_(
        .inst(op_id),
        .equal(com_res_id),
        .IFflush(IF_flush_id),
        .regdst(regdst_id),
        .jump(jump),
        .branch(beq_id), // only beq, no bne
        .memread(memread_id),
        .memtoreg(memtoreg_id),
        .aluop(ALUop_id),
        .memwrite(memwrite_id),
        .alusrc(ALUsrc_id),
        .regwrite(regwrite_id)
    );


    SignExtend signextend_(
        .imm_in(immi_id),
        .out(imm_signEx_id)
    );

    assign branchaddress_id = pcplus4_id+(imm_signEx_id<<2);
    assign jumpaddress_id = {pcplus4_id[31:28], jump_inst_id, 2'b00};

            // for IF 
    assign branchjump_if = (beq_id & com_res_id) || jump;
    assign branchjumpaddress_if = (beq_id) ? branchaddress_id : jumpaddress_id;
    //assign {regdst_id1, ALUsrc_id1, regwrite_id1, memtoreg_id1, memwrite_id1, memread_id1, ALUop_id1, ALUsrc_id1, 
     //      regdata1_id1, regdata2_id1, imm_signEx_id1, rs_id1, rt_id1, rd_id1} = (stall == 1) ? 117'b0 : {regdst_id, ALUsrc_id, regwrite_id, memtoreg_id, memwrite_id, memread_id, ALUop_id, ALUsrc_id, 
     //      regdata1_id, regdata2_id, imm_signEx_id, rs_id, rt_id, rd_id};

    // assign IF_flush_id = branchjump_if && (!stall); 
    // IF_flush_id: as control output, take care of all the branch / jump 
    // need to consider flush and stall happens same time? 

    // ID/EX Reg 
        // ID/EX: Din={rs_id, rt_id, rd_id, regdata1final_id, regdata2final_id, imm_signEx_id, memread_id, memtoreg_id,  ALUop_id,memwrite_id, ALUsrc_id, regwrite_id,} 122 + regdst_id,
    register #(120) ID_EX(
        .write(1'b1), 
        .flush(stall | ~pc_write_2 | ~(pc_write_3_id & pc_write_3_ex)),
        .clock(clk),
        .Din({regdst_id, ALUsrc_id, regwrite_id, memtoreg_id, memwrite_id, memread_id, ALUop_id, ALUsrc_id, 
           regdata1_id, regdata2_id, imm_signEx_id, rs_id, rt_id, rd_id}),
        .Dout({regdst_ex, ALUsrc_ex, regwrite_ex, memtoreg_ex, memwrite_ex, memread_ex, ALUop_ex, ALUsrc_ex,
            regdata1final_ex, regdata2final_ex, immi_signEx_ex, rs_ex, rt_ex, rd_ex})
    );
    
    register #(1) ID_EX_pc_write(
        .write(1'b1), 
        .flush(1'b0),
        .clock(clk),
        .Din(pc_write_3_id),
        .Dout(pc_write_3_ex)
    );

    // in EX STAGE
    assign registerrd_ex = (regdst_ex) ? rd_ex : rt_ex; // bottom MUX for Rt/Rd
    assign func_ex = immi_signEx_ex[5:0]; // used for ALU control 
    assign ALUin2final_ex = (ALUsrc_ex) ? immi_signEx_ex : ALUin2_ex;

    MUX4_2 firstALUMUX(
        .control(forwardingALUin1),
        .in1(regdata1final_ex),
        .in2(writeback_wb),
        .in3(ALUresult_mem),
        .out(ALUin1final_ex)
    );
    MUX4_2 secondALUMUX(
        .control(forwardingALUin2),
        .in1(regdata2final_ex),
        .in2(writeback_wb),
        .in3(ALUresult_mem),
        .out(ALUin2_ex)
    );


    ALUControl ALUcontrol_( // assume 2'b11 as and 
        .func(func_ex),
        .op(ALUop_ex),
        .ctrl(ALUctrl_ex)
    );
    ALU ALU_(
        .ALU_control(ALUctrl_ex),
        .a(ALUin1final_ex),
        .b(ALUin2final_ex),
        .zero(exzero),
        .result(ALUresult_ex)
    );

    // EX/MEM Reg 
        // Din={forwardB=regdata2final_ex, aluresult=ALUresult_ex, dst=registerrd_ex, memread=memread_ex, memtoreg=memtoreg_ex, memwrite, regwrite}
    register #(73) EX_MEM(
        .write(1'b1), 
        .flush(1'b0),
        .clock(clk),
        .Din({registerrd_ex, ALUin2_ex, ALUresult_ex, memread_ex,memwrite_ex, memtoreg_ex, regwrite_ex}),
        .Dout({registerrd_mem, regdata2final_mem, ALUresult_mem, memread_mem, memwrite_mem, memtoreg_mem, regwrite_mem})
    );


    // in MEM STAGE 
    assign writedata_mem = (memSrc) ? writeback_wb : regdata2final_mem;

    DataMemory datamem_(
        .clk(clk),
        .mem_read(memread_mem),
        .mem_write(memwrite_mem),
        .address(ALUresult_mem),
        .data_write(writedata_mem),
        .data_read(dataread_mem)
    );

    // MEM/WB Reg 
    register #(71) MEM_WB(
        .write(1'b1), 
        .flush(1'b0),
        .clock(clk),
        .Din({dataread_mem, ALUresult_mem, memtoreg_mem, regwrite_mem, registerrd_mem}),
        .Dout({memdata_wb, ALUresult_wb, memtoreg_wb, regwrite_wb, registerrd_wb})
    );


    // in WB STAGE
    assign writeback_wb = (memtoreg_wb) ? memdata_wb : ALUresult_wb;


    // Forwarding 
    ForwardingUnit forward_(
        .IDEXRs(rs_ex),
        .IDEXRt(rt_ex),
        .IDEXRst(registerrd_ex), 
        .EXMEMDst(registerrd_mem),
        .MEMWBDst(registerrd_wb),
        .IFIDRs(rs_id),
        .IFIDRt(rt_id),


        .MEMWBMemRead(memread_wb),
        .MEMWBRegWrite(regwrite_wb),
        .EXMEMRegWrite(regwrite_mem),
        .EXMEMMemWrite(memwrite_mem),
        .IFIDBeq(beq_id),

        .AluA(forwardingALUin1),
        .AluB(forwardingALUin2),
        .EqA(forwardingeqin1),
        .EqB(forwardingeqin2),
        .MemSrc(memSrc)

    );


    //Hazard of lw, in "top.v"
    hazarddetection hazard_(
        .reset(reset),
        .rs_id(rs_id),
        .rt_id(rt_id),
        .rt_ex(rt_ex), 
        .rd_ex(rd_ex),
        .regWrite_ex(regwrite_ex),
        .IDEXmemread(memread_ex),
        .IFIDwrite(if_id_write_hazard),
        .PCwrite(pc_write_hazard),
        .hazard(stall), // hazard=1 when hazard, 
        .PCwrite2(pc_write_2), // pc__write2=0,if beq data hazard 
        .PCwrite3(pc_write_3_id),
        .beq_id(beq_id)
    );
    
     assign PCout = pc_out_if;


endmodule

