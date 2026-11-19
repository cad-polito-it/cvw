/* Data-driven test of the ALU adder (Lab 6 prototype).
   For every pair (a, b) in add_vectors.inc: load a and b, add them, and make
   the sum observable. Edit only add_vectors.inc (table and OBSERVE option).
   Build: bash compile_sbst.sh MAIN=add_test.S */
#include "add_vectors.inc"

.section .TEST_DATA, "aw"
.balign 4
.globl add_results
add_results: .space (add_vectors_end - add_vectors) / 2
signature:   .word 0

.section .text, "ax"
.globl main
.type main, @function
main:
    la   t0, add_vectors
    la   t1, add_vectors_end
    la   t2, add_results
    li   a3, 0                  /* signature (OBSERVE = 0) */
1:  beq  t0, t1, 2f
    lw   a0, 0(t0)
    lw   a1, 4(t0)
    add  a2, a0, a1
.if OBSERVE == 1
    sw   a2, 0(t2)              /* every sum appears on HWDATA */
.elseif OBSERVE == 0
    xor  a3, a3, a2             /* compacted: one store at the end */
.elseif OBSERVE == 3
    slli t3, a3, 1              /* rotate the signature left by one... */
    srli t4, a3, 31
    or   a3, t3, t4
    xor  a3, a3, a2             /* ...then XOR: a software MISR */
.elseif OBSERVE == 4
    add  a3, a3, a2             /* compacted by addition */
.endif
    addi t0, t0, 8
    addi t2, t2, 4
    j    1b
2:
.if OBSERVE == 0 || OBSERVE == 3 || OBSERVE == 4
    la   t2, signature
    sw   a3, 0(t2)
.endif
    li   a0, 0
    ret
.size main, .-main
