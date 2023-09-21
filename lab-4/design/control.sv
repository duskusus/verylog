
module control(
    input Clk, Reset, Run LoadX, LoadB, LoadA,
    input logic [7:0] B,
    output Shift_En, Ld_A, Ld_B, Ld_X
    );
    logic [3:0] counting, counter;
    always_ff @ (posedge Clk)
    begin
        counting <= counter;
    end
    
    
endmodule
