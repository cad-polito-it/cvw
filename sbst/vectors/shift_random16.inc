/* shift_vectors.inc (copy into sbst/ to use it): the table of shift_test.S. 16 random pairs (seed 1234). */
.equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */

.section .TEST_RODATA, "a"
.balign 4
.globl shift_vectors, shift_vectors_end
shift_vectors:
    .word 0xf7697fb9, 0x00000018
    .word 0x70d3da1f, 0x00000003
    .word 0x01eaf614, 0x00000002
    .word 0xe935b870, 0x0000001e
    .word 0xf073eed1, 0x00000019
    .word 0x950cddd9, 0x00000001
    .word 0xabeb9592, 0x00000016
    .word 0x157cf9c6, 0x00000003
    .word 0xc4381836, 0x0000000b
    .word 0x3c9f90c9, 0x00000000
    .word 0x07e36d60, 0x0000001f
    .word 0xc9ed0248, 0x00000000
    .word 0x58994953, 0x00000014
    .word 0x9f8f5ffb, 0x0000000f
    .word 0x9da618fd, 0x0000000e
    .word 0x2607ad5f, 0x00000002
shift_vectors_end:
