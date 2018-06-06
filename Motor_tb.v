// file: Motor_tb.v
// author: @amrgouhar
// Testbench for Motor

`timescale 1ns/1ns

module Motor_tb;

	//Inputs
	reg clkmotor;


	//Outputs
	wire pulseM;


	//Instantiation of Unit Under Test
	Motor uut (
		.clkmotor(clkmotor),
		.pulseM(pulseM)
	);



always #5 clkmotor = ~clkmotor; 
	initial begin
	//Inputs initialization
		clkmotor = 0;


	//Wait for the reset
		#10000;

	end

endmodule