#pragma once
#define FP_S 6
#define FP_F 64.0
#include "blockstypes.h"
#include "xil_printf.h"
class mat4
{
public:
	int16_t matrix[16];
	mat4(float scale = 1.0)
	{
		matrix[0] = toFix(scale);
		matrix[5] = toFix(scale);
		matrix[10] = toFix(scale);
		matrix[15] = toFix(scale);
	}
	int16_t operator[](unsigned i) const
	{
		return matrix[i];
	}
	int16_t &operator[](unsigned i)
	{
		return matrix[i];
	}
	vec3 operator*(const vec3 &v) const
	{
		int32_t x = v.x * matrix[0] + v.y * matrix[1] + v.z * matrix[2] + matrix[3];
		int32_t y = v.x * matrix[4] + v.y * matrix[5] + v.z * matrix[6] + matrix[7];
		int32_t z = v.x * matrix[8] + v.y * matrix[9] + v.z * matrix[10] + matrix[11];
		return vec3(x >> 6, y >> 6, z >> 6);
	}
	void copy(const float nm[16])
	{
		for (int i = 0; i < 16; i++)
		{
			matrix[i] = toFix(nm[i]);
		}
	}
	void copy(const int16_t nm[16])
	{
		for (int i = 0; i < 16; i++)
		{
			matrix[i] = toFix(nm[i]);
		}
	}
	mat4 operator*(const mat4 &other) const
	{
		mat4 r;
		for (int i = 0; i < 4; i++)
		{
			for (int j = 0; j < 4; j++)
			{
				int32_t n = 0;
				for (int k = 0; k < 4; k++)
				{
					n += matrix[4 * i + j] * other[4 * k + j];
				}
				r[i * 4 + j] = n >> 6;
			}
		}
		return r;
	}
	vec3 perspectiveTransform(const vec3 &v) const
	{

		int32_t x = v.x * matrix[0] + v.y * matrix[1] + v.z * matrix[2] + matrix[3];
		int32_t y = v.x * matrix[4] + v.y * matrix[5] + v.z * matrix[6] + matrix[7];
		int32_t z = v.x * matrix[8] + v.y * matrix[9] + v.z * matrix[10] + matrix[11];

		// z divide and centering
		x = ((x << 6) / z) + (1 << 6);
		y = (1 << 6) - ((y << 6) / z);

		int16_t xp = (x * 120) / 64;
		int16_t yp = (y * 120) / 64;
		int16_t zp = z / 64;
		//xil_printf("[%d, %d, %d]\n", xp, yp, zp);
		return vec3(xp, yp, zp);
	}

	void translate(const vec3 &v)
	{
		int16_t tl[16] = {
			1, 0, 0, 0,
			0, 1, 0, 0,
			0, 0, 1, 0,
			v.x, v.y, v.z, 1};
		mat4 tm;
		tm.copy(tl);
		*this = tm * (*this);
	}
};
