module subadder
(
	input  [7:0] A, B,
	input         fn,
	output [7:0] S,
	output        X_S
//	,output cout
);
    

    logic[8:0] c;
    assign c[0] = fn;
    generate
            for (genvar i = 0; i < 8; i = i + 1) begin: rca_9
            full_adder fa(.A(A[i]), .B(B[i] ^ fn), .cin(c[i]), .S(S[i]), .cout(c[i+1]));
            end
    endgenerate
    full_adder fa(.A(A[7]), .B(B[7] ^ fn), .S(X_S), .cin(c[8]));
//    assign cout = c[8];
    //assign S = A + B;
    //test testing line
endmodule

module full_adder
(
    input logic A, B, cin,
    output logic S, cout
);
    assign S = A ^ B ^ cin;
    assign cout = (A & B) | (B & cin) | (A & cin);
endmodule