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


module addertest();

timeunit 10ns;
timeprecision 1ns;

logic[15:0] A, B, S;
logic cin, cout;
ripple_adder ra(.*);

always begin
#1 A = 16'h55;
#1 B = 16'h45;
#1 cin = 0;
#10 A = 16'hf1;
#10 B = 16'hbb;
end
endmodule
