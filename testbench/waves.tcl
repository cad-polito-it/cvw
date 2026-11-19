# Waveforms for testbench/cvw_tb.sv (run_rtl_gui.sh, run_gate_gui.sh).
# Only testbench signals and module ports: they keep their names in the RTL and in
# the synthesized netlist, so the same window works at both levels.
quietly WaveActivateNextPane {} 0
add wave -noupdate /cvw_tb/clk /cvw_tb/reset
add wave -noupdate -divider "AHB bus"
add wave -noupdate /cvw_tb/HTRANS /cvw_tb/HWRITE
add wave -noupdate -radix hex /cvw_tb/HADDR /cvw_tb/HWDATA /cvw_tb/HWSTRB /cvw_tb/HRDATA
add wave -noupdate -divider "Program counter: fetch, execute"
add wave -noupdate -radix hex /cvw_tb/dut/ifu/PCSpillF /cvw_tb/dut/ifu/PCE
add wave -noupdate -divider "ALU (execute stage)"
add wave -noupdate -radix hex /cvw_tb/dut/ieu/dp/alu/A /cvw_tb/dut/ieu/dp/alu/B
add wave -noupdate -radix hex /cvw_tb/dut/ieu/dp/alu/Sum /cvw_tb/dut/ieu/dp/alu/Shift /cvw_tb/dut/ieu/dp/alu/ALUResult
add wave -noupdate -divider "Register file write port"
add wave -noupdate /cvw_tb/dut/ieu/dp/regf/we3
add wave -noupdate -radix unsigned /cvw_tb/dut/ieu/dp/regf/a3
add wave -noupdate -radix hex /cvw_tb/dut/ieu/dp/regf/wd3
configure wave -timelineunits ns
update
wave zoom full
