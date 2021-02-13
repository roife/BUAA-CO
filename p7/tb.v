`timescale 1ns / 1ps

module tb;
	reg clk;
	reg reset;

	wire [31:0] addr;

	mips uut (
		.clk(clk),
		.reset(reset),
		.interrupt(1'b0),
		.addr(addr)
	);

	initial begin
		clk = 0;
		reset = 1;
		#20 reset = 0;
	end
   always #2 clk = ~clk;
endmodule

