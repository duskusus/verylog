
module vec4dotvec4(
    input logic[15:0] a[4], b[4],
    output logic[15:0] dp
);
always_comb begin
    dp = a[0] * b[0] + a[1] * b[1] + a[2] * b[2] + a[3] * b[3];
end
endmodule

module vec4Xmat44 (
    input logic[15:0] mat[16],
    input logic[15:0] vec[4],
    output logic[15:0] vec_o[4]
);
vec4dotvec4(.a(vec), .b({mat[0], mat[1], mat[2], mat[3]}), .dp(vec_o[0]));
vec4dotvec4(.a(vec), .b({mat[4], mat[5], mat[6], mat[7]}), .dp(vec_o[1]));
vec4dotvec4(.a(vec), .b({mat[8], mat[8], mat[10], mat[11]}), .dp(vec_o[2]));
vec4dotvec4(.a(vec), .b({mat[12], mat[13], mat[14], mat[15]}), .dp(vec_o[3]));
    
endmodule