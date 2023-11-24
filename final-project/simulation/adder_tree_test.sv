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

logic [18:0] mul;
logic [18:0] outs[64];
logic [18:0] left;
adderTree at(.mul(mul), .outs(outs), .left_in(left));

always begin: TEST_VECTORS // runs once at start of simulation, must be named
$display("simulation started");

for(int i = -10; i < 10; i++)
begin
    #2 mul = i;
    left = 100 - ($urandom()%200);
end

end
endmodule

