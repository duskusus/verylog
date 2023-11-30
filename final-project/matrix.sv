`timescale 1ns / 1ps

module matrixMultiply(
    input logic Clk,
    input logic [15:0] ivector[4],
    input logic [15:0] matrix[16],

    output logic [15:0] ovector[4]
);
    localparam ds = 8;

    logic [31:0] c_ovector[4];

    always_comb
    begin
        for (int i = 0; i < 4; i++)
        begin
            c_ovector[i] = 0;
            for (int j = 0; j < 4; j++)
            begin
                // c = a * b -> c * 2^16 = a * 2^8 + b * 2^8
                c_ovector[i] += matrix[4 * i + j] * ivector[j];
            end
        end
    end

    always @(posedge Clk)
    begin
        // c * 2^8 = (a * 2^8 * b * 2^8) >> 8 -> ds = 8 (For now)
        for (int i = 0; i < 4; i++)
            ovector[i] <= c_ovector[i] >> ds;
    end
endmodule