`timescale 1ns / 1ps

module left(
    input logic LD_IR, LD_PC, ADDR1MUX, Clk, Reset,
    input logic [15:0] BUS, SR1,
    input logic [1:0] ADDR2MUX, PCMUX,
    output logic [15:0] PC, MARMUX, IR
    );

    logic [15:0] ADDR1MUX_out, ADDR2MUX_out, PCMUX_out;

always_ff @ (posedge Clk)
begin
    if (Reset)
    begin
        PC <= 0;
        IR <= 0;
    end
    else
    begin
        if(LD_IR)
            IR <= BUS;

        if(LD_PC)
            PC <= PCMUX_out;
        else
            PC <= PC;
    end
end

always_comb begin

    MARMUX = ADDR1MUX_out + ADDR2MUX_out;

    case (ADDR1MUX)
        0:
            ADDR1MUX_out = PC;
        1:
            ADDR1MUX_out = SR1;
    endcase

    case (ADDR2MUX)
        0:
            ADDR2MUX_out = 0;
        1:
            ADDR2MUX_out = {{{11{IR[5]}}}, IR[4:0]}; // sign extend
        2:
            ADDR2MUX_out = {{{7{IR[8]}}}, IR[8:0]};
        3:
            ADDR2MUX_out = {{{6{IR[10:0]}}}, IR[10:0]};
    endcase

    case (PCMUX)
        0:
            PCMUX_out = PC + 1;
        1:
            PCMUX_out = MARMUX;
        2:
            PCMUX_out = BUS;
        default:
            PCMUX_out = PC;
    endcase
    
end

endmodule
