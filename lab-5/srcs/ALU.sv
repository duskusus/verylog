`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 06:13:05 PM
// Design Name: 
// Module Name: ALU
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


module ALU(
input logic [15:0] A, B,
input logic [4:0] Imm,
input logic [1:0] ALUK,
input logic SR2MUX_select,
output logic [15:0] ALU_out
    );
    logic [15:0] opA, opB;
    
    
    always_comb begin
        //sr2mux
        if(SR2MUX_select) begin
            //sign extend
            opB[4:0] = Imm;
            opB[15:5] = Imm[4];
         end
         else begin
            opB = B;
         end
         
         opA = A;
         
         case (ALUK)
            2'b00:
                ALU_out = opA + opB;
            2'b01:
                ALU_out = opA & opB;
            2'b10:
                ALU_out = opA | opB;
            2'b11:
                ALU_out = opA;
            endcase  
    end
endmodule
