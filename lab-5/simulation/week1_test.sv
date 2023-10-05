`timescale 1ns / 1ps

module toplevel_test();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

// variable instantiations copied directly from module definition -Clk
// inputs
logic [15:0] SW;
logic Reset ,Run, Continue;
// outputs
logic [15:0] LED;
logic [7:0] hex_seg;
logic [3:0] hex_grid;
logic [7:0] hex_segB;
logic [3:0] hex_gridB;

slc3_testtop lc3(.*);



always begin: TEST_VECTORS // runs once at start of simulation, must be named
Reset = 1;
Run = 0;
Continue = 0;
SW = 16'd155;
$display("simulation started");
#2
Reset = 0;
#2
Run = 1;
#2 Run = 0;
for (int i = 0; i < 10000; i++)
begin
    #10 Continue = 1;
    #10 Continue = 0;
end

end
endmodule