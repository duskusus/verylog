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
  '{200, 200},
  '{100, 200},
  '{100, 100},
  '{210, 100}
};
logic [9:0] drawY;
logic isInside[320];

quad q(.vertices(vertices), .drawY(drawY), .isInside(isInside));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

for(int i = 0; i < 240; i++)
  #1 drawY = i;

end
endmodule
