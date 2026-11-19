/* add_vectors.inc: the only file to edit. 10 hand-picked pairs. */
.equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */

.section .TEST_RODATA, "a"
.balign 4
.globl add_vectors, add_vectors_end
add_vectors:
    .word 0x00000000, 0x00000000
    .word 0xffffffff, 0x00000001
    .word 0xffffffff, 0xffffffff
    .word 0x55555555, 0xaaaaaaaa
    .word 0xaaaaaaaa, 0x55555555
    .word 0x55555555, 0x55555555
    .word 0xaaaaaaaa, 0xaaaaaaaa
    .word 0x7fffffff, 0x00000001
    .word 0x80000000, 0x80000000
    .word 0x00000001, 0xffffffff
add_vectors_end:
