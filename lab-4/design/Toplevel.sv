module Toplevel(
    input logic         Clk,        //internal
                        Reset,      //button
                        Load B,     //button
    input logic [7:0]   Din,        //switches
    output logic [7:0]  Aval,       //debug
    output logic [7:0]  Bval,       //debug
    output logic        Xval,       //debug
    output logic [7:0]  hex_seg,    // Hex display control
    output logic [3:0]  hex_grid    // Hex display control
    );
    
	 logic Reset_SH, LoadB_SH, LoadX_SH, Run_SH, LoadA_SH;
	 logic Ld_A, Ld_B, Ld_X, newX, newA, newB, Shift_En, opA, opB, opX, X, fn;
	 logic [7:0] A, B, Din_S;
    
    
     assign Aval = A;
     assign Bval = B;
     assign Xval = X;
	
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Ld_A, //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B,
                        .Ld_X,
                        .Shift_En,
                        .D(Din_S),
                        .A_In(newA),
                        .B_In(newB),
                        .X_In(newX),
                        .A_out(opA),
                        .B_out(opB),
                        .X_out(opX),
                        .A(A),
                        .B(B),
                        .X(X) );
                        
                        
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .LoadB(LoadB_SH),
                        .LoadX(LoadX_SH),
                        .LoadA(LoadA_SH),
                        .Run(Run_SH),
                        .Shift_En,
                        .Ld_A,
                        .Ld_B,
                        .Ld_X,
                        .B(B) );
                        
    subadder        sub_adder (
                        .fn(fn),
                        .A(A),
                        .D(Din_S),
                        .X_S(newX) );                    
    
    HexDriver       HexA(
                        .clk(Clk),
                        .reset(Reset_SH),
                        .in({A[7:4], A[3:0], B[7:4], B[3:0]}),
                        .hex_seg(hex_seg),
                        .hex_grid(hex_grid) );
                        
endmodule
