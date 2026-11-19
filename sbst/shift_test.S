/* Data-driven test of the ALU shifter (Lab 6 prototype).
   For every pair (value, amount) in shift_vectors.inc: SLL, SRL and SRA of
   value by amount[4:0], each result made observable. Edit only
   shift_vectors.inc (table and OBSERVE option).
   Build: bash compile_sbst.sh MAIN=shift_test.S */
#include "shift_vectors.inc"

/* Software MISR step: rotate the signature a3 left by one, then XOR the result. */
.macro MISR reg
    slli t3, a3, 1
    srli t4, a3, 31
    or   a3, t3, t4
    xor  a3, a3, \reg
.endm

.section .TEST_DATA, "aw"
.balign 4
.globl shift_results
shift_results: .space (shift_vectors_end - shift_vectors) / 2 * 3
signature:     .word 0

.section .text, "ax"
.globl main
.type main, @function
main:
    la   t0, shift_vectors
    la   t1, shift_vectors_end
    la   t2, shift_results
    li   a3, 0
1:  beq  t0, t1, 2f
    lw   a0, 0(t0)
    lw   a1, 4(t0)
    sll  a2, a0, a1
    srl  a4, a0, a1
    sra  a5, a0, a1
.if OBSERVE == 1
    sw   a2, 0(t2)
    sw   a4, 4(t2)
    sw   a5, 8(t2)
.elseif OBSERVE == 0
    xor  a3, a3, a2
    xor  a3, a3, a4
    xor  a3, a3, a5
.elseif OBSERVE == 3
    MISR a2
    MISR a4
    MISR a5
.elseif OBSERVE == 4
    add  a3, a3, a2
    add  a3, a3, a4
    add  a3, a3, a5
.endif
    addi t0, t0, 8
    addi t2, t2, 12
    j    1b
2:
.if OBSERVE == 0 || OBSERVE == 3 || OBSERVE == 4
    la   t2, signature
    sw   a3, 0(t2)
.endif
    li   a0, 0
    ret
.size main, .-main
