`timescale 1ns / 1ps

module quad #
(
    parameter integer warp_width = 320
)
(
    (* mark_debug="true" *) input logic [9:0] vertices[4][2],   // 4 vec2s in integer screen coordinates
                                        // representing the vertices of a quadrilateral
                                        // 0:x, 1:y

    (* mark_debug="true" *) input logic [9:0] drawY,            // y coordinate of pixels possibly inside
                                        // quadrilateral

    (* mark_debug="true" *) output logic isInside[warp_width]        // one if drawX and drawY are inside quadrilateral                  
    );

    // EDGE FUNCTIONS (read the paper)

    // dX: difference between starting X and ending X of edge
    // dY: same as dX but for Y
    // E(x, y) = (drawX - X) dY - (drawY - Y) dX

    // vertices must be passed in COUNTER CLOCKWISE
    // this is because the edge function is negative on the LEFT side of the edge when
    // looking from its starting to ending vertex.
    
    logic signed [15:0] dX[4];
    logic signed [15:0] dY[4];

    logic signed [31:0] E[warp_width][4];

    always_comb
    begin
        // dX and dY calculation
        //     1 <-- 0
        //     |     ^
        //     V     |
        //     2 --> 3  
        for (int i = 0; i < 4; i++)
        begin
            dX[i] = vertices[(i + 1)%4][0] - vertices[i][0]; 
            dY[0] = vertices[(i + 1)%4][1] - vertices[i][1];
        end

        // edge function inital conditions
        for (int i = 0; i < 4; i++)
        begin
            E[0][i] = (vertices[i][0]) * dY[i] - (drawY - vertices[i][1]) * dX[i];
        end

        // edge functions E[x] = E(x, drawY)
        for (int x = 1; x < warp_width; x++)
        begin
            for (int i = 0; i < 4; i++)
            begin
                E[x][i] = vertices[x-1][i] + dY[i];
            end
        end

        for (int x = 0; x < warp_width; x++)
        begin
            isInside[x] = E[x][0][31] & E[x][1][31] & E[x][2][31] & E[x][3][31];
        end
    end

endmodule
