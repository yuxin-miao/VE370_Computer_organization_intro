`timescale 1ns / 1ps

module ALUControl (
    input [5:0] func,
    input [1:0] ALUOp,
    output reg [3:0] alu_control);

always @(ALUOp or func)
    case(ALUOp)
    2'b00: alu_control = 4'b0010; //add
    2'b01: alu_control = 4'b0110; // sub
    2'b10: begin
        case (func)
        6'b100000: alu_control = 4'b0010; //add
        6'b100010: alu_control = 4'b0110; // sub
        6'b100100: alu_control = 4'b0000; //and
        6'b100101: alu_control = 4'b0001; //or
        6'b101010: alu_control = 4'b0111; // slt
        default: alu_control = 4'b0000;
        endcase
    end
    default: alu_control = 4'b0000;
    endcase
    
endmodule
    
