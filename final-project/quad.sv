`timescale 1ns / 1ps

module quad
(
    input logic [8:0] vertices[4][2],   // 4 vec2s in integer screen coordinates
                                        // representing the vertices of a quadrilateral
                                        // 0:x, 1:y

    input logic [7:0] drawY,            // y coordinate of pixels possibly inside
                                        // quadrilateral

    output logic isInside[320]   // one if drawX and drawY are inside quadrilateral                  
    );

    // EDGE FUNCTIONS (read the paper)

    // dX: difference between starting X and ending X of edge
    // dY: same as dX but for Y
    // E(x, y) = (drawX - X) * dY - (drawY - Y) * dX

    // vertices must be passed in COUNTER CLOCKWISE
    // this is because the edge function is negative on the LEFT side of the edge when
    // looking from its starting to ending vertex.

    localparam integer efmsb = 18; // edge function msb
    localparam integer warp_width = 320;
    
    logic [8:0] dX[4];
    logic [9:0] dY[4];

    logic [efmsb:0] E[warp_width][4];

    always_comb
    begin
        // dX and dY calculation
        //     1 <-- 0
        //     |     ^
        //     V     |
        //     2 --> 3  

        dX[0] = vertices[1][0] - vertices[0][0];
        dX[1] = vertices[2][0] - vertices[1][0];
        dX[2] = vertices[3][0] - vertices[2][0];
        dX[3] = vertices[0][0] - vertices[3][0];

        dY[0] = vertices[1][1] - vertices[0][1];
        dY[1] = vertices[2][1] - vertices[1][1];
        dY[2] = vertices[3][1] - vertices[2][1];
        dY[3] = vertices[0][1] - vertices[3][1];

        for (int i = 0; i < 4; i++)
        begin
            E[0][i] = (-vertices[i][0]) * dY[i] - (drawY - vertices[i][1]) * dX[i];
        end

        for (int x = 1; x < warp_width; x++)
        begin
            for (int i = 0; i < 4; i++)
            begin
                E[x][i] = E[0][i] + dY[i] * x;
                // x = (E[x][i] - E[0][i]) / dY[i]
            end
        end
        
        for (int x = 0; x < warp_width; x++)
        begin
            // [drawX][edge # ][bit]
            isInside[x] = (~E[x][0][efmsb]) & (~E[x][1][efmsb]) & (E[x][2][efmsb]) & (E[x][3][efmsb]);
        end
    end

endmodule
