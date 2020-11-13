`timescale 1ns / 1ps

module MUX4_2(
    input [1:0] control,
    input [31:0] in1,
    input [31:0] in2,
    input [31:0] in3,
    output reg [31:0] out
    );

    always @(*) begin
        case(control)
        2'b00:  out = in1;
        2'b01:  out = in2;
        2'b10:  out = in3;
        default:  out = in1;
        endcase
    end
endmodule
