#include "tests.h"


const signature_t const GOLDEN_SIGNATURES[NUMTESTS] = {
	0xCAFECAFE,	// TEST1
};


// Info on cache instructions:
// https://docs.riscv.org/reference/isa/v20240411/unpriv/cmo.html

// cbo.flush --> flushes a cacheline 
extern char __data_start[];
extern char __data_end[];

void flush_data_section(void) {
    char *p = __data_start;
    char *end = __data_end;
    const unsigned line = 512;   // size taken form derivlist.txt

    for (; p < end; p += line) {
        __asm__ volatile ("cbo.flush (%0)" :: "r"(p) : "memory"); // actual flush
    }
}

//cbo.clean   --> Cleans a cache block
//cbo.inval   --> Perform an invalidate operation on a cache block
//cbo.zero    --> Store zeros to the full set of bytes corresponding to a cache block
//prefetch.i  --> Provide a HINT to hardware that a cache block is likely to be accessed by an instruction fetch in the near future
//prefetch.r  --> Provide a HINT to hardware that a cache block is likely to be accessed by a data read in the near future
//prefetch.w  --> Provide a HINT to hardware that a cache block is likely to be accessed by a data write in the near future



int main(void)
{
	int i, fails;
	signature_t signatures[NUMTESTS];
	
	signatures[TEST1] = test1();

	for(i=0; i<NUMTESTS; i++) {
		fails += signatures[i] != GOLDEN_SIGNATURES[i];
	}

 	return fails;
}
