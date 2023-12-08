
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "chunk.h"
#include <math.h>
#include "random.h"

uint8_t *buttons = (uint8_t *)0x40000000;

int main()
{
	init_platform();
	// while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 rot(1.0);
	mat4 translate(1.0);
	g.setViewMatrix(rot);
	Chunk c;
	c.generateBlocks();
	float cam_x, cam_z, theta;
	theta = 0;
	cam_x = 0;
	cam_z = 0;
	for (int i = 0; true; i++)
	{

		float t = float(i) / 30.0;

		// xil_printf("loop %d, random: %d\n", i, randumb());

		if (i % 100 == 0)
			c.generateBlocks();

		float rotation_speed = 0.1;
		float movement_speed = 10;
		float dx = 0;
		float dz = 0;
		if ((*buttons) & 1)
		{
			dx = movement_speed * cos(theta);
			dz = movement_speed * sin(theta);
		}
		if (*(buttons) & 2)
		{
			theta -= rotation_speed;
		}
		if (*(buttons) & 4)
		{
			theta += rotation_speed;
		}
		cam_x += dx;
		cam_z += dz;
		

		translate = mat4(1.0);
		translate.translate(cam_x, -511, cam_z);
		float vm[16] = {
			cos(theta), 0, sin(theta), 0,
			0, 1, 0, -511,
			-sin(theta), 0, cos(theta), 0,
			0, 0, 0, 1};
		//rot.copy(vm);
		//rot.translate(cam_x, -10, cam_z);
		g.setViewMatrix(rot);
		if (*buttons)
		{
			xil_printf("(%d, %d)\n\n", int(cam_x), int(cam_z));
			//rot.print();

		}
		c.writeVertices(g);
		g.done();
	}
	cleanup_platform();
	return 0;
}
