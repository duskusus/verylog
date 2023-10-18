module triangle_generator(
    input logic[15:0] a[3], b[3], c[3], //SCREEN COORDINATE vertices with z (depth) values
    input logic[7:0] r_in, g_in, b_in, // fill color
    input logic[15:0] x, y, // screen coordinates of pixel being tested
    output logic inside_triangle, // 1 if (x, y) is inside triangle defined by {a, b, c}
    output logic [7:0] r, g, b, z // red, green, blue, depth (used for depthtest)
);
    logic [16:0] edge_function 
endmodule