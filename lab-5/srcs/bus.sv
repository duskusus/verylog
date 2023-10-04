`timescale 1ns / 1ps

module bus(
    input logic [15:0] MDR, ALU, PC, MARMUX,
    input logic GateMDR, GateALU, GatePC, GateMARMUX,
    output logic [15:0] BUS
    );
    always_comb
    begin
        if(GateMDR)
            BUS = MDR;
        else if(GateALU)
            BUS = ALU
        else if(GatePC)
            BUS = PC;
        else if(GateMARMUX)
            BUS = MARMUX;
        else if()
    end

endmodule
