/* Minimal freestanding startup for this CVW configuration; RV32I + Zicsr. */
.section .text.start, "ax"
.globl _start
.type _start, @function
_start:
    li x1, 0
    li x2, 0
    li x3, 0
    li x4, 0
    li x5, 0
    li x6, 0
    li x7, 0
    li x8, 0
    li x9, 0
    li x10, 0
    li x11, 0
    li x12, 0
    li x13, 0
    li x14, 0
    li x15, 0
    li x16, 0
    li x17, 0
    li x18, 0
    li x19, 0
    li x20, 0
    li x21, 0
    li x22, 0
    li x23, 0
    li x24, 0
    li x25, 0
    li x26, 0
    li x27, 0
    li x28, 0
    li x29, 0
    li x30, 0
    li x31, 0
    .option push
    .option norelax
    la gp, __global_pointer$
    .option pop
    la sp, _sp
    csrw mie, zero
    la t0, __vector_start
    csrw mtvec, t0              /* Direct trap mode, not vectored. */

    /* Initialized sections are already preloaded at their final addresses.
       BSS is deliberately NOT initialized by the testbench. */
    la t0, __bss_start
    la t1, __bss_end
1:  bgeu t0, t1, 2f
    sw zero, 0(t0)
    addi t0, t0, 4
    j 1b
2:  call _sbst_boot
    li a0, 0
    li a1, 0
    call main
    tail _exit
.size _start, .-_start

.section .text, "ax"
.globl _exit
.type _exit, @function
_exit:
    /* Exit status convention: (status << 1) | 1; success is exactly 1. */
    slli a0, a0, 1
    ori a0, a0, 1
    la t0, tohost
    sw a0, 0(t0)
3:  j 3b
.size _exit, .-_exit

.section .tohost, "aw"
.globl tohost
tohost: .word 0
