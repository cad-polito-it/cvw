#!/bin/bash

rm -r ./run_zoix
mkdir ./run_zoix
cd ./run_zoix


if [[ $# -ne 2 ]]; then 
echo "Please provide a Wally configuration and simulator"
echo "Usage $1 <configuration> <simulator (questa/vcs)>"
exit 1
fi 

export WALLY_CONFIG=$1
export LOGIC_SIMULATOR=$2
# Compile DUT & strobe file
#

zoix -f ../netlist.f  +timescale+override+1ns/1ps \
+top+wallypipelinedcore_gate+strobe \
+sv +notimingchecks +define+ZOIX +define+TOPLEVEL=wallypipelinedcore_gate +suppress+cell +delay_mode_fault +verbose+undriven -l zoix_compile.log


#2 step, simulation:

./zoix.sim +vcd+file+"${WALLY}/sim/${LOGIC_SIMULATOR}/core_gate.vcd" \
 +vcd+dut+wallypipelinedcore_gate+testbench.dut.core_gate +vcd+verify +vcd+verbose  -l logic_sim.log +vcd+limit+mismatch+100000


#3 run fault simulation
fmsh  -load ../fault_sim_cvw.fmsh
fault_report +group+detail
