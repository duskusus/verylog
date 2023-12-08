#pragma once
#define FP_S 6
#define FP_F 64
#include "blockstypes.h"
class mat4
{
public:
	int16_t matrix[16];

	mat4(float scale = 1.0);

	int16_t operator[](unsigned i) const;
	int16_t &operator[](unsigned i);

	vec3 operator*(const vec3 &v) const;
	mat4 operator*(const mat4 &other) const;

	void copy(const float nm[16]);
	void copy(const int16_t nm[16]);

	vec3 perspectiveTransform(const vec3 &v) const;
	
	void translate(const vec3 &v);
};
