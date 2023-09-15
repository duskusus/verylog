module select_adder (
	input  logic [15:0] A, B,
	input  logic cin,
	output logic [15:0] S,
	output logic cout
);
	(* syn_keep = "true", mark_debug = "true" *) logic [3:0] c, c_1, c_0, s10, s11, s20, s21, s30, s31;

	adder_4 a0(.A(A[3:0]), .B(B[3:0]), .cin(cin), .cout(c_0[0]), .S(S[3:0]));

	adder_4 a1_1(.A(A[7:4]), .B(B[7:4]), .cin(1'b1), .cout(c_1[1]), .S(s11));
	adder_4 a1_0(.A(A[7:4]), .B(B[7:4]), .cin(1'b0), .cout(c_0[1]), .S(s10));

	adder_4 a2_1(.A(A[11:8]), .B(B[11:8]), .cin(1'b1), .cout(c_1[2]), .S(s20));
	adder_4 a2_0(.A(A[11:8]), .B(B[11:8]), .cin(1'b0), .cout(c_0[2]), .S(s21));

	adder_4 a3_1(.A(A[15:12]), .B(B[15:12]), .cin(1'b1), .cout(c_1[3]), .S(s30));
	adder_4 a3_0(.A(A[15:12]), .B(B[15:12]), .cin(1'b0), .cout(c_0[3]), .S(s31));

always_comb begin

	c[0] = c_1[0] = c_0[0];

	c[1] = c_0[1] | (c_1[1] & c[0]);
	if (c[0] == 1'b1)
		S[7:4] = s11;
	else
		S[7:4] = s10;
	
	c[2] = c_0[2] | (c[1] & c_1[2]);
	if (c[1] == 1'b1)
		S[11:8] = s21;
	else
		S[11:8] = s20;

	c[3] = c_0[3] | (c[2] & c_1[3]);
	if (c[2] == 1'b1)
		S[15:12] = s31;
	else
		S[15:12] = s30;

	cout = c[3];

end
	
endmodule

