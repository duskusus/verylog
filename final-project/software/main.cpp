
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "chunk.h"
#include <stdlib.h>
#include <math.h>
#include <unistd.h>
#include "random.h"

int frameWidth = 320;
int frameHeight = 240;

int f2sc(float x)
{
	return int(240.0 * (0.5 + x * 0.5) + 0.5);
}

uint32_t *control_regs = (uint32_t *)0x44a10000;
int main()
{
	srand(45093485);
	init_platform();
	// while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 rot(1.0);
	g.setViewMatrix(rot);
	Chunk c;
	xil_printf("generating blocks\n");
	c.generateBlocks();
	xil_printf("done generating blocks\n");
	g.setPrimCount(2000);
	xil_printf("set prim count\n");
	for (int i = 0; true; i++)
	{
		float t = float(i) / 240.0;

		xil_printf("loop %d, random: %d\n", i, randumb());
		float vm[16] = {
				cos(t), 0, sin(t), 0,
				0, 1, 0, 0,
				-sin(t), 0, cos(t), -1.0,
				0, 0, 0, 0
		};

		rot.copy(vm);
		g.setViewMatrix(rot);

		c.writeVertices(g);
		g.done();
		usleep(500);
		g.clearVertices();
	}
	cleanup_platform();
	return 0;
}
