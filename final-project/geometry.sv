`timescale 1ns / 1ps

module geometryPipeline(
    input logic Clk,
    input logic [15:0] vertices[4][3], // world space vertices (fixed point)
    input logic [15:0] vm[16], // view matrix
    input logic [15:0] tuser_in,
    output logic [15:0] tuser_out,
    output logic [9:0] ssVertices[4][2] // screen space vertices (integer)
);
    localparam ds = 8;

    logic [15:0] wsVertices[4][4];
    always_comb
    begin
        for (int i = 0; i < 4; i++)
        begin
            wsVertices[i][0] = vertices[i][0];
            wsVertices[i][1] = vertices[i][1];
            wsVertices[i][2] = vertices[i][2];
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
            
            ssVertices[i][0] <= csVertices[i][0];
            ssVertices[i][1] <= csVertices[i][1];
        end
        tuser_out <= tuser_in;
    end
/*
    div_gen_1 pipe0(
    .aclk(Clk),
    .s_axis_divisor_tdata(csVertices[0][2]),
    .s_axis_dividend_tuser(tuser_in),
    .m_axis_dout_tuser(tuser_out),
    .s_axis_divisor_tvalid(1),
    .s_axis_dividend_tdata(csVertices[0][0]),
    .s_axis_dividend_tvalid(1),
    .m_axis_dout_tdata(divOutX[0]));

    div_gen_0 pipe1(
        .aclk(Clk),
        .s_axis_divisor_tdata(csVertices[0][2]),
        .s_axis_divisor_tvalid(1),
        .s_axis_dividend_tdata(csVertices[0][1]),
        .s_axis_dividend_tvalid(1),
        .m_axis_dout_tdata(divOutY[0])
    );

generate
    for (genvar i = 1; i < 4; i++)
    begin
        // x / z
        div_gen_0 d0(
        .aclk(Clk),
        .s_axis_divisor_tdata(csVertices[i][2]),
        .s_axis_divisor_tvalid(1),
        .s_axis_dividend_tdata(csVertices[i][0]),
        .s_axis_dividend_tvalid(1),
        .m_axis_dout_tdata(divOutX[i]));
        // y / z
        div_gen_0 d1(
            .aclk(Clk),
            .s_axis_divisor_tdata(csVertices[i][2]),
            .s_axis_divisor_tvalid(1),
            .s_axis_dividend_tdata(csVertices[i][1]),
            .s_axis_dividend_tvalid(1),
            .m_axis_dout_tdata(divOutY[i])

        );
    end
endgenerate
*/
endmodule