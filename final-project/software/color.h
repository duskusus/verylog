#include <stdint.h>

float clamp(float x, float min, float max)
{
	if (x > max)
		return max;
	if (x < min)
		return min;
	return x;
}

uint16_t rgb565f(float r, float g, float b)
{
	r = clamp(r, 0, 0.98);
	g = clamp(g, 0, 0.98);
	b = clamp(b, 0, 0.98);
	uint8_t r5 = (uint8_t)(32.0 * r);
	uint8_t g6 = (uint8_t)(64.0 * g);
	uint8_t b5 = (uint8_t)(32.0 * b);
	xil_printf("r: %d, g: %d, b: %d\n", r5, g6, b5);
	return (r5 << 11) | (g6 << 5) | b5;
}

uint16_t rgb565(uint8_t r, uint8_t g, uint8_t b)
{
	return ((r % 32) << 11) | ((g % 64) << 5) | (b % 32);
}
