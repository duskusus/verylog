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
Reset_Load_Clear = 0;
Run = 0;
SW = 0;
for(int i = 0; i < 100; i++)
begin
logic [7:0] opA = ($random() % 256) - 128; 
logic [7:0] opB = ($random() % 256) - 128; 
SW = opA;
#1 Reset_Load_Clear = 1;
#1 Reset_Load_Clear = 0;
SW = opB;
#1 Run = 1;
#20 $display(opA, " * " , opB, " = ", {Aval, Bval})
$display("Xval: " Xval);
end
end
endmodule
