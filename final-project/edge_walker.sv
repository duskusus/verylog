`timescale 1ns / 1ps

module edge_walker(
    input logic Clk,
    input logic Reset,
    input logic [9:0] vertices_in[4][2],
    output logic [9:0] rasterX, rasterY
    );

    logic [18:0] E[4]; // edge functions
    logic [9:0] dX[4], dY[4];
    logic [9:0] vertices[4][2]
    logic running;
    always_ff @(posedge Clk)
    begin
        if(Reset)
        begin
            rasterX <= 0;
            rasterY <= 0;
            running <= 0;
        end

        if(Start)
        begin
            for(int i = 0; i < 4; i++)
            begin
                logic [9:0] dx = vertices[(i+1)%4][0] - vertices[i][0];
                logic [9:0] dy = vertices[(i+1)%4][1] - vertices[i][1];
                dX[i] <= dx;
                dY[i] <= dy;
                E[i]  <= (-vertices[i][0]) * dy + vertices[i][1] * dx;
            end
        end
    end

endmodule
