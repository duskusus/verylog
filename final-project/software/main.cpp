
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "chunk.h"
#include <math.h>
#include "random.h"

int main()
{
	init_platform();
	// while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 rot(1.0);
	g.setViewMatrix(rot);
	Chunk c;
	c.generateBlocks();
	for (int i = 0; true; i++)
	{

		float t = float(i) / 60.0;

		//xil_printf("loop %d, random: %d\n", i, randumb());

		if(i % 100 == 0)
			c.generateBlocks();

		float vm[16] = {
				cos(t), 0, sin(t), 0,
				0, 1, 0, -512,
				-sin(t), 0, cos(t), float(i),
				0, 0, 0, 0
		};

		rot.copy(vm);
		g.setViewMatrix(rot);

		c.writeVertices(g);
		g.done();
	}
	cleanup_platform();
	return 0;
}
