module DataMemory (
    input clk, 
    input MemRead, 
    input MemWrite,
    input [31:0] addr, 
    input [31:0] write_data,
    output [31:0] read_data
);

    parameter width = 8;
    parameter size = 2**width; // how much memory
    reg [31:0] mem[0:size - 1];
    wire [width - 1:0] mem_addr = addr[8:1];
    integer i;
    initial begin
        for (i = 0; i < size; i = i + 1)
            mem[i] <= 32'b0; // initialize the memory 
    end
    always @ (posedge clk) begin
        if (MemWrite)
            mem[mem_addr] = write_data;
    end
    assign read_data = (MemRead == 1'b1) ? mem[mem_addr] : 32'b0;

endmodule 

