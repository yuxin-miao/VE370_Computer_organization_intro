module main (
    input read_write, 
    input [9:0] Address, 
    input [127:0] write_data, 
    output [127:0] read_data
    );

    reg [31:0] memory[255:0];
    
    initial begin  // initialize the memory 
    
    end

    always @(read_write) begin  
        // when need to write
        if (read_write == 1'b1) begin
            memory[{Address[9:4], 2'b00}] = write_data[127:96];
			memory[{Address[9:4], 2'b01}] = write_data[95:64];
			memory[{Address[9:4], 2'b10}] = write_data[63:32];
			memory[{Address[9:4], 2'b11}] = write_data[31:0];
        end

    end

    // Assign each word to read_data
    read_data[31:0] = memory[{Address[9:4], 2'b00}];
    read_data[63:32] = memory[{Address[9:4], 2'b01}];
    read_data[95:64] = memory[{Address[9:4], 2'b10}];
    read_data[127:96] = memory[{Address[9:4], 2'b11}];
endmodule 