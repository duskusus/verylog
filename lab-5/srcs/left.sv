`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 08:30:11 PM
// Design Name: 
// Module Name: left
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


module left(
    input logic LD_IR, LD_PC, ADDR1MUX, Clk, Reset
    input logic [15:0] BUS,
    input logic [1:0] ADDR2MUX, PCMUX,
    output logic [15:0] PC, MARMUX, IR
    );

always_ff @ (posedge Clk)
begin
    if (Reset)
    begin
        PC <= 0;
        IR <= 0;
    end
    else begin
    if(LD_IR)
        IR <= BUS;

    if(LD_PC)
    begin
        case (PCMUX)
        0:
            PC <= PC + 1;
        default:
            PC <= PC;

        endcase
    end
    else
        PC <= PC;
    end
end

endmodule
