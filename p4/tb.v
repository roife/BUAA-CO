`timescale 1ns / 1ps

module tb;
	reg clk;
	reg reset;

	mips uut (
		.clk(clk),
		.reset(reset)
	);

	initial begin
	        $dumpfile("tb.vcd");
                $dumpvars(0,tb);

		clk = 0;
		reset = 1;

		#10;
		reset = 0;
	end

	always #5 clk=~clk;

endmodule

