#include "gpu.h"
#include "xil_printf.h"
#include <cmath>
#include <algorithm>
#include <unistd.h>

bool isClipped(const Quad &q)
{
	bool ic = false;
	for (int i = 0; i < 4; i++)
	{
		ic = ic || (q.vs[i].x < 0 || q.vs[i].x > 320);
		ic = ic || (q.vs[i].y < 0 || q.vs[i].y > 240);
		ic = ic || (q.vs[i].z < 255);
	}
	return ic;
}
float toFloatb(int16_t x)
{
	return float(x) / 256.0;
}
#define MAX_QUADS 2048
typedef struct
{
	Quad geometry[MAX_QUADS];
	uint8_t padding[0x10000 - sizeof(Quad) * MAX_QUADS];
	uint32_t prim_count;  // CHANGE THIS TO UINT16_T !! (and gpu.sv)
	uint32_t clear_color; // CHANGE THIS TO UINT16_T !! (and gpu.sv)
	uint32_t run_rasterizer;
	uint16_t view_mat[16];
} gpu_device;

gpu_device *g = (gpu_device *)0x44a00000;
uint32_t *control_regs_ = (uint32_t *)0x44a10000;

gpu::gpu()
{
	// xil_printf("offset: %d\n", ((uint32_t)&g->prim_count) - ((uint32_t)g));
}
gpu::gpu(const gpu &g)
{
	viewMatrix.copy(g.viewMatrix.matrix);
	primitive_count = g.primitive_count;
}

void gpu::pushQuad2d(const Quad &pquad)
{
	if (primitive_count > MAX_QUADS)
	{
		xil_printf("ERROR: Can't store anymore quads\n");
		return;
	}

	g->geometry[primitive_count] = pquad;
	primitive_count ++;
}

void gpu::pushQuad(const Quad &pquad)
{
	if (primitive_count > MAX_QUADS)
	{
		return;
	}

	Quad nq;

	for (int i = 0; i < 4; i++)
	{
		nq.vs[i] = viewMatrix.perspectiveTransform(pquad.vs[i]);
		nq.color = pquad.color;
	}
	
	if(!isClipped(nq))
		pushQuad2d(nq);
}

void gpu::setClearColor(uint16_t color)
{
	g->clear_color = color;
}

void gpu::clearVertices()
{
	primitive_count = 0;
}

void gpu::setPrimCount(uint16_t prim_count)
{
	g->prim_count = prim_count;
	xil_printf("Prim Count: %d\n", prim_count);
}

void gpu::setViewMatrix(const mat4 &pmat)
{
	viewMatrix = pmat;
}

void gpu::done() 
{
	setPrimCount(primitive_count);
	g->run_rasterizer = -1;
	usleep(1);
	g->run_rasterizer = 0;
}
