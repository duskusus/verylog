`timescale 1ns / 1ps

module branch_unit(
    input logic Clk, LD_CC, LD_BEN,
    input logic [15:0] BUS,
    input logic [15:0] IR,
    output logic BEN
    );
    logic N, Z, P; //registers
    logic Nc, Zc, Pc, BENc; // combinational outputs

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
        Pc = ~(Nc | Zc);

        BENc = | ({N, Z, P} & IR[11:9]);
    end
endmodule
