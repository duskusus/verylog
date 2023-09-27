`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/26/2023 10:34:55 PM
// Design Name: 
// Module Name: control
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


module control(
    input logic Clk,
    input logic [15:0] IR,
    input logic [15:0] BUS
    );
    logic N, Z, P, LD_BEN;  //PSR, values, Branch Enable
    always_comb begin
        //compute NZP from BUS

        // compute LD_BEN from IR[11:9] and NZP
    end
endmodule
