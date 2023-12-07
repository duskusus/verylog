#include "stdint.h"
#include "gpu.h"
class Chunk {
	uint8_t blockarray[4096];
	uint8_t heightmap[16 * 16];
	void writeVerticesForBlock(gpu &g, int x, int y, int z);
public:
	Chunk();
	void generateBlocks();
	uint8_t &getBlock(int x, int y, int z);
	void writeVertices(gpu &g);
	~Chunk();
};
