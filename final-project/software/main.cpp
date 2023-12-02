
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "chunk.h"
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

int frameWidth = 320;
int frameHeight = 240;

int f2sc(float x)
{
	return int(240.0 * (0.5 + x * 0.5) + 0.5);
}

uint32_t *control_regs = (uint32_t *)0x44a10000;
int main()
{
	init_platform();
	// while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 rot(1.0);
	g.setViewMatrix(rot);
	//Chunk c;
	xil_printf("generating blocks\n");
	//c.generateBlocks();
	xil_printf("done generating blocks\n");
	g.setPrimCount(200);
	xil_printf("set prim count\n");
	for (int i = 0; true; i++)
	{
		xil_printf("in loop\n");
		float t = float(i) / 120.0;
		xil_printf("%d\n", int(t));
		float nm[16] = {
			cos(t), 0, sin(t), 0,
			0, 1, 0, 0,
			-sin(t), 0, cos(t), 0,
			0, 0, 0, 1};
		rot.copy(nm);
		rot.translate(vec3(0, 0, -10));
		//g.setViewMatrix(rot);

		xil_printf("Starting write vertices\n");
		//c.writeVertices(g);
		xil_printf("Done writing vertices\n");

		usleep(16667);
		g.clearVertices();
	}
	cleanup_platform();
	return 0;
}
