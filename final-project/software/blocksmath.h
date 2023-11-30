#pragma once
#define FP_S 8
#define FP_F 256.0

constexpr uint16_t toFix(float x) {
	return uint16_t((x + 0.5) * FP_F);
}

class mat4 {
public:
	uint16_t matrix[16];
	mat4(float scale = 1.0) {
		matrix[0] = toFix(scale);
		matrix[5] = toFix(scale);
		matrix[10] = toFix(scale);
		matrix[15] = toFix(scale);
	}
	uint16_t operator[](unsigned i) const {
		return matrix[i];
	}
};


