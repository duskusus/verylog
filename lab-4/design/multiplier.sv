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
    input logic[7:0] A, B,
    output logic[7:0] Y,
    output logic done
)
logic[7:0] sA, sB, R;
R = 0;
logic [7:0] count;
ripple_adder a(.A(Y), .B(sB), .S(R));
always_ff @ (posedge Clk)
begin
    if (load_A)
        sA <= A;
    if (load_B)
        sB <= B;

    count <= count + 1;
    if(count < 8) begin

    if(A[7])
        Y <= R;

    sA <= {0, sA[7:1]};
    sB <= {0, sA[7:1]};
end

endmodule


