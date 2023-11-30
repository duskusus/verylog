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
uint32_t *control_regs = (uint32_t *)0x44a10000;
int main()
{
	init_platform();
	// while(1);
	gpu g;
	g.setClearColor(rgb565(10, 35, 31));
	mat4 identity(1);
	g.setViewMatrix(identity);
	// control_regs[0] = 200;
	//control_regs[1] = rgb565f(0.5, 0.5, 0.5);
	g.setPrimCount(100);
	for (int i = 0; true; i++)
	{
		Quad q;
		uint16_t sz = 200;
		q.vs[0] = vec3(sz, sz, 256);
		q.vs[1] = vec3(0, sz, 256);
		q.vs[2] = vec3(0, 0, 256);
		q.vs[3] = vec3(sz, 0, 256);
		g.pushQuad(q);
		usleep(1);
		// control_regs[0] = 50;
		//g.clearVertices();
	}
	cleanup_platform();
	return 0;
}
