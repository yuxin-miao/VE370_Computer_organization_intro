`ifndef MODULE_PC
`define MODULE_PC
`timescale 1ns / 1ps

module PC (
    input               clk,
                        reset,
    input       [31:0]  in,
    output reg  [31:0]  out
);
initial begin
    out <= 32'b0;
end

    always @ (posedge clk) begin
        if (reset) begin
            out <= 32'b0;
        end
        else 
            out <= in;
    end

endmodule // PC

`endif
