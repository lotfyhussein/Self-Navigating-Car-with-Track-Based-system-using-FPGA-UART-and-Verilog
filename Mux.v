// file: Mux.v
// author: @lotfyhussein


`timescale 1ns/1ns
module Mux(aa, bb, cc, dd, sel, out);
parameter n = 2;
input [n-1:0] aa, bb, cc, dd;
input [1:0]sel;
output reg [n-1:0] out;
always@* begin
if (sel == 2'b00)
    out = aa;
  else if (sel == 2'b01)
    out = bb;
  else  if (sel == 2'b10)
    out = cc;
  else  if (sel == 2'b11)
     out = dd;
     
     end
endmodule
