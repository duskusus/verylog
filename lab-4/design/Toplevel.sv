

module Toplevel(
    input logic         Clk,        //internal
                        Reset_B,      //button
                        Load_B,     //button
    input logic  [7:0]  Din,        //switches
    output logic [7:0]  Aval,       //debug
    output logic [7:0]  Bval,       //debug
    output logic        Xval,       //debug
    output logic [7:0]  hex_seg,    // Hex display control
    output logic [3:0]  hex_grid    // Hex display control
    );
    
	 logic Reset, Run;
	 logic Ld_A, Ld_B, Ld_X, newX, newA, newB, Shift_En, opA, opB, opX, X, fn, XS, Clr;
	 logic [7:0] A, B, Din_S;
    
    
     assign Aval = A;
     assign Bval = B;
     assign Xval = X;
     assign newX = 0;
	
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset_SH),
                        .Ld_A, //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B,
                        .Ld_X,
                        .Shift_En,
                        .D(Din_S),
                        .Sum(Din_S),
                        .A_In(opX),
                        .B_In(opA),
                        .X_In(newX),
                        .XSum(XS),
                        .Clear(Clr),
                        .A_out(opA),
                        .B_out(opB),
                        .X_out(opX),
                        .A(A),
                        .B(B),
                        .X(X) );
                                                
	 control          control_unit (
                        .Clk(Clk),
                        .Reset(Reset),
                        .ResetB(Reset_B),
                        .LoadB(Load_B),
                        .Run(Run),
                        .Shift_En,
                        .Clear(Clr),
                        .Ld_A,
                        .Ld_B,
                        .Ld_X,
                        .addsub(fn),
                        .B(B) );
                        
    subadder        sub_adder (
                        .fn(fn),
                        .A(A),
                        .B(Din_S),
                        .X_S(XS) );                    
    
    HexDriver       HexA(
                        .clk(Clk),
                        .reset(Reset_SH),
                        .in({A[7:4], A[3:0], B[7:4], B[3:0]}),
                        .hex_seg(hex_seg),
                        .hex_grid(hex_grid) );
                        
endmodule
