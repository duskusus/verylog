#include "chunk.h"
#include <stdlib.h>

const vec3 cubeVertices[] = {{0, 0, 1}, {1, 0, 1}, {1, 1, 1}, {0, 1, 1},
                                  {0, 0, 0}, {1, 0, 0}, {1, 1, 0}, {0, 1, 0}};

uint8_t nullblock = 0;

Chunk::Chunk(): blockarray{0} {};

Chunk::~Chunk() {};

uint8_t &Chunk::getBlock(int x, int y, int z) {
	if(x > 0 && x < 16 && y > 0 && y < 320 && z > 0 && z < 320)
		return blockarray[y * 256 + z * 16 + x];
	nullblock = 0;
	return nullblock;
}

void Chunk::generateBlocks() {
	for (int x = 0; x < 16; x++) {
		for (int z = 0; z < 16; z++) {
			int h = rand() % 16;
			for(int y = 0; y < h; y++) {
				getBlock(x, y, z) = rand() % 254 + 1;
			}
		}
	}
}

void Chunk::writeVertices(gpu &g) {
	for (int x = 0; x < 16; x++) {
		for (int z = 0; z < 16; z++) {
			for(int y = 0; y < 16; y++) {
				writeVerticesForBlock(g, x, y, z);
			}
		}
	}
}

void Chunk::writeVerticesForBlock(gpu &g, int x, int y, int z) {
	if(getBlock(x, y, z) == 0)
		return;

	uint16_t color = getBlock(x, y, z);
	color |= color << 8;
	vec3 bp(x, y, z);

    if (getBlock(x - 1, y, z) < 1) {
        // left face
        const uint8_t indices[] = {0, 3, 7, 4};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                        bp + cubeVertices[indices[1]],
                        bp + cubeVertices[indices[2]],
                        bp + cubeVertices[indices[3]], color));
    }

    if (getBlock(x + 1, y, z) < 1) {
        // right face
        const uint8_t indices[] = {1, 5, 6, 2};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                        bp + cubeVertices[indices[1]],
                        bp + cubeVertices[indices[2]],
                        bp + cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y - 1, z) < 1) {
        // bottom face
        const uint8_t indices[] = {0, 4, 5, 1};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                        bp + cubeVertices[indices[1]],
                        bp + cubeVertices[indices[2]],
                        bp + cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y + 1, z) < 1) {
        // top face
        const uint8_t indices[] = {3, 2, 6, 7};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                        bp + cubeVertices[indices[1]],
                        bp + cubeVertices[indices[2]],
                        bp + cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y, z - 1) < 1) {
        // back face
        const uint8_t indices[] = {7, 6, 5, 4};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                bp + cubeVertices[indices[1]],
                bp + cubeVertices[indices[2]],
                bp + cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y, z + 1) < 1) {
        // front face
        const uint8_t indices[] = {0, 1, 2, 3};

        g.pushQuad(Quad(bp + cubeVertices[indices[0]],
                        bp + cubeVertices[indices[1]],
                        bp + cubeVertices[indices[2]],
                        bp + cubeVertices[indices[3]], color));
    }
}

