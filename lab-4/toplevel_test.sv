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


module toplevel_test();
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

// variable instantiations copied directly from module definition -Clk
input logic Reset_Load_Clear, Run,
input logic[7:0] SW,
output logic[3:0] hex_grid, 
output logic[7:0] hex_seg, Aval, Bval,
output logic Xval
multiplier_toplevel(.*);// so this is ok
int testcount = 1000;
int errors = 0;

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");
A = 8'hf15;
B = 8'h55;
#1 Reset = 1;
#10 Reset = 0;
for(int i = 0; i < 100; i++)
begin
#1  $display(count);
end
end
endmodule
