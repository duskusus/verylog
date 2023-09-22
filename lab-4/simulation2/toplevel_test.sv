`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/21/2023 12:03:07 PM
// Design Name: 
// Module Name: toplevel_test
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


module toplevel_test();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

// variable instantiations copied directly from module definition -Clk
logic Reset_B, Run_B;
logic[7:0] Din;
logic[3:0] hex_grid;
logic[7:0] hex_seg, Aval, Bval;
logic[16:0] prod;
logic Xval;
Toplevel m(.*);// so this is ok
int testcount = 100;
int errors = 0;
int seed = 42;
int opA, opB;


always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");
errors = 0;
//test from lab manual
 Run_B = 0;
 Reset_B = 1;
#20 Din = 8'b11000101;
#3 Reset_B = 0;
#1 Din = 8'b00000111;
#1 Run_B = 1;
#1

Run_B = 0;

#50
Din = 0;




for(int i = 0; i < testcount; i++)
begin
Run_B = 0;
opA = ($random() % 256); 
opB = ($random() % 256); 
Din = opA;
#1 Reset_B = 1;
#10 Reset_B = 0;
Din = opB;
#2 Run_B = 1;
#20 Run_B = 0;
#10 ;
if(opA * opB != prod)
    begin
    errors ++;
    $display("%d * %d = %d", opA, opB, prod);
    end
end
$display("%d errors in %d tests with seed %d", errors, testcount, seed);
end
endmodule