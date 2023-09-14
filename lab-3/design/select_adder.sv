module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
    logic [15:0] S1, S2;
    ripple_adder ra1(.A(A), .B(B), .cin(cin), .S(S1));
    ripple_adder ra2(.A(A), .B(B), .cin(cin), .S(S2));
	
endmodule
