OUTPUT_ARCH(riscv)
ENTRY(_start)

/* Both regions are served by cvw_tb's AHB memory model. */
MEMORY
{
  instrram (rx) : ORIGIN = 0x80000000, LENGTH = 0x40000
  dataram (rw)  : ORIGIN = 0x80040000, LENGTH = 0x40000
}

__stack_size = 0x1000;
SECTIONS
{
  .init ORIGIN(instrram) : { KEEP(*(.text.start)) } > instrram
  .vectors : ALIGN(4)
  {
    __vector_start = .;
    KEEP(*(.vectors))
  } > instrram
  .text : ALIGN(4) { *(.text .text.*) } > instrram
  .rodata : ALIGN(4) { *(.rodata .rodata.* .srodata .srodata.*) } > instrram
  .TEST_RODATA : ALIGN(16)
  {
    __TEST_RODATA_START = .;
    KEEP(*(.TEST_RODATA .TEST_RODATA.*))
    __TEST_RODATA_END = .;
  } > instrram

  /* Fixed simulation completion mailbox; not a physical CVW peripheral. */
  .tohost ORIGIN(dataram) : { KEEP(*(.tohost)) } > dataram
  .TEST_DATA : ALIGN(16)
  {
    __TEST_DATA_START = .;
    KEEP(*(.TEST_DATA .TEST_DATA.*))
    __TEST_DATA_END = .;
  } > dataram
  .data : ALIGN(4)
  {
    __DATA_BEGIN__ = .;
    *(.data .data.* .sdata .sdata.*)
    __DATA_END__ = .;
  } > dataram
  __global_pointer$ = __DATA_BEGIN__ + 0x800;
  .bss (NOLOAD) : ALIGN(4)
  {
    __bss_start = .;
    *(.bss .bss.* .sbss .sbss.* COMMON)
    . = ALIGN(4);
    __bss_end = .;
  } > dataram
  _end = .;
  __RAM_START = ORIGIN(dataram);
  __RAM_END = ORIGIN(dataram) + LENGTH(dataram);
  __RAM_SIZE = LENGTH(dataram);
  .stack (__RAM_END - __stack_size) (NOLOAD) : ALIGN(16)
  {
    __stack_start = .;
    . += __stack_size;
    _sp = .;
    __stack_end = .;
  } > dataram
  ASSERT(_end <= __stack_start, "Data/BSS overlap the stack")
  ASSERT(tohost == 0x80040000, "Mailbox must match cvw_tb.sv")
  /DISCARD/ : { *(.eh_frame .eh_frame.* .comment .note.*) }
}
