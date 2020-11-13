`timescale 1ns / 1ps

module Control (
    input [5:0] opcode,
    output reg regdst, jump, beq, bne, memread, memtoreg, memwrite, alusrc, regwrite,
    output reg [1:0] aluop
);    initial begin
        regdst = 1'b0;
        jump = 1'b0;
        beq = 1'b0;
        bne = 1'b0;
        memread = 1'b0;
        memtoreg = 1'b0;
        memwrite = 1'b0;
        alusrc = 1'b0;
        regwrite = 1'b0;
        aluop = 2'b00;
    end
    
    always@(opcode)
        case(opcode)
            6'b000000: begin // R-type
                regdst = 1'b1;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b0;
                regwrite = 1'b1;
                aluop = 2'b10;
                end
           6'b001000: begin // addi I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b1;
                regwrite = 1'b1;
                aluop = 2'b00; // not given, set 00 to add 
                end
           6'b001100: begin // andi, I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b1;
                regwrite = 1'b1;
                aluop = 2'b11; // not given, set 11 
                end          
           6'b100011: begin // lw, I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b1;
                memtoreg = 1'b1;
                memwrite = 1'b0;
                alusrc = 1'b1;
                regwrite = 1'b1;
                aluop = 2'b00; // to add 
                end          
           6'b101011: begin // sw, I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b1;
                alusrc = 1'b1;
                regwrite = 1'b0;
                aluop = 2'b00; // to add 
                end   
            6'b000100: begin // beq, I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b1;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b0;
                regwrite = 1'b0;
                aluop = 2'b01;  
                end    
            6'b000100: begin // bne, I-type
                regdst = 1'b0;
                jump = 1'b0;
                beq = 1'b0;
                bne = 1'b1;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b0;
                regwrite = 1'b0;
                aluop = 2'b01;  
                end         
            6'b000100: begin // j, J-type
                regdst = 1'b0;
                jump = 1'b1;
                beq = 1'b0;
                bne = 1'b0;
                memread = 1'b0;
                memtoreg = 1'b0;
                memwrite = 1'b0;
                alusrc = 1'b0;
                regwrite = 1'b0;
                aluop = 2'b10;  
                end                                          
          default: ; 

    endcase

endmodule