`timescale 1ns / 1ps
`include "single_cycle.v"

module single_cycle_tb;

    integer i = 0;

	// Inputs
	reg clk, reset;

	// Instantiate the Unit Under Test (UUT)
	single_cycle uut (
		.clk(clk),
        .reset(reset)
	);

	initial begin
		// Initialize Inputs
		#0 clk = 0; reset = 1;
        #60 reset = 0; 
        $dumpfile("single_cycle.vcd");
        $dumpvars(1, uut);
        $display("Texual result of single cycle:");
        $display("==========================================================");
        #4000;
        $stop;
	end

    always #50 begin
        i = i + 50;
        $display("Time: %d, CLK = %d, PC = 0x%H", i, clk, uut.pc_out);
        $display("[$s0] = 0x%H, [$s1] = 0x%H, [$s2] = 0x%H", uut.registers.regs[16], uut.registers.regs[17], uut.registers.regs[18]);
        $display("[$s3] = 0x%H, [$s4] = 0x%H, [$s5] = 0x%H", uut.registers.regs[19], uut.registers.regs[20], uut.registers.regs[21]);
        $display("[$s6] = 0x%H, [$s7] = 0x%H, [$t0] = 0x%H", uut.registers.regs[22], uut.registers.regs[23], uut.registers.regs[8]);
        $display("[$t1] = 0x%H, [$t2] = 0x%H, [$t3] = 0x%H", uut.registers.regs[9], uut.registers.regs[10], uut.registers.regs[11]);
        $display("----------------------------------------------------------");
        clk = ~clk;
        i = i + 50;
    end

endmodule
