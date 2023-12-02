#pragma once
#include "blocksmath.h"

class gpu
{
	uint16_t primitive_count = 0;

	mat4 viewMatrix;

public:
	gpu();
	gpu(const gpu &g);
	void setClearColor(uint16_t color) volatile;
	void pushQuad(const Quad &q);
	void clearVertices();
	void setPrimCount(uint16_t);
	void setViewMatrix(const mat4 &pmat);
};
