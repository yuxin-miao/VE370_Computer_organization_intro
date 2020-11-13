`timescale 1ns / 1ps

module PC(
    input       reset, clk,stall,
    input       [31:0]  pcin,
    output reg  [31:0]  pcout
    );
    
    always @ (posedge clk) begin
        if (reset) 
            pcout <= 32'b0;
        else if (!stall)
            pcout <= pcin;
    end
    
endmodule
