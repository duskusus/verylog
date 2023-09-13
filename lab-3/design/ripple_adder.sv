module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    
    
    logic[16:0] c; //unsure if I should use logic or wire here
    assign c[0] = cin;
    generate
            for (genvar i = 0; i < 16; i = i + 1) begin: rca_16
            full_adder fa(.A(A[i]), .B(B[i]), .cin(c[i]), .S(S[i]), .cout(c[i+1]));
            end
    endgenerate
    assign cout = c[16];
    //assign S = A + B;
    //test testing line
endmodule

module adder_4
(
input logic[3:0] A, B,
input logic cin,
output logic[3:0] S,
output logic cout
);
    logic c0;
    full_adder fa0(.A(A[0]), .B(B[0]), .S(S[0]), .cin(cin), .cout(c0));
    logic c1;
    full_adder fa1(.A(A[1]), .B(B[1]), .S(S[1]), .cin(c), .cout(c1));
    logic c2;
    full_adder fa2(.A(A[2]), .B(B[2]), .S(S[2]), .cin(c1), .cout(c2));
    full_adder fa3(.A(A[3]), .B(B[3]), .S(S[3]), .cin(c2), .cout(cout));
endmodule

module adder_2
(
input logic[1:0] A, B,
input logic cin,
output logic[1:0] S,
output logic cout
);
    logic c0;
    full_adder fa0(.A(A[0]), .B(B[0]), .S(S[0]), .cin(cin), .cout(c0));
    full_adder fa1(.A(A[1]), .B(B[1]), .S(S[1]), .cin(c), .cout(c1));
endmodule

module full_adder
(
    input logic A, B, cin,
    output logic S, cout
);
    assign S = A ^ B ^ cin;
    assign cout = (A & B) | (B & cin) | (A & cin);
endmodule