`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/19/2023 11:47:49 PM
// Design Name: 
// Module Name: multiplier
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplier(
    input logic Clk, Reset,
    input logic[7:0] A, B,
    output logic[7:0] Y,
    output logic done,
    output logic[3:0] count
    );
logic[7:0] sA, sB, R;
always_ff @ (posedge Clk)
begin
if (Reset)
begin
    count  <= 0;
    done <= 0;
    sA <= A;
    sB <= B;
    Y <= 0;
end
else if(count < 8)
begin
    count <= count + 1;
    if (sA[0])
        Y <= R;
    
    sB <= {sB[6:0], 0};
    sA <= {0, sA[7:1]};
    
end
else
    done = 1;

end

subadder ra(.A(Y), .B(sB), .S(R), .cin(0));
endmodule