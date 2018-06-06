// file: PathSaver.v
// author: @amrgouhar

`timescale 1ns/1ns

module PathSaver(M1, M2, clk,rst, DATA);
parameter n = 7644;
parameter ter = 14;
input M1, M2, clk, rst;
output reg [104:0] DATA;
reg M1prev, M2prev;
reg stop;
reg[32:0] counterclk;
reg[3:0] CLOCK;
reg[6:0] Position;
reg[4:0] STATE;
always@(posedge clk) begin
    if(rst)begin
        DATA <= 105'b0;
        stop <= 1'b0;
        counterclk <= 32'b0;
        Position<= 7'b0;
    end
    else begin
        if(~stop) begin
            if(M1 != M1prev ||M2 != M2prev) begin
                 M1prev <= M1;
                 M2prev <= M2;
                 DATA <= {DATA[97:0],1'b0,CLOCK,M2,M1};
                 counterclk <=4'b0; 
                 CLOCK <=4'b0;
                 STATE <= STATE + 5'd1;
                end
                else counterclk <= counterclk +1'b1;
                
                if(counterclk == n) begin
                counterclk <=1'b0;
                CLOCK <= CLOCK + 1'b1;
                end
                
                if(STATE == ter)
                    stop <= 1'b1;
            end
        end
    end
endmodule