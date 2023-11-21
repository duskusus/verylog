`timescale 1ns / 1ps

module test_quad # ();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable

localparam warp_width = 320;

always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

logic [9:0] vertices[4][2] = {
  '{300, 200},
  '{20, 200},
  '{20, 20},
  '{200, 20}
};
logic Reset, Start;
logic [9:0] rasterX, rasterY;

edge_walker e(.Clk(Clk), .Start(Start), .Reset(Reset), .vertices_in(vertices), .rasterX(rasterX), .rasterY(rasterY));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

Reset = 1;
#2;
Reset = 0;
#2;
Start = 1;
#2;
Start = 0;
#500000;

end
endmodule
