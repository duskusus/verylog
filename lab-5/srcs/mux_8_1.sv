`timescale 1ns / 1ps

module mux_1_8(
    input logic [2:0] SRselect,
    input logic [15:0] A, B, C, D, E, F, G, H
    output logic [15:0] SRreg
    );

   
    always_comb
    begin
        SRreg = 8'd0;
        case (SRselect)
            3'd0 : 
                SRreg = A;
            3'd1 : 
                SRreg = B;
            3'd2 : 
                SRreg = C;
            3'd3 : 
                SRreg = D;

            3'd4 : 
                SRreg = E;
            3'd5 : 
                SRreg = F;
            3'd6 : 
                SRreg = G;
            3'd7 : 
                SRreg = H;
            default : 
                begin
                SRreg = 8'd0;
                end
        endcase
    end

endmodule
