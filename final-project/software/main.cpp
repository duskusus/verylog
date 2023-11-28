#include "xil_printf.h"
int main() {
	for (int i = 0; i < 5000; i++) {
		xil_printf("%d\n", i);
	}
}
//comment
