`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/01/2023 01:44:56 PM
// Design Name: 
// Module Name: vram
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


module vram #
(
    parameter integer word_count = 601,
    parameter integer word_size = 32,
    parameter integer address_size = 12
)
(
    input logic clk, re, we, rst,
    input logic [address_size - 1:0] w_addr, r_addr,
    input logic [word_size - 1:0] din,
    output logic [word_size - 1:0] dout
    );
    logic [word_size - 1:0] ram[word_count - 1:0];
    
    always @(posedge clk)
        begin
            if(rst)
                begin
                    for (int i = 0; i < word_count; i++)
                        begin
                            ram[i] <= 0;
                        end
                end
            else if(we)
                ram[w_addr] <= din;

            
            if(re)
                dout <= ram[r_addr];
        end

endmodule
