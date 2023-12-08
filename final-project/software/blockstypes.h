#pragma once
#include <stdint.h>
#define FP_F 64

constexpr int16_t toFix(float x)
{
	return int16_t((x * FP_F) + 0.5);
}

struct vec2
{
	int16_t x;
	int16_t y;
	vec2(){};
	vec2(int16_t p_x, int16_t p_y) : x(p_x), y(p_y){};
	vec2 operator+(const vec2 &other)
	{
		vec2 v(other.x + x, other.y + y);
		return v;
	}
};

struct vec3
{
	int16_t x;
	int16_t y;
	int16_t z;
	vec3(){};
	constexpr vec3(int16_t p_x, int16_t p_y, int16_t p_z) : x(p_x), y(p_y), z(p_z){};
	vec3(const vec2 &v2) : x(v2.x), y(v2.y), z(1){};
	vec3 operator+(const vec3 &v) {
		return vec3(x + v.x, y + v.y, z + v.z);
	}
	void operator = (const vec3 &v) {
		x = v.x;
		y = v.y;
		z = v.z;
	}
};

#pragma pack(1)
struct Quad
{
	vec3 vs[4];	   // vertices
	int16_t invz; // proportional to 1/z at center of quad
	uint16_t color;
	int8_t padding[32 - 4 * sizeof(vec3) - 2 * sizeof(int16_t)];

	void operator=(const Quad &other)
	{
		for (int i = 0; i < 4; i++)
		{
			vs[i] = other.vs[i];
		}
		color = other.color;
		invz = other.invz;
	}

	Quad(){};
	Quad(vec3 a, vec3 b, vec3 c, vec3 d, uint16_t color): vs{a, b, c, d}, color(color) {};
};

constexpr vec3 v3ff(float px, float py, float pz) {
	return vec3(toFix(px), toFix(py), toFix(pz));
}
