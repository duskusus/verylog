#pragma once
#define FP_S 8
#define FP_F 256.0
#include "blockstypes.h"
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
	uint16_t &operator[](unsigned i) {
		return matrix[i];
	}
	vec3 operator *(const vec3 &v) const {
		uint32_t x = v.x * matrix[0] + v.y * matrix[1] + v.z * matrix[2] + matrix[3];
		uint32_t y = v.x * matrix[4] + v.y * matrix[5] + v.z * matrix[6] + matrix[7];
		uint32_t z = v.x * matrix[8] + v.y * matrix[9] + v.z * matrix[10] + matrix[11];
		return vec3(x >> 8, y >> 8, z >> 8);
	}
	mat4 operator *(const mat4 &other) const {
		mat4 r;
		for (int i = 0; i < 16; i++) {
			for (int j = 0; j < 16; j++) {
				uint32_t n = 0;
				for (int k = 0; k < 4; k++) {
					n += matrix[4*i+j] * other[4*k+j];
				}
				r[i*4+j] = n >> 8;
			}
		}
		return r;
	}
	vec3 perspectiveTransform() const {

			uint32_t x = x * matrix[0] + y * matrix[1] + z * matrix[2] + matrix[3];
			uint32_t y = x * matrix[4] + y * matrix[5] + z * matrix[6] + matrix[7];
			uint32_t z = x * matrix[8] + y * matrix[9] + z * matrix[10] + matrix[11];

			//z divide
			x = x / z;
			y = y / z;

			return vec3(x >> 8, y >> 8, z >> 8);
		}
};


