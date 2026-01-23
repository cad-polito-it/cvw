#include "test.h"

const signature_t const GOLDEN_SIGNATURES[NUMTESTS] = {
	0xCAFECAFE,	// TEST1
};

int main(void)
{

    march_c_minus_one_way();
    test_flush();

 	return 0;
}
