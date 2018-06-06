`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:25:35 12/08/2016 
// Design Name: 
// Module Name:    CLkDiv 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module CLkDiv(inputclock, outputclock, rst);
parameter n = 1;
parameter c =50;
input inputclock, rst;
output reg outputclock;
reg [31:0] counter;

always @  (posedge inputclock) begin 
if (rst) begin
outputclock <= 1'b0;
counter <= 32'b0;
end
else begin 
if (counter == (c/n)) 
counter <= 32'b0;
else counter <= counter + 1'b1;
if (counter == (c/n))
     outputclock <= 1'b0;
else
    if(counter == (c/(2 * n)))
        outputclock <= 1'b1;
end
end
endmodule



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

module PC(clock, addrout, rst);
input  clock, rst;
output reg [7:0] addrout;

always @ (posedge clock) begin
if (rst)
    addrout <= 8'd0;
else 
    addrout <= addrout + 1'b1;
end

endmodule


module UltraSonic ( echo, trig , clk, US, rst, right);
output reg trig;
input echo;
input clk, rst;
output reg [1:0]US;                // to choose the path
wire clkdivid;
reg [12:0] countertrig;
reg[31:0] counterecho;                         //to check if we turned right before;
reg [31:0] temp;
reg[31:0] timer;
output reg right;
reg [31:0] counterdelayer;
CLkDiv #(200000, 50000000) bit0(clk, clkdivid,rst);


always @(posedge clkdivid) begin // stop = 00, left = 01, right = 10, front = 11
if(rst) begin
countertrig <= 13'b0;
counterecho <= 32'b0;
temp <= 32'd250;
timer <=32'd0;
right <= 1'b0;
counterdelayer <= 32'b0;
US <= 2'b00;
end
else begin
if(countertrig < 13'd3) //  && US != 2'b10 && US != 2'b01      // to send signal to trigger
    trig <= 1'b1;
else
    trig <= 1'b0;   
    
 if(US == 2'b11 && right == 1)
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
	
    if(temp > 32'd200 && US != 2'b10 && US != 2'b01) begin
        US <= 2'b11;
		  if(counterdelayer == 32'd16000) right <= 1'b0;
		  end
    else begin
	 if (timer != 32'd0 && US == 2'b11) timer <=32'd0;
	 if (right == 0) begin
		
		  US <= 2'b10;
		  timer <= timer + 1'b1;
		  if (timer == 32'd200000) begin US <= 2'b11; right <= 1; timer <=32'd0; end
		  end
	else if (right == 1) begin 
			US <= 2'b01;
		  timer <= timer + 1'b1;
		  if (timer == 32'd400000) begin US <= 2'b11; right <= 0; timer <=32'd0; end
		  end
    end
    end
/*	 

if(counterdelayer == 32'd16000)
    right <= 1'b0;


if(US == 2'b01 || US == 2'b10)
    timer <= timer + 1'b1;
else
    timer <= 32'b0;
 */   
   /* 
if(US == 2'b00) // stop
    if(right == 1'b0) begin
        US <= 2'b10; // right
        right <=1'b1;
        end
    else
        US <= 2'b01; // left */
      /* 
if(US == 2'b10) begin // right
    
    if(timer == 32'd400000)
        US <= 2'b11;
    end*/
    /*
if(US == 2'b01)
    if(timer == 32'd800000) begin // left
        US <= 2'b11;
         right <= 1'b0;
        end*/
end
end
endmodule




module Car(clk, rst, Direction, mst, mt, dt, mct);
parameter n = 2000;
output mst, mt;
output[1:0] dt;
output[3:0] mct;
output [1:0] Direction;
wire [3:0] Motorclk;
input clk, rst;
wire m;
wire [7:0] addrout;
reg [31:0]counter;
reg start;
wire  MotorStop;
 PC  coco(start, addrout, rst);
//wire  M1, M2;    //M1 left wheel , M2 right wheel;
//CLkDiv #(1, 50000000) bit1(clk, ClkDivided, rst);
RAM motorrre (
  .clka(start), // input clka
  .addra(addrout), // input [7 : 0] addra
  .douta({m,Direction, Motorclk,  MotorStop}) // output [7 : 0] douta
);
 assign mst =MotorStop;
 assign mt =m;
 assign dt =Direction;
  assign mct =Motorclk;
always @ (posedge clk) begin
if (rst) begin // active low push buttons
/*Direction <= 2'd0;
Motorclk <= 4'd0;
MotorStop <= 1'b0;
*/
	counter <= 32'b0;
	start <= 1'b0;
end


else begin
	if((counter == (Motorclk * n)))
		counter <= 32'd0;
	else
		counter <= counter +32'd1; 

if( MotorStop == 1'b1 && (counter == (Motorclk * n)))
start <= 1'b0;
	if(counter == 32'd0)
		start <= 1'b1;
	else
		start <= 1'b0;

end


end
endmodule

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

module MotorDriverPath(clk, M1, M2, rst, mst, mt, dt, mct);
output mst, mt;
output [1:0] dt;
output [3:0] mct;
input clk, rst; 
output  M1, M2;    //M1 left wheel , M2 right wheel;
wire [2:0]Motor; 
wire [1:0] Direction;
wire ClkDivided;

CLkDiv #(2000, 50000000) bit1(clk, ClkDivided, rst);
Car ultra( ClkDivided, rst, Direction, mst, mt, dt, mct);

Motor #(2) motora(ClkDivided, Motor[0]);
Motor #(3) motorb(ClkDivided, Motor[1]);
Motor #(4) motorc(ClkDivided, Motor[2]);
Mux   #(2) Mux1({Motor[1], Motor[1]}, {Motor[0], Motor[0]}, {Motor[2], Motor[2]}, {Motor[2], Motor[0]}, Direction, {M1, M2});

endmodule

module MotorDriverUltra(clk, M1, M2, echo,inputTrigger, rst, outUltraSonic, right2);

input clk, rst; 
output  M1, M2;    //M1 left wheel , M2 right wheel;
wire [2:0]Motor;
output inputTrigger; 
input echo; 
output [1:0] outUltraSonic;
wire ClkDivided;
output right2;
CLkDiv #(2000, 50000000) bit1(clk, ClkDivided, rst);
UltraSonic ultra( echo, inputTrigger, clk, outUltraSonic, rst, right2);

Motor #(2) motora(ClkDivided, Motor[0]);
Motor #(30000000) motorb(ClkDivided, Motor[1]);
Motor #(4) motorc(ClkDivided, Motor[2]);
Mux   #(2) Mux1({Motor[1], Motor[1]}, {Motor[0], Motor[0]}, {Motor[2], Motor[2]}, {Motor[2], Motor[0]}, outUltraSonic, {M1, M2}); // stop, left, write, front


endmodule


module mux2x1(aa, bb, sel, out);
parameter n = 1;
input [n-1:0] aa, bb;
input sel;
output reg  [n-1:0] out;
always @(sel) begin
if (sel == 1'b0)
out <= aa;
else 
 out <= bb;
end
endmodule


module CarGeneral (clk,en, M1, M2, echo,inputTrigger, rst,outUltraSonic,right2, mst, mt, dt, mct);
output mst, mt;
output [1:0] dt;
output [3:0] mct;
input clk, rst, en, echo;
output inputTrigger;
output [1:0] outUltraSonic;
output right2;
output  M1, M2;//M1 left wheel , M2 right wheel;
wire M3, M4, M5, M6;
wire [2:0]Motor; 
wire [1:0] Direction;
wire ClkDivided;
 MotorDriverPath  D_1(clk, M3, M4, rst, mst, mt, dt, mct);
MotorDriverUltra D_2(clk, M5, M6, echo,inputTrigger, rst, outUltraSonic, right2);
mux2x1 #(2) m({M3, M4}, { M5, M6}, en, {M1, M2});
endmodule 