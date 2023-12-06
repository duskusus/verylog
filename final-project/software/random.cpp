#include "random.h"

int state = -1082357;
//https://en.wikipedia.org/wiki/Xorshift
int randumb() {
    state ^= state << 13;
    state ^= state >> 17;
    state ^= state << 5;
    return state;
}