`timescale 1ns / 1ps

//module RegFile(
//    input reg_write, clk,
//    input [4:0] read_reg1, read_reg2, write_reg, Input_Readreg,
//    input [31:0] write_data,
//    output reg [31:0] read_data1, read_data2, RegOut
//    );
//    reg [31:0] file [0:31];
//    integer i;
    
//    initial begin
//        for (i = 0; i < 32; i = i + 1)
//            file[i] = 32'b0; 
//    end
    
//    always @(*) begin
//        if (reg_write == 1 && write_reg !=0)
//            file[write_reg] = write_data;
//    end
//    always @(negedge clk) begin
////        if (reg_write == 1 && write_reg !=0)
////            file[write_reg] = write_data;
//        read_data1 = file[read_reg1];
//        read_data2 = file[read_reg2];
//        RegOut = file[Input_Readreg];
//    end
//endmodule


module RegFile(
    input clk, reg_write,
    input [4:0] read_reg1, read_reg2, write_reg, Input_Readreg,
    input [31:0] write_data,
    output [31:0] read_data1, read_data2, RegOut
    );
    reg [31:0] file [0:31];
    integer i;
    
    initial begin
        for (i = 0; i < 32; i = i + 1)
            file[i] = 32'b0;  // initialize the registers
    end
    
    assign read_data1 = file[read_reg1];
    assign read_data2 = file[read_reg2];
    assign RegOut = file[Input_Readreg];
    always @(negedge clk) begin
        if (reg_write == 1)
            file[write_reg] <= write_data;
    end
endmodule
