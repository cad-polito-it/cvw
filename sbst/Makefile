# RISC-V GCC with the rv32i/ilp32 multilib. Override with CROSS_COMPILE=<prefix>.
# Otherwise use the first installed course toolchain, then riscv64-unknown-elf- on PATH.
TOOLCHAIN_DIRS = /opt/riscv-2023.10.18/bin /opt/cvw_toolchain/bin
CROSS_COMPILE ?= $(patsubst %gcc,%,$(firstword $(wildcard $(addsuffix /riscv64-unknown-elf-gcc,$(TOOLCHAIN_DIRS)))))
ifeq ($(strip $(CROSS_COMPILE)),)
CROSS_COMPILE = riscv64-unknown-elf-
endif
MAIN ?= main.S
PROGRAM = sbst
SOURCES = crt0.S vectors.S sbst_boot.S $(MAIN)
CFLAGS = -march=rv32i_zicsr -mabi=ilp32 -mcmodel=medany -msmall-data-limit=0 \
	-O0 -g -ffreestanding -fno-builtin -fno-pic -fno-stack-protector
LDFLAGS = -nostdlib -nostartfiles -static -Wl,--build-id=none -Wl,--no-relax \
	-Wl,-Map=$(PROGRAM).map -T link.ld

.PHONY: all clean FORCE
all: $(PROGRAM).hex $(PROGRAM).objdump $(PROGRAM).sections $(PROGRAM).symbols
	python3 ../bin/run_cvw.py stamp --main "$(MAIN)"

# Always relink this tiny program so switching MAIN or toolchain cannot reuse
# an ELF built with different options. No libc or toolchain startup is linked.
$(PROGRAM).elf: $(SOURCES) link.ld Makefile FORCE
	$(CROSS_COMPILE)gcc $(CFLAGS) $(LDFLAGS) $(SOURCES) -o $@

# The testbench indexes a byte array from zero. Only the memory image is
# rebased; ELF symbols, map and disassembly retain real CPU addresses.
$(PROGRAM).hex: $(PROGRAM).elf
	$(CROSS_COMPILE)objcopy -O verilog --verilog-data-width=1 \
		--change-addresses=-0x80000000 \
		-j .init -j .vectors -j .text -j .rodata -j .TEST_RODATA \
		-j .tohost -j .TEST_DATA -j .data $< $@

$(PROGRAM).objdump: $(PROGRAM).elf
	$(CROSS_COMPILE)objdump -d -S $< > $@

$(PROGRAM).sections: $(PROGRAM).elf
	$(CROSS_COMPILE)readelf -W -S $< > $@

$(PROGRAM).symbols: $(PROGRAM).elf
	$(CROSS_COMPILE)readelf -W -s $< > $@

clean:
	rm -f $(PROGRAM).elf $(PROGRAM).hex $(PROGRAM).map $(PROGRAM).objdump \
		$(PROGRAM).sections $(PROGRAM).symbols $(PROGRAM).build.json
