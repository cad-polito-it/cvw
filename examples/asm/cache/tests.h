#ifndef TESTS_H
#define TESTS_H

#define TEST1 0
#define NUMTESTS 1

#include <stdint.h>

extern uint8_t __data_start[];
extern uint8_t __data_end[];

typedef unsigned int signature_t;

extern signature_t test1(void);

void march_c_minus_one_way(void);


#endif /*TESTS_H */
