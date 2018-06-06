// file: Motor.v
// author: @amrgouhar

`timescale 1ns/1ns

module Motor(clkmotor, pulseM);
parameter n= 2;
input clkmotor;
output reg pulseM = 1'b1;
reg [2:0] counter = 3'b000;

always @ (posedge clkmotor) begin
if(counter == 4'b111)
    counter = 4'b000;
else
    counter = counter + 1'b1;

if(counter < n)
    pulseM = 1'b1;
else
    pulseM = 1'b0;
end
endmodule