#include "gpu.h"
#include "xil_printf.h"

#define MAX_QUADS 1024
typedef struct
{
    Quad geometry[MAX_QUADS];
    uint8_t padding[0x10000 - sizeof(Quad) * MAX_QUADS];
    uint32_t prim_count;  // CHANGE THIS TO UINT16_T !! (and gpu.sv)
    uint32_t clear_color; // CHANGE THIS TO UINT16_T !! (and gpu.sv)
    uint16_t view_mat[16];
} gpu_device;

gpu_device *g = (gpu_device *)0x44a00000;
uint32_t *control_regs_ = (uint32_t *)0x44a10000;

gpu::gpu() {
	xil_printf("offset: %d\n", ((uint32_t)&g->prim_count) - ((uint32_t)g));
}

void gpu::pushQuad(const Quad &pquad)
{
    if (primitive_count < MAX_QUADS)
    {
        g->geometry[primitive_count] = pquad;
        primitive_count++;
        //control_regs_[0] = primitive_count;
        //g->prim_count = primitive_count;
    }
    else
    {
        xil_printf("ERROR: can't store anymore quads\n");
    }
}

void gpu::setClearColor(uint16_t color)
{
    //control_regs_[1] = color;
	g->clear_color = color;
}

void gpu::clearVertices()
{
    primitive_count = 0;
    //control_regs_[0] = 0;
    //g->prim_count = 0;
}

void gpu::setPrimCount(uint16_t prim_count) {
	g->prim_count = prim_count;
}

void gpu::setViewMatrix(const mat4& pmat) {
	for (int i = 0; i < 16; i++) {
		g->view_mat[i] = pmat[i];
	}
}
