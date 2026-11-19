/* shift_vectors.inc (copy into sbst/ to use it): the table of shift_test.S. 12 hand-picked pairs. */
.equ OBSERVE, 1   /* 1: store each result; signature 0: XOR, 3: rotate+XOR, 4: sum; 2: no store */

.section .TEST_RODATA, "a"
.balign 4
.globl shift_vectors, shift_vectors_end
shift_vectors:
    .word 0x80000001, 0x00000001
    .word 0x80000001, 0x00000002
    .word 0x80000001, 0x00000004
    .word 0x80000001, 0x00000008
    .word 0x80000001, 0x00000010
    .word 0x80000001, 0x0000001f
    .word 0x7ffffffe, 0x00000001
    .word 0x7ffffffe, 0x00000002
    .word 0x7ffffffe, 0x00000004
    .word 0x7ffffffe, 0x00000008
    .word 0x7ffffffe, 0x00000010
    .word 0x7ffffffe, 0x0000001f
shift_vectors_end:
