# CVW for the Testing and Fault Tolerance labs

This branch (`tft_lab`) is the upstream CORE-V Wally `main` plus a self-contained
flow for software-based self-test (SBST) and Z01X functional fault simulation,
used in the labs of *Testing and Fault Tolerance* (01RKZYG, Politecnico di Torino).
It only adds files: merging a newer upstream `main` never conflicts.

## Core configuration

`syn_polito_rv32e`, defined in `config/derivlist_polito.txt`: RV32I + Zicsr,
no M extension, no caches, user mode, no PMP, AHB bus, reset vector
`0x80000000`. `bin/run_cvw.py` generates its `config.vh` under `run/config/`;
`make deriv` is not needed. `testbench/cvw_tb.sv` stops on any other configuration.

## Requirements

- Questa (`vlog`, `vsim`), Z01X (`zoix`, `fmsh`, `fault_report`), and Design
  Compiler (`dc_shell-xg-t`) for synthesis, all on `PATH`; Python 3.6 or later.
- A RISC-V GCC with the `rv32i`/`ilp32` multilib. `sbst/Makefile` looks in
  `/opt/riscv-2023.10.18/bin` and `/opt/cvw_toolchain/bin`, then on `PATH`;
  override with `bash compile_sbst.sh CROSS_COMPILE=<prefix>`.
- The Nangate45 Open Cell Library, which is not redistributed here:
  `NangateOpenCellLibrary_typical.db` (synthesis) and `NangateOpenCellLibrary.v`
  (cell models). Copy both into `lib/`, or set `CVW_SYNTH_DB` and
  `LIBRARY_SIM_PATH`; `/data/libraries/nangate45/` is used when present.
- No submodule is needed.

## Flow

Run everything from the repository root.

```bash
bash run_synthesis.sh --check     # tool and library paths only
bash run_synthesis.sh             # map the core to Nangate45 into gate/syn_polito_rv32e/
bash compile_sbst.sh              # sbst/*.S -> sbst/sbst.hex, .elf, .objdump, .map
bash run_rtl_nogui.sh             # RTL simulation of the program (run_rtl_gui.sh: waveforms)
bash run_gate_nogui.sh            # gate-level simulation; writes the core-port eVCD
bash run_zoix_fsim.sh             # Z01X: compile, good-machine replay, fault simulation
```

Synthesis is needed once, and again only after RTL or configuration changes.
Each command checks that its inputs are current: for instance, the gate
simulation refuses a program that was edited but not recompiled, and Z01X
refuses an eVCD older than the program or the netlist.

| Folder | Content |
| --- | --- |
| `sbst/` | `crt0.S` (startup), `vectors.S` (trap), `sbst_boot.S` (SBST routine), `main.S` (or `main.c` with `MAIN=main.c`), `link.ld` |
| `sbst/` (lab programs) | data-driven tests: `add_test.S` (table `add_vectors.inc`), `shift_test.S` (table `shift_vectors.inc`), `addsub_test.S`; build with `bash compile_sbst.sh MAIN=add_test.S`. Each table also sets `OBSERVE` (store every result, a signature, or nothing). Ready tables in `sbst/vectors/` |
| `zoix/` | `faults.sff` (fault list: the ALU by default), `faults_adder.sff`, `faults_shifter.sff`, `faults_regfile.sff`, `faults_core.sff` (use with `bash run_zoix_fsim.sh --faults <file>`), `strobe.sv` (AHB outputs, every cycle), `fsim.fmsh` |
| `atpg/`, `bin/stil2vectors.py` | optional: ATPG of the ALU adder with TestMAX (`tmax.sh` of the labs) and conversion of the STIL patterns into a table for `add_test.S` or `addsub_test.S` |
| `testbench/` | `cvw_tb.sv` (one core, RTL or gate, zero-wait AHB memory, exit mailbox `tohost` at `0x80040000`), `waves.tcl` |
| `synthDC/scripts/` | `cvw_synth.tcl`, `cvw_wrapper.sv` (hierarchical compile that keeps `ieu/dp/alu` and `ieu/dp/regf`) |
| `run/` | every result, in timestamped folders (`questa/`, `zoix/`, `synth/`); not versioned |

The program ends by returning from `main`: `_exit` writes `(status << 1) | 1`
to `tohost`, and the testbench passes only on exit status 0.
`python3 bin/run_cvw.py clean` removes `run/` and the compiled program.
The labs use Questa for every logic simulation; `SIM=vcs` selects VCS where it is installed (not at LabInf).
