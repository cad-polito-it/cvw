.section .vectors, "ax"
.balign 4
    j trap_failed
.section .text, "ax"
trap_failed:
    li a0, 1
    tail _exit
