module matrixMultiply(
    input logic Clk
    input logic [15:0] ivector[4],
    input logic [15:0] matrix[16],

    output logic [15:0] ovector[4]
);
    localparam ds = 16;

    logic [31:0] c_ovector[4];

    always_comb
    begin
        for (int i = 0; i < 4; i++)
        begin
            for (int j = 0; j < 4; j++)
            begin
                c_ovector[i] += matrix[4 * i + j] * ivector[j];
            end
        end
    end

    always @(posedge Clk)
    begin
        for (int i = 0; i < 4; i++)
            ovector[i] <= c_ovector[i] >> ds;
    end
endmodule