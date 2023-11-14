`timescale 1ns / 1ps

module quad #
(
    parameter integer warp_width = 240
)
(
    input logic [9:0] vertices[4][2],   // 4 vec2s in integer screen coordinates
                                        // representing the vertices of a quadrilateral
                                        // 0:x, 1:y

    input logic [9:0] drawY,            // y coordinate of pixels possibly inside
                                        // quadrilateral

    output logic isInside[warp_width]   // one if drawX and drawY are inside quadrilateral                  
    );

    // EDGE FUNCTIONS (read the paper)

    // dX: difference between starting X and ending X of edge
    // dY: same as dX but for Y
    // E(x, y) = (drawX - X) * dY - (drawY - Y) * dX

    // vertices must be passed in COUNTER CLOCKWISE
    // this is because the edge function is negative on the LEFT side of the edge when
    // looking from its starting to ending vertex.
    
    logic signed [10:0] dX[4];
    logic signed [10:0] dY[4];

    logic signed [22:0] E[warp_width][4];

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
        dX[3] = vertices[1][0] - vertices[3][0];

        dY[0] = vertices[1][1] - vertices[0][1];
        dY[1] = vertices[2][1] - vertices[1][1];
        dY[2] = vertices[3][1] - vertices[2][1];
        dY[3] = vertices[1][1] - vertices[3][1];

        for (int i = 0; i < 4; i++)
        begin
            E[0][i] = (-vertices[i][0]) * dY[i] - (drawY - vertices[i][1]) * dX[i];
        end

        for (int x = 1; x < warp_width; x++)
        begin
            for (int i = 0; i < 4; i++)
            begin
                E[x][i] = E[0][i] + dY[i] * x;
            end
        end
        
        for (int x = 0; x < warp_width; x++)
        begin
            // [drawX][edge # ][bit]
            isInside[x] = (~E[x][0][22]) & E[x][1][22] & E[x][2][22] & E[x][3][22];
        end
    end

endmodule
