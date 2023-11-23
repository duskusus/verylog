`timescale 1ns / 1ps

localparam efmsb = 20;

module adderTree
(
    input logic signed [10:0] mul,
    input logic [efmsb:0] left_in,
    output logic [efmsb:0] outs[0:63]
);

    logic [efmsb:0] left, leftp16, leftp32, leftp48;

    assign left = left_in;
    assign leftp16 = left + $signed(16) * mul;
    assign leftp32 = left + $signed(32) * mul;
    assign leftp48 = left + $signed(48) * mul;

    adderTree16 at0(.mul(mul), .left(left), .outs(outs[0:15]));
    adderTree16 at1(.mul(mul), .left(leftp16), .outs(outs[16:31]));
    adderTree16 at2(.mul(mul), .left(leftp32), .outs(outs[32:47]));
    adderTree16 at3(.mul(mul), .left(leftp48), .outs(outs[48:63]));
endmodule

module adderTree16
(
    input logic signed [10:0] mul,
    input logic [efmsb:0] left,
    output logic [efmsb:0] outs[0:15]
);
    always_comb
    begin
        outs[0] = left;
        outs[1] = outs[0] + mul;
        outs[2] = outs[0] + mul * $signed(2);
        outs[3] = outs[2] + mul;

        outs[4] = left + mul * $signed(4);
        outs[5] = outs[4] + mul;
        outs[6] = outs[4] + mul * $signed(2);
        outs[7] = outs[6] + mul;

        outs[8] = left + mul * $signed(8);
        outs[9] = outs[8] + mul;
        outs[10] = outs[8] + mul * $signed(2);
        outs[11] = outs[10] + mul;

        outs[12] = left + mul * $signed(12);
        outs[13] = outs[12] + mul;
        outs[14] = outs[12] + mul * $signed(2);
        outs[15] = outs[14] + mul;
    end
endmodule