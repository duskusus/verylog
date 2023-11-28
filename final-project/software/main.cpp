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
// #include "gpu.h"
#include <stdlib.h>
#include <math.h>
#include <unistd.h>

int frameWidth = 320;
int frameHeight = 240;

// volatile uint8_t* gpio_0 = 0x40000000;
volatile uint16_t *vertices = (uint16_t *)0x44a00000;
volatile uint32_t *controlRegs = (uint32_t *)0x44a02000;

int f2sc(float x)
{
	return int(240.0 * (0.5 + x * 0.5) + 0.5);
}

int main()
{
	init_platform();
	controlRegs[0] = 254;
	controlRegs[1] = rgb565(0.4, 0.4, 0.98);
	int j = 0;
	for (int i = 0; i < 80; i++)
			{
				float t = (float)(i + j);
				float phi = t * 0.05;
				float p = 3.14159 * 0.5;
				float z = 2.0 + cos(phi + i);
				float dx = 0.25 * (i % 10) - 0.75;
				float dy = 0.2 * (i / 10) - 0.75;
				int vi = i * 8;
				float s = 0.2;
				vertices[0 + vi] = f2sc(2.0 * s * cos(phi) / z + dx);
				vertices[1 + vi] = f2sc(2.0 * s * sin(phi) / z + dy);

				vertices[2 + vi] = f2sc(s * cos(phi + p) / z + dx);
				vertices[3 + vi] = f2sc(s * sin(phi + p) / z + dy);

				vertices[4 + vi] = f2sc(s * cos(phi + 2.0 * p) / z + dx);
				vertices[5 + vi] = f2sc(s * sin(phi + 2.0 * p) / z + dy);

				vertices[6 + vi] = f2sc(s * cos(phi + 3.0 * p) / z + dx);
				vertices[7 + vi] = f2sc(s * sin(phi + 3.0 * p) / z + dy);
			}
	while (1)
	{
		for (int i = 0; i < 100; i++)
		{
			float t = (float)(i + j);
			float phi = t * 0.05;
			float p = 3.14159 * 0.5;
			float z = 2.0 + cos(phi + i);
			float dx = 0.25 * (i % 10) - 0.75;
			float dy = 0.2 * (i / 10) - 0.75;
			int vi = i * 8;
			float s = 0.2;
			vertices[0 + vi] = f2sc(2.0 * s * cos(phi) / z + dx);
			vertices[1 + vi] = f2sc(2.0 * s * sin(phi) / z + dy);

			vertices[2 + vi] = f2sc(s * cos(phi + p) / z + dx);
			vertices[3 + vi] = f2sc(s * sin(phi + p) / z + dy);

			vertices[4 + vi] = f2sc(s * cos(phi + 2.0 * p) / z + dx);
			vertices[5 + vi] = f2sc(s * sin(phi + 2.0 * p) / z + dy);

			vertices[6 + vi] = f2sc(s * cos(phi + 3.0 * p) / z + dx);
			vertices[7 + vi] = f2sc(s * sin(phi + 3.0 * p) / z + dy);
		}
		xil_printf("%d\n", j);
		j++;
	}
	cleanup_platform();
	return 0;
}
