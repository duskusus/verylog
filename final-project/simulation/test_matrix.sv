`timescale 1ns / 1ps

module test_matrix # ();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable

always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end


logic [15:0] wsVertices[4][3];
logic [9:0] ssVertices[4][2];
logic [15:0] matrix[16] = {
    1<<8, 0, 0, 0,
    0, 1<<8, 0, 0,
    0, 0, 1<<8, 0,
    0, 0, 0, 1<<8
};

geometryPipeline gp(
    .Clk(Clk),
    .vm(matrix),
    .vertices(wsVertices),
    .ssVertices(ssVertices)
);
integer x;
always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");
for(x = 0; x < 240; x = x + 1)
begin
    #2;
    wsVertices[0] = '{0, 0, (1<<8)};
    wsVertices[0][2] = x;
    wsVertices[1] = '{1<<7, 0, 1<<8};
    wsVertices[1][2] = x;
    wsVertices[2] = '{1<<7, 1<<7, 1<<8};
    wsVertices[2][2] = x;
    wsVertices[3] = '{0, 1<<7, 1<<8};
    wsVertices[3][2] = x;
    #2;
end
end
endmodule

