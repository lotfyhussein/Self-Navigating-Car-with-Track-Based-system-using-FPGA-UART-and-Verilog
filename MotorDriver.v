// file: MotorDriver.v
// author: @lotfyhussein

`timescale 1ns/1ns
/*
module MotorDriver(clk, M1, M2, rst);
input rst;
input clk; 
output  M1, M2;    //M1 left wheel , M2 right wheel;
wire [2:0]Motor1, Motor2;
//reg inputTrigger; 
//wire echo; 
reg [1:0] outUltraSonic = 2'b10;
wire ClkDivided;
CLkDiv #(2000, 5000000) bit1(clk, ClkDivided, rst);
//UltraSonic (inputTrigger, inputTrigger, outUltraSonic);

Motor #(2) motor1a(ClkDivided, Motor1[0]);
Motor #(2) motor2a(ClkDivided, Motor2[0]);
Motor #(3) motor2c(ClkDivided, Motor2[1]);
Motor #(3) motor1c(ClkDivided, Motor1[1]);
Motor #(4) motor2b(ClkDivided, Motor2[2]);
Motor #(4) motor1b(ClkDivided, Motor1[2]);
Mux   #(2) Mux1({Motor1[0], Motor2[0]}, {Motor1[0], Motor2[1]}, {Motor1[1], Motor2[0]}, {Motor1[1], Motor2[1]}, outUltraSonic, {M1, M2});

endmodule*/



module MotorDriver(clk, M1, M2, echo,inputTrigger, rst);

input clk, rst; 
output  M1, M2;    //M1 left wheel , M2 right wheel;
wire [2:0]Motor;
output inputTrigger; 
input echo; 
wire [1:0] outUltraSonic;
wire ClkDivided;

CLkDiv #(2000, 50000000) bit1(clk, ClkDivided, rst);
UltraSonic ultra( echo, inputTrigger, clk, outUltraSonic, rst);

Motor #(2) motora(ClkDivided, Motor[0]);
Motor #(3) motorb(ClkDivided, Motor[1]);
Motor #(4) motorc(ClkDivided, Motor[2]);
Mux   #(2) Mux1({Motor[1], Motor[1]}, {Motor[0], Motor[0]}, {Motor[2], Motor[2]}, {Motor[2], Motor[0]}, outUltraSonic, {M1, M2});


endmodule