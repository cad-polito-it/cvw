# Waveforms for testbench/cvw_tb.sv (run_rtl_gui.sh, run_gate_gui.sh).
# Only testbench signals and module ports: they keep their names in the RTL and in
# the synthesized netlist, so the same window works at both levels. Short labels
# keep the name column narrow; the full path is in the tooltip of each signal.
quietly WaveActivateNextPane {} 0
add wave -noupdate -label clk /cvw_tb/clk
add wave -noupdate -label reset /cvw_tb/reset
add wave -noupdate -divider "AHB bus"
add wave -noupdate -label HTRANS /cvw_tb/HTRANS
add wave -noupdate -label HWRITE /cvw_tb/HWRITE
add wave -noupdate -label HADDR -radix hex /cvw_tb/HADDR
add wave -noupdate -label HWDATA -radix hex /cvw_tb/HWDATA
add wave -noupdate -label HWSTRB -radix hex /cvw_tb/HWSTRB
add wave -noupdate -label HRDATA -radix hex /cvw_tb/HRDATA
add wave -noupdate -divider "PC: fetch, execute"
add wave -noupdate -label PCSpillF -radix hex /cvw_tb/dut/ifu/PCSpillF
add wave -noupdate -label PCE -radix hex /cvw_tb/dut/ifu/PCE
add wave -noupdate -divider "ALU (execute stage)"
add wave -noupdate -label alu/A -radix hex /cvw_tb/dut/ieu/dp/alu/A
add wave -noupdate -label alu/B -radix hex /cvw_tb/dut/ieu/dp/alu/B
add wave -noupdate -label alu/Sum -radix hex /cvw_tb/dut/ieu/dp/alu/Sum
add wave -noupdate -label alu/Shift -radix hex /cvw_tb/dut/ieu/dp/alu/Shift
add wave -noupdate -label alu/ALUResult -radix hex /cvw_tb/dut/ieu/dp/alu/ALUResult
add wave -noupdate -divider "Register file write port"
add wave -noupdate -label regf/we3 /cvw_tb/dut/ieu/dp/regf/we3
add wave -noupdate -label regf/a3 -radix unsigned /cvw_tb/dut/ieu/dp/regf/a3
add wave -noupdate -label regf/wd3 -radix hex /cvw_tb/dut/ieu/dp/regf/wd3
configure wave -timelineunits ns
configure wave -namecolwidth 130
update
wave zoom full
