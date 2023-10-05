`timescale 1ns / 1ps

module branch_unit(
    input logic Clk, LD_CC, LD_BEN,
    input logic [15:0] BUS,
    input logic [2:0] IR,
    output logic BEN
    );
    logic N, Z, P, Nc, Zc, Pc, BENs;

    always_ff @ (posedge Clk)
    begin

        if(LD_BEN)
            BEN <= BENc;
        
        if(LD_CC)
        begin
        N <= Nc;
        Z <= Zc;
        P <= Pc;
        end
    end
    
    always_comb begin
        Nc = BUS[15];
        Zc = ~(|BUS);
        Pc = ~(N | Z);

        BENc = | ({Nc, Zc, Pc} & IR);
    end
endmodule
