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

logic [9:0] drawY;
logic isInside[warp_width];

quad#(.warp_width(warp_width)) q(.vertices(vertices), .drawY(drawY), .isInside(isInside));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

for (int y = 0; y < 240; y++)
begin
  #1 drawY = y;
end

end
endmodule
