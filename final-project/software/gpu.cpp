#include "gpu.h"
#include "xil_printf.h"

#define MAX_QUADS 2048
typedef struct
{
    Quad geometry[MAX_QUADS];
    uint8_t padding[0x10000 - sizeof(Quad) * MAX_QUADS];
    uint32_t prim_count;  // CHANGE THIS TO UINT16_T !! (and gpu.sv)
    uint32_t clear_color; // CHANGE THIS TO UINT16_T !! (and gpu.sv)
    uint16_t view_mat[16];
} gpu_device;

gpu_device *g = (gpu_device *)0x44a00000;

gpu::gpu() {
	xil_printf("offset: %d\n", ((uint32_t)&g->prim_count) - ((uint32_t)g));
}

void gpu::pushQuad(const Quad &pquad)
{
    if (primitive_count < MAX_QUADS)
    {
        g->geometry[primitive_count]	 = pquad;
        primitive_count++;
        //g->prim_count = primitive_count;
    }
    else
    {
        xil_printf("ERROR: can't store anymore quads\n");
    }
}

void gpu::setClearColor(uint16_t color)
{
    //g->clear_color = color;
}

void gpu::clearVertices()
{
    primitive_count = 0;
    //g->prim_count = 0;
}
