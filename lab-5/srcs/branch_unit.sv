`timescale 1ns / 1ps

module branch_unit(
    input logic [15:0] BUS,
    input logic [2:0] IR,
    output logic BEN
    );
    logic N, Z, P;
    
    always_comb begin
        N = BUS[15];
        Z = ~(|BUS);
        P = ~(N | Z);

        BEN = | ({N, Z, P} & IR);
    end
endmodule
