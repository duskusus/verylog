#include "stdint.h"
#include "gpu.h"
#define CSIZE 20
class Chunk {
	uint8_t blockarray[CSIZE*CSIZE*CSIZE];
	uint8_t heightmap[CSIZE*CSIZE];
	void writeVerticesForBlock(gpu &g, int x, int y, int z);
public:
	Chunk();
	void generateBlocks();
	uint8_t &getBlock(int x, int y, int z);
	void writeVertices(gpu &g);
	~Chunk();
};
