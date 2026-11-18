.section .text, "ax"
.globl _sbst_boot
.type _sbst_boot, @function
_sbst_boot:
    /* Baseline only. Extend with your own ALU/register-file SBST.
       Preserve sp, gp, tp, ra and the callee-saved registers when returning.
       Store results so effects can propagate to the external bus. */
    la t0, RF_PATTERNS
    lw t1, 0(t0)
    la t0, test_result
    sw t1, 0(t0)
    ret
.size _sbst_boot, .-_sbst_boot

.section .TEST_DATA, "aw"
.balign 16
.globl test_result
test_result: .word 0
.globl digit_results
digit_results: .space 32

.section .TEST_RODATA, "a"
.balign 16
.globl RF_PATTERNS
RF_PATTERNS:
    .word 0x12345678, 0xcafecafe, 0xdeadbeef
