`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/04/2023 06:31:52 PM
// Design Name: 
// Module Name: ALU_test
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


module ALU_test();
timeunit 10ns;
timeprecision 1ns;

//create clock variable
logic Clk = 0;
// invert clock every 1 timeunit ("#1" means unit delay)
always #1 Clk = ~Clk;
initial begin: CLOCK_INITIALIZATION
    //force clock to 0 so its not undefined
    Clk = 0; 
end

// variable instantiations copied directly from module definition -Clk
// inputs

logic [15:0] A, B;
logic [4:0] Imm;
logic [1:0] ALUK;
logic SR2MUX_select;
logic [15:0] ALU_out;


ALU alu(.*);


always begin: TEST_VECTORS // runs once at start of simulation, must be named

ALUK = 2'b01;

A = 7;
B = -3;
#2;

end
endmodule
