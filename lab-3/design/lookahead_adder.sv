    module lookahead_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    logic P0, G0, C0;
    assign C0 = cin;
    cla_4 cl4_0(.x(A[3:0]), .y(B[3:0]), .z(C0), .S(S[3:0]), .P(P0), .G(G0));
    
    logic P1, G1;
    assign C1 = C0 & P0 | G0;
    cla_4 cl4_1(.x(A[7:4]), .y(B[7:4]), .z(C1), .S(S[7:4]), .P(P1), .G(G1));
    
    logic P2, G2;
    assign C2 = (C0 & P0 | G0) & P1 | G1;
    cla_4 cl4_2(.x(A[11:8]), .y(B[11:8]), .z(C2), .S(S[11:8]), .P(P2), .G(G2));
    
    logic P3, G3;
    assign C3 = ((C0 & P0 | G0) & P1 | G1) & P2 | G2;
    cla_4 cl4_3(.x(A[15:12]), .y(B[15:12]), .z(C3), .S(S[15:12]), .P(P3), .G(G3));
    
    assign cout = (((C0 & P0 | G0) & P1 | G1) & P2 | G2) & P3 | G3; // cout = C3 & P3 | G3

endmodule

module cla_4(
    input logic[3:0] x, y,
    input logic z,
    output logic[3:0] S,
    output logic P, G
    );
    
    logic P0, G0, C0;
    assign C0 = z;
    pg_adder a0(.x(x[0]), .y(y[0]), .z(C0), .S(S[0]), .P(P0), .G(G0));
    
    logic P1, G1;
    assign C1 = C0 & P0 | G0;
    pg_adder a1(.x(x[1]), .y(y[1]), .z(C1), .S(S[1]), .P(P1), .G(G1));
    
    logic P2, G2;
    assign C2 = (z & P0 | G0) & P1 | G1;
    pg_adder a2(.x(x[2]), .y(y[2]), .z(C2), .S(S[2]), .P(P2), .G(G2));
    
    logic P3, G3;
    assign C3 = ((z & P0 | G0) & P1 | G1) & P2 | G2;
    pg_adder a3(.x(x[3]), .y(y[3]), .z(C3), .S(S[3]), .P(P3), .G(G3));
    
    assign P = P0 & P1 & P2 & P3;
    assign G = G3 | G2 & P3 | G1 & P3 & P2 | G0 & P3 & P2 & P1;
    
endmodule
module pg_adder(
    input logic x, y, z,
    output logic S, P, G
    );
    assign G = x & y;
    assign P = x ^ y;
    assign S = x ^ y ^ z;
endmodule
    
    
    
