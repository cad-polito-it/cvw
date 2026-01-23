#ifndef TESTS_H
#define TESTS_H

#define TEST1 0
#define NUMTESTS 1

#include <stdint.h>

// cache_line_size / 4
#define CACHE_LINE_SIZE 128
// CRC-32 Polynomial
#define LFSR_POLY 0x04C11DB7u

// extern uint8_t __data_start[];
// extern uint8_t __data_end[];
extern uint32_t __data_start[];
extern uint32_t __data_end[];
extern volatile uint32_t __signature;


typedef unsigned int signature_t;

extern signature_t test1(void);

void march_c_minus_one_way(void);
void test_flush(void);


#endif /*TESTS_H */
