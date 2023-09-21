`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/12/2023 03:51:12 PM
// Design Name: 
// Module Name: addertest
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module multiplier_test();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

logic[15:0] A, B, Y;
logic load_A, load_B, done;
multiplier m(.*);

int testcount = 1000;
int errors = 0;

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");
A = 12;
B = 7;
load_A = 1;
#1 load_A = 0;
load_B = 1;
#1 load_B = 0;
endmodule
