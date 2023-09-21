`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 04:07:05 PM
// Design Name: 
// Module Name: multiplier_toplevel
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


module multiplier_toplevel(
        input logic Clk, Reset_Load_Clear, Run,
        input logic[7:0] SW,
        output logic[3:0] hex_grid, 
        output logic[7:0] hex_seg, Aval, Bval,
        output logic Xval
    );
    multiplier m(.A(A), .B(B), .Y(Y));
    T <= Y + 1;
    fuihi
endmodule
