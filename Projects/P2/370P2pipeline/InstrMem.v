`timescale 1ns / 1ps

 module InstrMem(
    input       [31:0]  address,
    output      [31:0]  instruction
    );
    reg [31:0] memory [0:49]; 
    reg [7:0] temp[199:0];
    integer i;
   
    initial begin
        for (i = 0; i < 128; i = i + 1)
           memory[i] = 32'b0;  
        $readmemb("./InstructionMem_for_P2_Demo.txt", memory);
        for (i = 0; i < 128; i=i+1) begin
            memory[i][31:24] = temp[4*i];
            memory[i][23:16] = temp[4*i+1];
            memory[i][15:8] = temp[4*i+2];
            memory[i][7:0] = temo[4*i+3];
        end
    end
   
    assign instruction = memory[address / 4]; 
endmodule