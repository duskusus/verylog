#pragma once
#include "blockstypes.h"

class gpu
{
	uint16_t primitive_count = 0;

public:
	gpu();
	void setClearColor(uint16_t color);
	void pushQuad(const Quad &q);
	void clearVertices();
	void setPrimCount(uint16_t);
};
