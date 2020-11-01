`timescale 1ns / 1ps

module PC(
    input       clk,stall,
    input       [31:0]  pcin,
    output reg  [31:0]  pcout
    );
    
    initial begin
        out = 32'b0; //initialize PC
    end
    
    always @ (posedge clk) begin
        if (!stall)
            out <= in;
    end
    
endmodule
