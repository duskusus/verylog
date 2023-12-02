
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "gpu.h"
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

int frameWidth = 320;
int frameHeight = 240;

int f2sc(float x)
{
	return int(240.0 * (0.5 + x * 0.5) + 0.5);
}

void quadAt(const vec2 &v, gpu &g, float size = 1.0)
{
	Quad q;
	q.vs[0] = v;
	q.vs[1] = v;
}

uint32_t *control_regs = (uint32_t *)0x44a10000;
int main()
{
	init_platform();
	xil_printf("Starting\n");
	// while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 rot(1.0);
	g.setViewMatrix(rot);
	//  control_regs[0] = 200;
	// control_regs[1] = rgb565f(0.5, 0.5, 0.5);
	g.setPrimCount(200);
	for (int i = 0; true; i++)
	{
		float t = float(i) / 120.0;
		xil_printf("%d\n", int(t));
		float nm[16] = {
			cos(t), 0, sin(t), 0,
			0, 1, 0, 0,
			-sin(t), 0, cos(t), 0};
		rot.copy(nm);
		g.setViewMatrix(rot);
		Quad q;
		float sz = 1.0;
		q.vs[0] = v3ff(sz, sz, -10.0);
		q.vs[1] = v3ff(0.0, sz, -10.0);
		q.vs[2] = v3ff(0, 0.0, -10.0);
		q.vs[3] = v3ff(sz, 0.0, -10.0);
		q.color = rgb565(31, 63, 11);
		g.pushQuad(q);
		usleep(16667);
		g.clearVertices();
	}
	cleanup_platform();
	return 0;
}
