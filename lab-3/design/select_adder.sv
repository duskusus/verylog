module select_adder (
	input  [15:0] A, B,
	input         cin,
	output [15:0] S,
	output        cout
);
	logic [3:0] c, c_1, c_0, s10, s11, s20, s21, s30, s31;
	assign c_1[0] = cin;
	assign c_0[0] = cin;

	adder_4 a0_1(.A(A[3:0]), .B(B[3:0]), .cin(c_1[0]), .cout(c_1[1]), .S(S[3:0]));
	assign c_0[1] = c_1[1];

	adder_4 a1_1(.A(A[7:4]), .B(B[7:4]), .cin(1'b1), .cout(c_1[2]), .S(s11));
	adder_4 a1_0(.A(A[7:4]), .B(B[7:4]), .cin(1'b0), .cout(c_0[2]), .S(S10));
	assign c[1] = c_0[1] | (c_1[0] & c_1[1]);
	if (c[1] == 1'b1)
		assign S[7:4] = s11;
	else
		assign S[7:4] = s10;

	adder_4 a2_1(.A(A[11:8]), .B(B[11:8]), .cin(1'b1), .cout(c[3]));
	adder_4 a2_0(.A(A[11:8]), .B(B[11:8]), .cin(1'b0));
	assign c[2] = c_0[2] | (c_1[1] & c_1[2]);
		if (c[2] == 1'b1)
		assign S[11:8] = s21;
	else
		assign S[11:8] = s20;

	adder_4 a3_1(.A(A[15:12]), .B(B[15:12]), .cin(1'b1), .cout(cout));
	adder_4 a3_0(.A(A[15:12]), .B(B[15:12]), .cin(1'b0));
	assign c[3] = c_0[3] | (c_1[2] & c_1[3]);
	if (c[3] == 1'b1)
		assign S[15:12] = s31;
	else
		assign S[15:12] = s30;

	
endmodule

