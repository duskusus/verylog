`timescale 1ns / 1ps

module mux_1_8(
    input logic [2:0] DRselect,
    output logic ldA, ldB, ldC, ldD, ldE, ldF, ldG, ldH
    );

   
    always_comb
    begin

        ldA = 1'b0;
        ldB = 1'b0;
        ldC = 1'b0;
        ldD = 1'b0;

        ldE = 1'b0;
        ldF = 1'b0;
        ldG = 1'b0;
        ldH = 1'b0;
        case (DRselect)
            3'd0 : 
                ldA = 1'b1;
            3'd1 : 
                ldB = 1'b1;
            3'd2 : 
                ldC = 1'b1;
            3'd3 : 
                ldD = 1'b1;

            3'd4 : 
                ldE = 1'b1;
            3'd5 : 
                ldF = 1'b1;
            3'd6 : 
                ldG = 1'b1;
            3'd7 : 
                ldH = 1'b1;
            default : 
                begin
                ldA = 1'b0;
                ldB = 1'b0;
                ldC = 1'b0;
                ldD = 1'b0;

                ldE = 1'b0;
                ldF = 1'b0;
                ldG = 1'b0;
                ldH = 1'b0;
                end
        endcase
    end

endmodule
