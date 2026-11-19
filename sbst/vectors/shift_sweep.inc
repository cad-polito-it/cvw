/* shift_vectors.inc (copy into sbst/ to use it): the table of shift_test.S. 32 pairs: one value, every amount. */
.equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */

.section .TEST_RODATA, "a"
.balign 4
.globl shift_vectors, shift_vectors_end
shift_vectors:
    .word 0x80000001, 0x00000000
    .word 0x80000001, 0x00000001
    .word 0x80000001, 0x00000002
    .word 0x80000001, 0x00000003
    .word 0x80000001, 0x00000004
    .word 0x80000001, 0x00000005
    .word 0x80000001, 0x00000006
    .word 0x80000001, 0x00000007
    .word 0x80000001, 0x00000008
    .word 0x80000001, 0x00000009
    .word 0x80000001, 0x0000000a
    .word 0x80000001, 0x0000000b
    .word 0x80000001, 0x0000000c
    .word 0x80000001, 0x0000000d
    .word 0x80000001, 0x0000000e
    .word 0x80000001, 0x0000000f
    .word 0x80000001, 0x00000010
    .word 0x80000001, 0x00000011
    .word 0x80000001, 0x00000012
    .word 0x80000001, 0x00000013
    .word 0x80000001, 0x00000014
    .word 0x80000001, 0x00000015
    .word 0x80000001, 0x00000016
    .word 0x80000001, 0x00000017
    .word 0x80000001, 0x00000018
    .word 0x80000001, 0x00000019
    .word 0x80000001, 0x0000001a
    .word 0x80000001, 0x0000001b
    .word 0x80000001, 0x0000001c
    .word 0x80000001, 0x0000001d
    .word 0x80000001, 0x0000001e
    .word 0x80000001, 0x0000001f
shift_vectors_end:
