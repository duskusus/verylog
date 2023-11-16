`timescale 1ns / 1ps

module test_pipeline # ();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable

localparam warp_width = 240;

always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

logic [7:0] drawY;
logic isInside[warp_width];



  logic clear;
  logic [9:0] fbX, fbY;
  logic [15:0] primitive_count;
  logic [15:0] clear_color;
  logic [15:0] current_prim; 
  logic [255:0] gmem_dout;
  logic [4:0] Red, Blue;
  logic [5:0] Green;

  pipeline p(.*);

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

primitive_count = 255;
clear_color = 16'hff;

# (255 * 240)

clear = 1;
#1
clear = 0;

end
endmodule
