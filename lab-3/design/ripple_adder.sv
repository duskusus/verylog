module ripple_adder
(
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    wire [16:0] c; //unsure if I should use logic or wire here
    assign c[0] = cin;
    generate
    
        for (genvar i = 0; i < 16; i = i + 1) begin: rca_16
        full_adder fa(.A(A[i]), .B(B[i]), .cin(c[i]), .S(S[i]), .cout(c[i+1]));
    end
    assign cout = c[16];
    endgenerate
    
endmodule

module full_adder
(
    input logic A, B, cin,
    output logic S, cout
);
    assign S = A ^ B ^ cin;
    assign c = (A & B) | (B & cin) | (A & cin);
endmodule