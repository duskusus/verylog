`timescale 1ns / 1ps

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

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

for(int i = 0; i < 240; i++)
    wsVertices[0] = '{1<<8 , 1<<8, 1<<8};
    wsVertices[1] = '{$random() %2048 , $random() % 2048, $random() % 2048};
    wsVertices[2] = '{$random() %2048 , $random() % 2048, $random() % 2048};
    wsVertices[3] = '{$random() %2048 , $random() % 2048, $random() % 2048};
  #2;
end
endmodule

