sbst.objdump: sbst.elf
	riscv64-unknown-elf-objdump -D sbst.elf > sbst.objdump

sbst.elf: cache.S main.c crt0.s tests.h Makefile vectors.S
	riscv64-unknown-elf-gcc -o sbst.elf -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany \
	-march=rv32i_zicsr_zicbom \
	-nostartfiles -T../../link/link_sbst.ld  cache.S main.c crt0.s vectors.S

clean:
	rm -f sbst.elf sbst.objdump
