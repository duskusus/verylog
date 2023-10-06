`timescale 1ns / 1ps


module register_file(
    input logic[15:0] BUS, IR,
    input logic LD_REG, DR, Clk, Reset, SR1MUX_select,
    output logic[15:0] SR1, SR2
    );

    logic [15:0] R[7:0];
    logic [2:0] DRMUX_out, SR1MUX_out;

    always_comb
    begin
        if(DR)
            DRMUX_out = 3'b111;
        else
            DRMUX_out = IR[11:9];

        if(SR1MUX_select)
            SR1MUX_out = IR[8:6];
        else
            SR1MUX_out = IR[11:9];

        SR1 = R[SR1MUX_out];
        SR2 = R[IR[2:0]];
    end

    always_ff @ (posedge Clk)
    begin
        if (Reset)
        begin
            for (int i = 0; i < 8; i++)
                R[i] <= 0;
        end
        if(LD_REG)
            R[DRMUX_out] <= BUS;
    end

endmodule
