

module Toplevel(
    input logic         Clk,        //internal
                        Reset_B,      //button
//                        Load_B,     //button
                        Run_B,          //button
    input logic  [7:0]  Din,        //switches
    output logic [7:0]  Aval,       //debug
    output logic [7:0]  Bval,       //debug
    output logic        Xval,       //debug
    output logic [7:0]  hex_seg,    // Hex display control
    output logic [3:0]  hex_grid    // Hex display control
//    ,output logic [16:0] prod        //debug
    );
    
	      (* syn_keep = "true", mark_debug = "true" *) logic Ld_XA, Ld_B, newX, newA, newB, Shift_En, opA, opB, opX, X, fn, XS, Clr, Reset, Run;
	      (* syn_keep = "true", mark_debug = "true" *) logic [7:0] A, B, Din_S;
    
//     assign prod = {X, A, B};
     assign Aval = A;
     assign Bval = B;
     assign Xval = X;
     assign newX = 0;
	
	 register_unit    reg_unit (
                        .Clk(Clk),
                        .Reset(Reset),
                        .Ld_A(Ld_XA), //note these are inferred assignments, because of the existence a logic variable of the same name
                        .Ld_B,
                        .Ld_X(Ld_XA),
                        .Shift_En(Shift_En),
                        .D(Din),
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
//                        .LoadB(Load_B),
                        .Run(Run),
                        .Shift_En(Shift_En),
                        .Clear(Clr),
                        .Ld_XA,
                        .Ld_B,
                        .addsub(fn),
                        .B(B) );
                        
    subadder        sub_adder (
                        .fn(fn),
                        .A(A),
                        .B(Din),
                        .X_S(XS),
                        .S(Din_S) );     
                        
    posedgedet      pos_edge_det (
                        .sig(Run_B),
                        .clk(Clk),
                        .pe(Run)
                       );               
    
    HexDriver       HexA(
                        .clk(Clk),
                        .reset(Reset_B),
                        .in({Din[7:4], Din[3:0], B[7:4], B[3:0]}),
                        .hex_seg(hex_seg),
                        .hex_grid(hex_grid) );
                        
endmodule