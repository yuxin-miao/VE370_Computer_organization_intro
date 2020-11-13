`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2020/10/31 21:05:57
// Design Name: 
// Module Name: ForwardingUnit
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


module ForwardingUnit(
    input[4:0] IDEXRs,IDEXRt,IDEXRst,EXMEMDst,MEMWBDst,IFIDRs,IFIDRt,
    input MEMWBMemRead,MEMWBRegWrite,EXMEMRegWrite,EXMEMMemWrite,IFIDBeq,
    output reg MemSrc,
    output reg[1:0] AluA,AluB,EqA,EqB
        );
        
    initial begin
        AluA = 2'b00;
        AluB = 2'b00;
        EqA = 2'b00;
        EqB = 2'b00;
        MemSrc = 1'b0;
    end
    
    always @(*) begin
        if(EXMEMRegWrite && EXMEMDst && EXMEMDst == IDEXRs) AluA = 2'b10;
        else if(MEMWBRegWrite && MEMWBDst && MEMWBDst == IDEXRs) AluA = 2'b01;
        else AluA = 2'b00;
        
        if(EXMEMRegWrite && EXMEMDst && EXMEMDst == IDEXRt) AluB = 2'b10;
        else if(MEMWBRegWrite && MEMWBDst && MEMWBDst == IDEXRt) AluB = 2'b01;
        else AluB = 2'b00;
        
        if(MEMWBDst == EXMEMDst && MEMWBMemRead && EXMEMMemWrite) MemSrc = 1'b1;
        else MemSrc = 1'b0;
        
        if((IFIDBeq) && EXMEMRegWrite && EXMEMDst == IFIDRs) EqA = 2'b10;
        else if((IFIDBeq) && MEMWBRegWrite && MEMWBDst == IFIDRs) EqA = 2'b01;
        else EqA = 2'b00;
        
        if((IFIDBeq) && EXMEMRegWrite && EXMEMDst == IFIDRt) EqB = 2'b10;
        else if((IFIDBeq) && MEMWBRegWrite && MEMWBDst == IFIDRt) EqB = 2'b01;
        else EqB = 2'b00;
        
    end
endmodule
