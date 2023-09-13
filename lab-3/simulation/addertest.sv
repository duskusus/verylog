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

logic Clk = 0; //create clock variable


always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

logic[15:0] A, B, S;
logic cin, cout;
ripple_adder la(.*);

always begin: TEST_VECTORS // runs once at start of simulation, must be named

logic misses = 0;
cin = 0;
for (int a = 0; a < 16000; a++)
    begin
        for (int b = 0; b < 16000; b++)
        begin
            #1 A = a;
                B = b;
            if(S != A + B)
                $display(S, " != ", A, " + ", B);
        end
    end
    end
endmodule
