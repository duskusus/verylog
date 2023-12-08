#include "random.h"

int state = -1082357;
//https://en.wikipedia.org/wiki/Xorshift
int randumb() {
    state = hash(state);
    return state;
}

int hash(int x) {
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = ((x >> 16) ^ x) * 0x45d9f3b;
    x = (x >> 16) ^ x;
    return x;
}