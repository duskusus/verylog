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
    logic[7:0] Ain;
    logic Xin;
    subadder sa(.A(Ain), .B(SW), .fn(fn), .S(S), .X_S(X));
    assign prod = {Xval, Aval[7:0], Bval[7:0]};
    always_comb begin
        if(count == 0)
        begin
            Ain = 0;
            Xin = 0;
        end
        else begin
            Ain = Aval;
            Xin = Xval;
        end
    end
    HexDriver HexA(.clk(Clk), .reset(Reset_Load_Clear),.in({Aval[7:4], Aval[3:0], Bval[7:4], Bval[3:0]}),.hex_seg(hex_seg),.hex_grid(hex_grid));
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
        if(count == 6)
                fn <= 1; // to prepare for next add, which is actually a subtraction 
        if(Bval[0])
        begin
            
            
            // XA = A + B >> 1
            Xval <= X;
            Aval <= {X, S[7:1]};
            Bval <= {S[0], Bval[7:1]};

        end
        else
        begin
        //Just shift
            Aval <= {Xin, Ain[7:1]};
            Bval <= {Ain[0], Bval[7:1]};
        end
        end
        if(!Run)
            count <= 0;
    end
endmodule