`timescale 1ns / 1ps

module test_quad();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

const int warp_width = 240;

logic [9:0] vertices[4][2] = {
  '{300, 200},
  '{20, 200},
  '{20, 20},
  '{200, 20}
};

logic [9:0] drawY;
logic isInside[warp_width];

quad#(.warp_width(war_width)) q(.vertices(vertices), .drawY(drawY), .isInside(isInside));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

end
endmodule
