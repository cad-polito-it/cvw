#include "tests.h"

const signature_t const GOLDEN_SIGNATURES[NUMTESTS] = {
	0xCAFECAFE,	// TEST1
};


// Info on cache instructions:
// https://docs.riscv.org/reference/isa/v20240411/unpriv/cmo.html


// cbo.flush --> flushes a cacheline 

// Flush all the cache
void cache_flush(void) {
    uint32_t *p = __data_start;
    uint32_t *end = __data_end;
    const unsigned line = CACHE_LINE_SIZE;   // size taken form derivlist.txt

    for (; p < end; p += line) {
        __asm__ volatile ("cbo.flush (%0)" :: "r"(p) : "memory");
    }
}
// Single cacheline flush
void cache_flush_block(void* addr) {
	__asm__ volatile ("cbo.flush (%0)" :: "r"(addr) : "memory");
}

//cbo.clean   --> Cleans a cache block

void cache_clean(void) {
    uint32_t *p = __data_start;
    uint32_t *end = __data_end;
    const unsigned line = CACHE_LINE_SIZE;   // size taken form derivlist.txt

    for (; p < end; p += line) {
        __asm__ volatile ("cbo.clean (%0)" :: "r"(p) : "memory");
    }
}

void cache_clean_block(void* addr) {
	__asm__ volatile ("cbo.clean (%0)" :: "r"(addr) : "memory");
}

//cbo.inval   --> Perform an invalidate operation on a cache block
void cache_inval(void) {
    uint32_t *p = __data_start;
    uint32_t *end = __data_end;
    const unsigned line = CACHE_LINE_SIZE;   // size taken form derivlist.txt

    for (; p < end; p += line) {
        __asm__ volatile ("cbo.inval (%0)" :: "r"(p) : "memory");
    }
}
void cache_inval_block(void* addr) {
	__asm__ volatile ("cbo.inval (%0)" :: "r"(addr) : "memory");
}

//cbo.zero    --> Store zeros to the full set of bytes corresponding to a cache block
void cache_zero(void) {
    uint32_t *p = __data_start;
    uint32_t *end = __data_end;
    const unsigned line = CACHE_LINE_SIZE;   // size taken form derivlist.txt

    for (; p < end; p += line) {
        __asm__ volatile ("cbo.zero (%0)" :: "r"(p) : "memory");
    }
}
void cache_zero_block(void* addr) {
	__asm__ volatile ("cbo.zero (%0)" :: "r"(addr) : "memory");
}

//prefetch.i  --> Provide a HINT to hardware that a cache block is likely to be accessed by an instruction fetch in the near futures
//prefetch.r  --> Provide a HINT to hardware that a cache block is likely to be accessed by a data read in the near future
//prefetch.w  --> Provide a HINT to hardware that a cache block is likely to be accessed by a data write in the near future

// TODO: March test function



int main(void)
{
	// test1();

    march_c_minus_one_way();

 	return 0;
}
