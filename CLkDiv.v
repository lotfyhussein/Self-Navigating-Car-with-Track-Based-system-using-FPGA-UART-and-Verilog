// file: CLkDiv.v
// author: @amrgouhar

`timescale 1ns/1ns

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
if (counter == (c/n)) 
counter <= 32'b0;
else counter <= counter + 1'b1;
if (counter == (c/n))
     outputclock <= 1'b0;
else
    if(counter == (c/(2 * n)))
        outputclock <= 1'b1;
end
endmodule