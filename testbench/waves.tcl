# Wave groups for testbench/cvw_tb.sv.
quietly WaveActivateNextPane {} 0
add wave /cvw_tb/clk /cvw_tb/reset
add wave -hex /cvw_tb/HADDR /cvw_tb/HWDATA /cvw_tb/HRDATA
add wave /cvw_tb/HTRANS /cvw_tb/HWRITE /cvw_tb/HWSTRB
add wave -hex /cvw_tb/address_d
add wave /cvw_tb/active_d /cvw_tb/write_d
# These names exist at both RTL and gate level in the supplied netlist.
catch {add wave -hex /cvw_tb/dut/ieu/dp/regf/*}
catch {add wave -hex /cvw_tb/dut/ieu/dp/alu/*}
catch {add wave -hex /cvw_tb/dut/ifu/PCF}
configure wave -timelineunits ns
wave zoom full
