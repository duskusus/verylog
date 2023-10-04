`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/29/2023 02:10:37 PM
// Design Name: 
// Module Name: memory_interface
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


module memory_interface(
    input logic[15:0] BUS, Data_to_CPU,
    input logic MIO_EN, LD_MAR, LD_MDR, Clk, Reset
    output logic[15:0] MAR, MDR, Data_from_CPU
    );

always_ff
begin
    if(LD_MAR)
        MAR <= BUS;

    if(LD_MDR)
    begin
        if(MIO_EN)
            MDR <= Data_from_SRAM;
        else
            MDR <= BUS;
    end

end

endmodule
