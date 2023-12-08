#include "chunk.h"
#include "color.h"
#include <stdlib.h>
#include "random.h"
#define FPSH 6

const vec3 CcubeVertices[] = {{0, 0, 1 << FPSH}, {1 << FPSH, 0, 1 << FPSH}, {1 << FPSH, 1 << FPSH, 1 << FPSH}, {0, 1 << FPSH, 1 << FPSH}, {0, 0, 0}, {1 << FPSH, 0, 0}, {1 << FPSH, 1 << FPSH, 0}, {0, 1 << FPSH, 0}};

uint8_t nullblock = 1;

Chunk::Chunk() : blockarray{0} {};

Chunk::~Chunk(){};

uint8_t &Chunk::getBlock(int x, int y, int z)
{
    if (x > 0 && x < CSIZE && y > 0 && y < CSIZE && z > 0 && z < CSIZE)
        return blockarray[x * (CSIZE * CSIZE) + y * CSIZE + z];
    nullblock = 1;
    return nullblock;
}

void Chunk::generateBlocks()
{

    for (int x = 0; x < CSIZE; x++)
    {
        for (int y = 0; y < CSIZE; y++)
        {
            if(randumb() % 2 == 1)
                heightmap[x + y * CSIZE] = std::abs(x - CSIZE / 2) + std::abs(y - CSIZE / 2);
            else
                heightmap[x + y * CSIZE] = 0;
        }
    }

    for (int x = 0; x < CSIZE; x++)
    {
        for (int z = 0; z < CSIZE; z++)
        {
            int h = heightmap[x + z * CSIZE];
            uint8_t r = randumb() % 256;
            getBlock(x, h, z) = r;
        }
    }
}

void Chunk::writeVertices(gpu &g)
{
    for (int x = 0; x < CSIZE; x++)
    {
        for (int z = 0; z < CSIZE; z++)
        {
            for (int y = 0; y < CSIZE; y++)
            {
                writeVerticesForBlock(g, x, y, z);
            }
        }
    }
}

void Chunk::writeVerticesForBlock(gpu &g, int x, int y, int z)
{
    if (getBlock(x, y, z) == 0) // this should probably go outside of this function
        return;

    uint8_t btype = getBlock(x, y, z);
    uint16_t color = rgb565(hash(btype) % 32, hash(btype + 7) % 64, hash(btype + 13) % 32);
    vec3 bp((x - CSIZE / 2) * 64, y * 64, (z - CSIZE / 2) * 64);

    vec3 cubeVertices[8];

    for (int i = 0; i < 8; i++)
    {
        cubeVertices[i] = bp + CcubeVertices[i];
    }

    if (getBlock(x - 1, y, z) < 1)
    {
        // left face
        const uint8_t indices[] = {0, 3, 7, 4};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }

    if (getBlock(x + 1, y, z) < 1)
    {
        // right face
        const uint8_t indices[] = {1, 5, 6, 2};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y - 1, z) < 1)
    {
        // bottom face
        const uint8_t indices[] = {0, 4, 5, 1};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y + 1, z) < 1)
    {
        // top face
        const uint8_t indices[] = {3, 2, 6, 7};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y, z - 1) < 1)
    {
        // back face
        const uint8_t indices[] = {7, 6, 5, 4};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }

    if (getBlock(x, y, z + 1) < 1)
    {
        // front face
        const uint8_t indices[] = {0, 1, 2, 3};

        g.pushQuad(Quad(cubeVertices[indices[0]],
                        cubeVertices[indices[1]],
                        cubeVertices[indices[2]],
                        cubeVertices[indices[3]], color));
    }
}