`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 09/20/2023 04:07:05 PM
// Design Name: 
// Module Name: multiplier_toplevel
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


module multiplier_toplevel(
        input logic Clk, Reset_Load_Clear, Run,
        input logic[7:0] SW,
        output logic[3:0] hex_grid, 
        output logic[7:0] hex_seg, Aval, Bval,
        output logic Xval,
        output logic[16:0] prod
    );
    logic fn, cin, X;
    logic[7:0] S;
    logic[4:0] count;
    subadder sa(.A(Aval), .B(SW), .fn(fn), .S(S), .X_S(X));
    assign prod = {X, Aval, Bval};
    always_ff @ (posedge Clk)
    begin
        if (Reset_Load_Clear)
        begin
            Aval <= 0;
            Bval <= SW;
            count <= 0;
            fn <= 0;
            Xval <= 0;
        end
        else if ((count < 8) & Run)
        begin
            count <= count + 1;
        if(Bval[0])
        begin
            if(count == 6)
                fn <= 1; // to prepare for next add, which is actually a subtraction
            Xval <= X; // XA = A + B;

            //store shifted sum (add and shift)
            Aval <= {X, S[7:1]};
            Bval <= {S[0], Bval[7:1]};

        end
        else
        begin
        //Just shift
            Aval <= {Xval, Aval[7:1]};
            Bval <= {Aval[0], Bval[7:1]};
        end
        end
    end
endmodule