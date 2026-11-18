/* Optional C entry point: bash compile_sbst.sh MAIN=main.c
   The default main.S is used for the assembly exercise. */
extern volatile unsigned int test_result;
static volatile unsigned int initialized_probe = 0x13579bdf;
static volatile unsigned int bss_probe;

int main(void)
{
    /* Add C / inline assembly experiments here. No libc is linked. */
    return test_result != 0x12345678 ||
           initialized_probe != 0x13579bdf || bss_probe != 0;
}
