`timescale 1ns / 1ps

localparam efmsb = 18;

module adderTree
(
    input logic [efmsb :0] mul,
    input logic [efmsb:0] left_in,
    output logic signed[efmsb:0] outs[0:63]
);

    logic signed [efmsb:0] left, leftp16, leftp32, leftp48;

    assign left = left_in;
    assign leftp16 = left + (16) * mul;
    assign leftp32 = left + (32) * mul;
    assign leftp48 =  left + (48) * mul;

    adderTree16 at0(.mul($signed(mul)), .left(left), .outs(outs[0:15]));
    adderTree16 at1(.mul($signed(mul)), .left(leftp16), .outs(outs[16:31]));
    adderTree16 at2(.mul($signed(mul)), .left(leftp32), .outs(outs[32:47]));
    adderTree16 at3(.mul($signed(mul)), .left(leftp48), .outs(outs[48:63]));
endmodule

module adderTree16
(
    input logic  [efmsb:0] mul,
    input logic [efmsb:0] left,
    output logic signed [efmsb:0] outs[0:15]
);
    always_comb
    begin
        outs[0] = left;
        outs[1] = outs[0] + mul;
        outs[2] = outs[0] + mul * (2);
        outs[3] = outs[2] + mul;

        outs[4] = left + mul * (4);
        outs[5] = outs[4] + mul;
        outs[6] = outs[4] + mul * (2);
        outs[7] = outs[6] + mul;

        outs[8] = left + mul * (8);
        outs[9] = outs[8] + mul;
        outs[10] = outs[8] + mul * (2);
        outs[11] = outs[10] + mul;

        outs[12] = left + mul * (12);
        outs[13] = outs[12] + mul;
        outs[14] = outs[12] + mul * (2);
        outs[15] = outs[14] + mul;
    end
endmodule