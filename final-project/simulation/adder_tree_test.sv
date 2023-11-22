`timescale 1ns / 1ps

module adder_tree_test(

    );
timeunit 10ns;
timeprecision 1ns;

logic Clk = 0; //create clock variable

always #1 Clk = ~Clk; // invert clock every 1 timeunit ("#1" means unit delay)

initial begin: CLOCK_INITIALIZATION
    Clk = 0; //force clock to 0 so its not undefined
end

logic [9:0] mul;
logic [18:0] outs[64];
logic [9:0] left;
adderTree at(.mul(mul), .outs(outs), .left_in(10'd0));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

for(int i = 0; i < 512; i++)
begin
    #2 mul = i;
    left = i;
end

end
endmodule

