#pragma once
#include "blocksmath.h"

class gpu
{
	uint16_t primitive_count = 0;
	uint16_t last_primitive_count;
	mat4 viewMatrix;

public:
	gpu();
	gpu(const gpu &g);
	void setClearColor(uint16_t color);
	void pushQuad(const Quad &q);
	void pushQuad2d(const Quad &q);
	void clearVertices();
	void setPrimCount(uint16_t);
	void setViewMatrix(const mat4 &pmat);
	void done();
};
