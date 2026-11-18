.section .text, "ax"
.globl main
.type main, @function
main:
    /* Smoke checks: SBST store, initialized data, and BSS initialization. */
    la t0, test_result
    lw t1, 0(t0)
    li t2, 0x12345678
    bne t1, t2, failed
    la t0, initialized_probe
    lw t1, 0(t0)
    li t2, 0x13579bdf
    bne t1, t2, failed
    la t0, bss_probe
    lw t1, 0(t0)
    bnez t1, failed

    /* SECTION 2[C]: write the hexadecimal-ID assembly here.
       Extract the hexadecimal digits into registers of your choice, then
       store them at digit_results (use la; the RI5CY addresses have changed).
       Keep ra/sp/gp/tp valid and restore callee-saved registers if used.
       Do not place a self-loop here: return to let _exit end the simulation. */

    li a0, 0
    ret
failed:
    li a0, 1
    ret
.size main, .-main

.section .data, "aw"
initialized_probe: .word 0x13579bdf
.section .bss, "aw", @nobits
.balign 4
bss_probe: .space 4
