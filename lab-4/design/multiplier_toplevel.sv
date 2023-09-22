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
        output logic Xval
    );
    logic fn, cin, X;
    logic[7:0] S;
    logic[4:0] count;
    logic [7:0] A_in;
    subadder sa(.A(A_in), .B(SW), .fn(fn), .S(S), .X_S(X));
    always_comb begin
        //prod = {Xval, Aval, Bval};
        if(count == 0)
        begin
            A_in = 0;
        end
        else begin
            A_in = Aval;
        end
    end
    HexDriver HexA(.clk(Clk), .reset(Reset_Load_Clear),.in({SW[7:4], SW[3:0], Bval[7:4], Bval[3:0]}),.hex_seg(hex_seg),.hex_grid(hex_grid));
    
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
            
            // XA = A + B >> 2
            Xval <= X;
            Aval <= {X, S[7:1]};
            Bval <= {S[0], Bval[7:1]};

        end
        else
        begin
        //Just shift
            Aval <= {Xval, A_in[7:1]};
            Bval <= {A_in[0], Bval[7:1]};
        end
        end
        else if(!Run)
        begin
            count <= 0;
            fn <= 0;
            //Aval <= 0;
            //Xval <= 0;
        end
    end
endmodule