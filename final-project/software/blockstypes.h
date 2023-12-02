#pragma once
#include <stdint.h>

//#pragma pack(1)
struct vec2
{
	int16_t x;
	int16_t y;
	vec2(){};
	vec2(int16_t p_x, int16_t p_y) : x(p_x), y(p_y){};
	vec2 operator+(const vec2 &other) const {
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
	vec3(int16_t p_x, int16_t p_y, int16_t p_z) : x(p_x), y(p_y), z(p_z){};
	vec3(const vec2 &v2) : x(v2.x), y(v2.y), z(1){};
};

#pragma pack(1)
struct Quad
{
	vec3 vs[4];	   // vertices
	int16_t invz; // proportional to 1/z at center of quad
	int16_t color;
	uint8_t padding[32 - 4 * sizeof(vec3) - 2 * sizeof(uint16_t)];
	void operator=(const Quad &other) {
		for(int i = 0; i < 4; i++) {
			vs[i] = other.vs[i];
		}
		color = other.color;
		invz = other.invz;
	}
	Quad(){};
};
