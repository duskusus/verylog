`timescale 1ns / 1ps

module branch_unit_test();
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

logic [15:0] BUS;
logic [2:0] IR;
logic BEN;

branch_unit bu(.*);



always begin: TEST_VECTORS // runs once at start of simulation, must be named

IR = 3'b001;
BUS = -7;
#5
BUS = 823;
#5
BUS = 0;
#5
BUS = -1;

#5
IR = 3'b000;
BUS = 15;
#5
BUS = -255;
#5
BUS = 0;
#5
IR = 3'b101;
BUS = -101;
#5
BUS = 72;
#5
BUS = 0;

#5
IR = 3'b100;
BUS = 1;
#5
BUS = -1;

end
endmodule