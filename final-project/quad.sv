`timescale 1ns / 1ps

module quad
(
    input logic[9:0] vertices[4][2],   // 4 vec2s in integer screen coordinates
                                        // representing the vertices of a quadrilateral
                                        // 0:x, 1:y

    input logic [9:0] drawY,            // y coordinate of pixels possibly inside
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

    localparam integer efmsb = 17; // edge function msb
    localparam integer warp_width = 320;
    
    logic [efmsb:0] dX[4];
    logic [efmsb:0] dY[4];

    logic signed [efmsb:0] E[4][0:warp_width];

    //logic [9:0] vertices[4][2];

    always_comb
    begin

        // clamp vertices
        /*for (int i = 0; i < 4; i++)
        begin
            vertices[i][0] = vertices_in[i][0];
            vertices[i][1] = vertices_in[i][1];

            if(vertices_in[i][0] > 320)
                vertices[i][0] = 320;

            if(vertices_in[i][0] < 0)
                vertices[i][0] = 0;

            if(vertices_in[i][1] > 240)
                vertices[i][1] = 240;

            if(vertices_in[i][1] < 0)
                vertices[i][1] = 0;
        end
        */

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

        for(int i = 0; i < 4; i++)
        begin
            E[i][0] = (-vertices[i][0]) * dY[i] - (drawY - vertices[i][1]) * dX[i];
        end
        
        for (int x = 0; x < warp_width; x++)
        begin
            // [drawX][edge # ][bit]
            isInside[x] = (E[0][x][efmsb]) & (E[1][x][efmsb]) & (E[2][x][efmsb]) & (E[3][x][efmsb]);
        end
    end

    generate
    for(genvar i = 0; i < 4; i++)
    begin
        for (genvar j = 0; j < 5; j++)
        begin
            adderTree at(.left_in(18'(E[i][0] + dY[i] * $signed(64 * j))), .outs(E[i][j*64 : j*64 + 63]), .mul(dY[i]));
        end
    end
    endgenerate

endmodule
