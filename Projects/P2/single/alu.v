`timescale 1ns / 1ps

module ALU(
    input [31:0] a, b,
    input [3:0] alu_control,
    output reg [31:0] Result,
    output zero);

always@(*)
begin
    case (alu_control)
    4'b0000: Result = a&b; // and
    4'b0001: Result = a|b; // or
    4'b0010: // add
        Result = a + b;
    4'b0110: // sub
        Result = a - b;
    4'b0111: // slt
        begin
        if (a < b) Result = 32'b1;
        else Result = 32'b0;
        end
    4'b1100:  Result = ~(a|b); // nor 
    endcase
end
assign zero = (Result == 32'b0) ? 1'b1 : 1'b0;
endmodule
