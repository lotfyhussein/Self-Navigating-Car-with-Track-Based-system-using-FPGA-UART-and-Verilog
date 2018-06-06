// file: UltraSonic.v
// author: @amrgouhar

`timescale 1ns/1ns


module UltraSonic ( echo, trig , clk, US, rst);
output reg trig;
input echo;
input clk, rst;
output reg [1:0]US;                // to choose the path
wire clkdivid;
reg [12:0] countertrig;
reg[31:0] counterecho;                         //to check if we turned right before;
reg [31:0] temp;
reg[31:0] timer;
reg right;
reg [31:0] counterdelayer;
CLkDiv #(200000, 50000000) bit0(clk, clkdivid,rst);


always @(posedge clkdivid) begin
if(rst) begin
countertrig <= 13'b0;
counterecho <= 32'b0;
temp <= 32'b0;
timer <=32'b0;
right <= 1'b0;
counterdelayer <= 32'b0;
end

if(countertrig < 13'd3 && US != 2'b10 && US != 2'b01)                         // to send signal to trigger
    trig <= 1'b1;
else
    trig <= 1'b0;   
    
if(right == 1'b1)
    counterdelayer <= counterdelayer + 1'b1;
else
    counterdelayer <= 32'b0;
    
    
if(countertrig == 13'd7644 )                  // count for trigger pulse
    countertrig <= 13'b0;
else
    countertrig <= countertrig + 1'b1;

if(echo == 1'b1)                             // count for echo pulse to calculate the distance;
    counterecho <= counterecho +1'b1;
else begin 
    if(counterecho != 32'b0)   
	    temp <= counterecho;
    if(temp == counterecho)
		counterecho <= 32'b0;
    if(temp < 32'd116)
        US <= 2'b00;
    else begin
        US <= 2'b11;
    end
    end
    
if(counterdelayer == 32'd16000)
    right <= 1'b0;


if(US == 2'b01 || US == 2'b10)
    timer <= timer + 1'b1;
else
    timer <= 32'b0;
    
    
if(US == 2'b00)
    if(right == 1'b0) begin
        US <= 2'b01;
        right <=1'b1;
        temp <= 32'd3000;
        end
    else begin
        US <= 2'b10;
        temp <= 32'd3000;
        end
if(US == 2'b01) begin
     
    if(timer == 32'd400000)
        US <= 2'b11;
    end
    
if(US == 2'b10)
    if(timer == 32'd800000) begin
        US <= 2'b11;
         right <= 1'b0;
        end
end

endmodule

