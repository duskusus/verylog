`timescale 1ns / 1ps

module geometryPipeline(
    input logic Clk,
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

    logic [15:0] csVertices[4][4];  // camera space vertices 
    logic [15:0] divOutX[4], divOutY[4];

    generate
    for (genvar i = 0; i < 4; i++)
        matrixMultiply mm(.Clk(Clk), .matrix(vm), .ivector(wsVertices[i]), .ovector(csVertices[i]));
    endgenerate

    // Z-Divide, one of the parts that makes it 3d
    // the other is occlusion
    always_ff @(posedge Clk)
    begin
        for(int i = 0; i < 4; i++)
        begin
            // v not code v
            // c = (a / b)
            // (a / b) << ds = (a << ds*2) / (b << ds)
            
            ssVertices[i][0] <= divOutX[i];
            ssVertices[i][1] <= divOutY[i];
        end
    end

generate
    for (genvar i = 0; i < 4; i++)
    begin
        div_gen_0 d0(
        .aclk(Clk),
        .s_axis_divisor_tdata(csVertices[i][3]),
        .s_axis_divisor_tvalid(1),
        .s_axis_dividend_tdata(csVertices[i][0] << ds),
        .s_axis_dividend_tvalid(1),
        .m_axis_dout_tdata(divOutX[i]));

        div_gen_0 d1(
            .aclk(Clk),
            .s_axis_divisor_tdata(csVertices[i][3]),
            .s_axis_divisor_tvalid(1),
            .s_axis_dividend_tdata(csVertices[i][1] << ds),
            .s_axis_dividend_tvalid(1),
            .m_axis_dout_tdata(divOutY[i])

        );
    end
endgenerate
endmodule