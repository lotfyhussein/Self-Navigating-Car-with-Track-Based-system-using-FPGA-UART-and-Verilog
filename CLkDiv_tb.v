// file: CLkDiv_tb.v
// author: @amrgouhar
// Testbench for CLkDiv

`timescale 1ns/1ns

module CLkDiv_tb;

	//Inputs
	reg inputclock;
	reg rst;


	//Outputs
	wire outputclock;


	//Instantiation of Unit Under Test
	CLkDiv uut (
		.inputclock(inputclock),
		.rst(rst),
		.outputclock(outputclock)
	);

always #5 inputclock = ~ inputclock;
	initial begin
	//Inputs initialization
		inputclock = 0;
		rst = 1;
		#10 rst = 0;


	//Wait for the reset
		#100;

	end

endmodule