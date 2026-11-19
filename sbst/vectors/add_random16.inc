/* add_vectors.inc (copy into sbst/ to use it): the table of add_test.S. 16 random pairs (seed 1234). */
.equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */

.section .TEST_RODATA, "a"
.balign 4
.globl add_vectors, add_vectors_end
add_vectors:
    .word 0xf7697fb9, 0xc735df5e
    .word 0x70d3da1f, 0x1de9ea66
    .word 0x01eaf614, 0x17346b45
    .word 0xe935b870, 0xf149f542
    .word 0xf073eed1, 0xce97b5bd
    .word 0x950cddd9, 0x08f0ebd4
    .word 0xabeb9592, 0xb16e2d5c
    .word 0x157cf9c6, 0x19322fed
    .word 0xc4381836, 0x5ac96628
    .word 0x3c9f90c9, 0x04762a22
    .word 0x07e36d60, 0xfc9799a7
    .word 0xc9ed0248, 0x040e1e30
    .word 0x58994953, 0xa5f80a0a
    .word 0x9f8f5ffb, 0x7bf78a4d
    .word 0x9da618fd, 0x76ab1475
    .word 0x2607ad5f, 0x175e9941
add_vectors_end:
