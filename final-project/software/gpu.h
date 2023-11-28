
#include "stdint.h"

//uint16_t *gpu_baseaddr = (uint16_t *) 0x44a00000;
uint8_t *gpio_baseaddr = (uint8_t *) 0x40000000;

typedef struct {
	uint16_t x;
	uint16_t y;
}vec2;

typedef struct {
	vec2 verts[4];
	uint16_t color;
	uint8_t padding[14]; // ensure quad is 32 bytes
}quad;

typedef struct {
	uint16_t transformation_matrix[16];
	uint16_t primitive_count;
	uint16_t clear_color;
	quad geometry[];
}device_memory;

device_memory *device = (device_memory *) 0x44a00000;

void clear() {
	*gpio_baseaddr = 0xff;
	*gpio_baseaddr = 0x00;
}
