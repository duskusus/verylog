module geometryPipeline(
    input logic Clk
    input logic [15:0] vertices[4][2:0], // world space vertices (fixed point)
    input logic [15:0] vm[16], // view matrix
    output logic [9:0] ssVertices[4][2] // screen space vertices (integer)
);
    localparam ds = 8;

    logic [15:0] wsVertices[4][4];
    always_comb
    begin
        for (int i = 0; i < 4; i++)
        begin
            wsVertices[i][2:0] = vertices[i];
            wsVertices[i][3] = 16'(1 << ds); // fixed point 1
        end
    end

    logic [15:0] csVertices[4][4] // camera space vertices 

    for (int i = 0; i < 4; i++)
        matrixMultiply mm(.Clk(Clk), .matrix(vm), .ivector(wsVertices[i]), .ovector(csVertices[i]));

    always_ff @(posedge Clk)
    begin
        for(int i = 0; i < 4; i++)
        begin
            // c = (a / b)
            // (a / b) << ds = (a << ds*2) / (b << ds)
            ssVertices[i][0] <= (csVertices[i][0] << ds) / csVertices[i][3];
            ssVertices[i][1] <= (csVertices[i][1] << ds) / csVertices[i][3];
        end
    end
endmodule