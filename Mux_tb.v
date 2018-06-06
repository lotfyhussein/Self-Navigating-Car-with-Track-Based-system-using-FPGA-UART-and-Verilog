// file: Mux_tb.v
// author: @lotfyhussein
// Testbench for Mux

`timescale 1ns/1ns

module Mux_tb;

	//Inputs
	reg [1: 0] aa;
	reg [1: 0] bb;
	reg [1: 0] cc;
	reg [1: 0] dd;
	reg [1: 0] sel;


	//Outputs
	wire [1: 0] out;


	//Instantiation of Unit Under Test
	Mux uut (
		.aa(aa),
		.bb(bb),
		.cc(cc),
		.dd(dd),
		.sel(sel),
		.out(out)
	);

integer a_i, b_i, c_i, d_i;
	initial begin
	//Inputs initialization
		aa = 0;
		bb = 0;
		cc = 0;
		dd = 0;
		sel = 2'b10;

 for( a_i =0; a_i < 4; a_i = a_i + 1)
    for( b_i =0; b_i < 4; b_i = b_i + 1) 
     for( c_i =0; c_i < 4; c_i = c_i + 1)
    for( d_i =0; d_i< 4; d_i = d_i + 1) begin
    #5 dd = d_i;
    #5 cc = c_i;
  #5  bb = b_i;
#5    aa = a_i;
    
end

	end

endmodule