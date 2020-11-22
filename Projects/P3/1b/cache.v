// (1)(b) write through + 2-way associative
// 10 bits address: 5'b Tag + 1'b Index + 2'b WordOffset+ 2'b ByteOffset 
module cache(
    input reg read_write,
    input reg [9:0] Address,
    input reg [31:0] write_data,
    output reg [31:0] read_data,
    output reg miss_hit
    );
    // regs for cache stuctures 
    reg [4:0] tag[3:0];
    reg index;
    reg [31:0] data[3:0][3:0]; // first determine block (in set) in cache, second determine word in block 
    reg valid[3:0];
    reg recent[3:0]; // record each block whether has been recently called 
                      // in one set, only one block could have been set to 1 
                      // so every time change the value in recent, will change two 

    // regs for block
    reg b1_index;
    reg b2_index;

    // regs for output
    // reg [31:0] read_data_cahce;

    // wires for connection to mem 
    wire [127:0] read_data_from_mem;

    // initialize 
    integer i, j;
    initial begin 
        for (i = 0; i < 4; i = i + 1) begin
            tag[i] = 5'b0; // set all tags as 0
            valid[i] = 1'b0; // whether valid
            recent[i] = 1'b0; // whether recent call
            for (j = 0; j < 4; j = j + 1) begin
                data[i][j] = 32'b0; // set each word in cache as 0
            end
        end
    end

    // read from mem, although data read might not be used
    // write to mem, always needed 
    main mainMemory (
        .read_write(read_write),
        .Address(Address),
        .write_data(write_data),
        .read_data(read_data_from_mem)
    );

    // check whether match in cache 
    
    always @(read_write or Address or write_data) begin
        index = Address[4];
        b1_index = {index, 1'b0};
        b2_index = {index, 1'b1};
    // if hit
        if ( (valid[b1_index] == 1 & tag[b1_index] == Address[9:5]) | (valid[b2_index] == 1 & tag[b2_index] == Address[9:5])) begin

            miss_hit = 1'b1; 
            if (read_write == 1'b0) begin
                // read from cache, check which block 
                if (tag[b1_index] == Address[9:5]) begin
                    recent[b1_index] = 1'b1; 
                    recent[b2_index] = 1'b0;
                    read_data = data[b1_index][Address[3:2]];
                end
                else begin
                    recent[b1_index] = 1'b0; 
                    recent[b2_index] = 1'b1;
                    read_data = data[b2_index][Address[3:2]];
                end
            end
            else begin
                // write to cache 
                if (tag[b1_index] == Address[9:5]) begin
                    recent[b1_index] = 1'b1; 
                    recent[b2_index] = 1'b0;
                    data[b1_index][Address[3:2]] = write_data;
                end
                else begin
                    recent[b1_index] = 1'b0; 
                    recent[b2_index] = 1'b1;
                    data[b2_index][Address[3:2]] = write_data;
                end
            end
        end

    // if miss, then read from memory 
        else begin
            miss_hit = 1'b0; 

        /* code used to replace the proper block in this set when miss happens (empty or not / based on LRU)*/
        /* read_data is also assigned when cache_data_block is replaced*/

            // check whether the set is full 
            if (valid[b1_index] == 1'b1 & valid[b2_index] == 1'b1) begin
            // the set is full, check which recently called 
                if (recent[b1_index] == 1'b0) begin 
                    // recent valided block is not b1, replace b1
                    tag[b1_index] = Address[9:5];
                    recent[b1_index] = 1'b1; 
                    recent[b2_index] = 1'b0;
                    data[b1_index][0] = read_data_from_mem[31:0];
                    data[b1_index][1] = read_data_from_mem[63:32];
                    data[b1_index][2] = read_data_from_mem[95:64];
                    data[b1_index][3] = read_data_from_mem[127:96];
                    read_data = data[b1_index][Address[3:2]];
                end
                else begin
                    // recent valided block is b1, replace b2
                    tag[b2_index] = Address[9:5];
                    recent[b1_index] = 1'b0; 
                    recent[b2_index] = 1'b1;
                    data[b2_index][0] = read_data_from_mem[31:0];
                    data[b2_index][1] = read_data_from_mem[63:32];
                    data[b2_index][2] = read_data_from_mem[95:64];
                    data[b2_index][3] = read_data_from_mem[127:96];
                    read_data = data[b2_index][Address[3:2]];
                end

            end
            // the set is not full, check which empty 
            else if (valid[b1_index] == 1'b0) begin
                // if the first block in this set does not been valided 
                valid[b1_index] = 1'b1;
                tag[b1_index] = Address[9:5];
                recent[b1_index] = 1'b1; 
                recent[b2_index] = 1'b0;
                data[b1_index][0] = read_data_from_mem[31:0];
                data[b1_index][1] = read_data_from_mem[63:32];
                data[b1_index][2] = read_data_from_mem[95:64];
                data[b1_index][3] = read_data_from_mem[127:96];
                read_data = data[b1_index][Address[3:2]];
            end
            else if (valid[b2_index] == 1'b0) begin
                valid[b2_index] = 1'b1;
                tag[b2_index] = Address[9:5];
                recent[b1_index] = 1'b0; 
                recent[b2_index] = 1'b1;
                data[b2_index][0] = read_data_from_mem[31:0];
                data[b2_index][1] = read_data_from_mem[63:32];
                data[b2_index][2] = read_data_from_mem[95:64];
                data[b2_index][3] = read_data_from_mem[127:96];
                read_data = data[b2_index][Address[3:2]];
            end

            // if need to write, replace 
            if (read_write == 1'b1) begin
                if (tag[b1_index] == Address[9:5]) begin
                    data[b1_index][Address[3:2]] = write_data;
                end
                else begin
                    data[b2_index][Address[3:2]] = write_data;
                end
            end
        end
    end

endmodule


