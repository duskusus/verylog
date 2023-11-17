`timescale 1ns / 1ps

module seq_quad
(
    input logic Clk,
    input logic [8:0] vertices[4][2],   // 4 vec2s in integer screen coordinates
                                        // representing the vertices of a quadrilateral
                                        // 0:x, 1:y

    input logic [7:0] drawY,            // y coordinate of pixels possibly inside
                                        // quadrilateral

    output logic isInside[320]          // one if drawX and drawY are inside quadrilateral               
    );

    // EDGE FUNCTIONS (read the paper)

    // dX: difference between starting X and ending X of edge
    // dY: same as dX but for Y

    // vertices must be passed in COUNTER CLOCKWISE
    // this is because the edge function is negative on the LEFT side of the edge when
    // looking from its starting to ending vertex.
    // to reduce required dsps, we can invert the edge function to solve for x where
    // E(x, y) < 0, or
    // drawX < X + ((drawY - Y) * dx) / dy

    localparam integer efmsb = 18; // edge function msb
    localparam integer warp_width = 320;
    
    logic [8:0] dX[4];
    logic [9:0] dY[4];

    logic [9:0] intersections[4];

    logic edges [320][4];

    always_ff @(posedge Clk)
    begin
        // dX and dY calculation
        //     1 <-- 0
        //     |     ^
        //     V     |
        //     2 --> 3  

        //stage 1
        dX[0] <= vertices[1][0] - vertices[0][0];
        dX[1] <= vertices[2][0] - vertices[1][0];
        dX[2] <= vertices[3][0] - vertices[2][0];
        dX[3] <= vertices[0][0] - vertices[3][0];

        dY[0] <= vertices[1][1] - vertices[0][1];
        dY[1] <= vertices[2][1] - vertices[1][1];
        dY[2] <= vertices[3][1] - vertices[2][1];
        dY[3] <= vertices[0][1] - vertices[3][1];

        // stage 2
        for(int i = 0; i < 4; i++)
            intersections[i] <= ((drawY - vertices[i][1]) * dX[i]) / dY[i] + vertices[0][0];

        // stage 3
        for(int x = 0; x < 320; x++)
        begin
            for (int i = 0; i < 4; i++)
            begin
                edges[x][i] = (x < intersections[i]) ? 1 : 0;

                if(dY[i] == 0)
                    edges[x][i] = ((drawY < vertices[i][1]) ^ ~dX[i][9]) ? 1 : 0;
            end
        end

        // stage 4
        for(int x = 0; x < 320; x++)
            isInside[x] <= edges[x][0] && edges[x][1] && edges[x][2] && edges[x][3];
    end

endmodule
