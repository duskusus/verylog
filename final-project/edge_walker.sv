`timescale 1ns / 1ps

module edge_walker(
    input logic Clk, Reset, Start,
    input logic [9:0] vertices_in[4][2],
    output logic [9:0] rasterX, rasterY,
    output logic isInside
    );

    localparam efmsb = 20;
    logic [efmsb:0] E[4]; // edge functions
    logic [9:0] dX[4], dY[4], dX_in[4], dY_in[4];
    logic [9:0] vertices[4][2];
    logic running;

    always_comb
    begin
        for(int i = 0; i < 4; i++)
        begin
            dX_in[i] = vertices_in[(i+1)%4][0] - vertices_in[i][0];
            dY_in[i] = vertices_in[(i+1)%4][1] - vertices_in[i][1];
        end

        isInside = ~E[0][efmsb] & ~E[1][efmsb] & E[2][efmsb] & E[3][efmsb];
    end

    always_ff @(posedge Clk)
    begin
        // synchronous reset
        if(Reset)
        begin
            rasterX <= 0;
            rasterY <= 0;
            running <= 0;
        end

        if(Start)
        begin
            running <= 1;
            for(int i = 0; i < 4; i++)
            begin
                dX[i] <= dX_in[i];
                dY[i] <= dY_in[i];
                E[i]  <= (-vertices_in[i][0]) * dY_in[i] + vertices_in[i][1] * dX_in[i];
            end
            vertices <= vertices_in;
        end

        if(running)
        begin
            if(rasterX < 320)
            begin
                rasterX <= rasterX + 1;
                for(int i = 0; i < 4; i++)
                    E[i] <= E[i] + dY[i];
            end
            else if(rasterY < 240)
            begin
                rasterY <= rasterY + 1;
                rasterX <= 0;
                for (int i = 0; i < 4; i++)
                    E[i] <= E[i] - dX[i];
            end
            else
            begin
                running <= 0;
            end


        end
    end
endmodule
