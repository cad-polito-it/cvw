sbst.objdump: sbst.elf
	riscv64-unknown-elf-objdump -D sbst.elf > sbst.objdump

sbst.elf: cache.S main.c crt0.s tests.h test.c Makefile vectors.S
	riscv64-unknown-elf-gcc -o sbst.elf -mabi=ilp32 -mcmodel=medany \
	-march=rv32i_zicboz_zicbop_zicbom_zicsr \
	-nostartfiles -T../../link/link_sbst.ld cache.S test.c main.c crt0.s vectors.S

clean:
	rm -f sbst.elf sbst.objdump
