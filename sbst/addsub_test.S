/* Data-driven test of the ALU adder with ADD and SUB (Lab 6 prototype).
   SUB drives the adder with B = ~rs2 and carry-in = 1, so it reaches the faults
   that need CI = 1. Two tables in addsub_vectors.inc: add_vectors (pairs for ADD)
   and sub_vectors (pairs for SUB, second word = rs2 = ~B of the ATPG pattern).
   No data-dependent branch: the test time does not depend on the values.
   Build: bash compile_sbst.sh MAIN=addsub_test.S */
#include "addsub_vectors.inc"

.section .TEST_DATA, "aw"
.balign 4
.globl addsub_results
addsub_results: .space (add_vectors_end - add_vectors + sub_vectors_end - sub_vectors) / 2

.section .text, "ax"
.globl main
.type main, @function
main:
    la   t2, addsub_results
    la   t0, add_vectors
    la   t1, add_vectors_end
1:  beq  t0, t1, 2f
    lw   a0, 0(t0)
    lw   a1, 4(t0)
    add  a2, a0, a1
    sw   a2, 0(t2)
    addi t0, t0, 8
    addi t2, t2, 4
    j    1b
2:  la   t0, sub_vectors
    la   t1, sub_vectors_end
3:  beq  t0, t1, 4f
    lw   a0, 0(t0)
    lw   a1, 4(t0)
    sub  a2, a0, a1
    sw   a2, 0(t2)
    addi t0, t0, 8
    addi t2, t2, 4
    j    3b
4:  li   a0, 0
    ret
.size main, .-main
