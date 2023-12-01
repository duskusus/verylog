/******************************************************************************
 *
 * Copyright (C) 2009 - 2014 Xilinx, Inc.  All rights reserved.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * Use of the Software is limited solely to applications:
 * (a) running on a Xilinx device, or
 * (b) that interact with a Xilinx device through a bus or interconnect.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * XILINX  BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
 * WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF
 * OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 * Except as contained in this notice, the name of the Xilinx shall not be used
 * in advertising or otherwise to promote the sale, use or other dealings in
 * this Software without prior written authorization from Xilinx.
 *
 ******************************************************************************/

/*
 * helloworld.c: simple test application
 *
 * This application configures UART 16550 to baud rate 9600.
 * PS7 UART (Zynq) is not initialized by this application, since
 * bootrom/bsp configures it to baud rate 115200
 *
 * ------------------------------------------------
 * | UART TYPE   BAUD RATE                        |
 * ------------------------------------------------
 *   uartns550   9600
 *   uartlite    Configurable only in HW design
 *   ps7_uart    115200 (configured by bootrom/bsp)
 */
#include "platform.h"
#include "xil_printf.h"
#include "color.h"
#include "gpu.h"
#include "blockstypes.h"
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

int frameWidth = 320;
int frameHeight = 240;

int f2sc(float x)
{
	return int(240.0 * (0.5 + x * 0.5) + 0.5);
}

void quadAt(const vec2 &v, gpu &g, float size = 1.0) {
	Quad q;
	q.vs[0] = v;
	q.vs[1] = v;

}

uint32_t *control_regs = (uint32_t *)0x44a10000;
int main()
{
	init_platform();
	xil_printf("Starting\n");
	//while(1);
	gpu g;
	g.setClearColor(rgb565(5, 42, 31));
	mat4 identity(1.0);
	//g.setViewMatrix(identity);
	// control_regs[0] = 200;
	//control_regs[1] = rgb565f(0.5, 0.5, 0.5);
	g.setPrimCount(200);
	xil_printf("startingq345345\n");
	for (int i = 0; true; i++)
	{
		for (int j = 0; j < 1; j ++)
		{
			for (int k = 0; k < 1; k++)
			{
				Quad q;

				float t = 0.01 * float(i);

				float x = (j * 40 + (i / 16) % 240);
				float y = (k * 40 + (i / 16) % 240);

				float phi = 3.14159 / 2.0;
				float sz = 20.0;
				q.vs[0] = vec2(sz * (1.0 + cos(t)) + x, sz * (1.0 + sin(t)) + y);
				uint16_t x1 = sz * (1.0 + 2.2 * cos(t + phi)) + x;
				uint16_t y1 = sz * (1.0 + 1.2 * sin(t + phi)) + y;

				q.vs[1] = vec2(x1, y1);
				q.vs[2] = vec2(sz * (1.0 + cos(t + phi * 2.0)) + x, sz * (1.0 + sin(t + phi * 2.0)) + y);
				q.vs[3] = vec2(sz * (1.0 + cos(t + phi * 3.0)) + x, sz * (1.0 + sin(t + phi * 3.0)) + y);
				//xil_printf("%d\n", q.vs[1].x);
				//x1 = q.vs[3].x;
				//y1 = q.vs[3].y;
				xil_printf("(%d, %d)\n", x1, y1);
				q.color = rgb565(j * 8, k * 8, 0);

				g.pushQuad(q);
			}
		}
		// control_regs[0] = 50;
		g.clearVertices();
	}
	cleanup_platform();
	return 0;
}
