# Synopsys Design Compiler flow for run_synthesis.sh.
# Inputs are snapshots prepared by bin/run_cvw.py inside this run directory.
# Retains the existing flow's hierarchical compile -exact_map strategy.

proc constrain_core {period} {
    create_clock -name clk -period $period [get_ports clk]
    set_clock_uncertainty 0.0 [get_clocks clk]
    set_false_path -from [get_ports reset]
    set other_inputs [remove_from_collection [all_inputs] [get_ports clk]]
    set_input_delay 0.0 -max -clock clk $other_inputs
    set_output_delay 0.0 -max -clock clk [all_outputs]
    set_max_fanout 6 $other_inputs
    set_wire_load_mode top
    set_fix_multiple_port_nets -all -buffer_constants
}

proc synthesize_cvw_core {} {
    global search_path synthetic_library
    set job $::env(CVW_SYNTH_RUN)
    set db $::env(CVW_SYNTH_DB)
    set cores $::env(CVW_SYNTH_CORES)
    set period [expr {1000.0 / double($::env(CVW_SYNTH_MHZ))}]
    source [file join $job sources.tcl]

    set_host_options -max_cores $cores
    set_app_var search_path [concat $cvw_include_dirs $search_path]
    set_app_var target_library [list $db]
    set_app_var synthetic_library [list dw_foundation.sldb]
    set_app_var link_library [concat [list * $db] $synthetic_library]
    set_app_var alib_library_analysis_path [file join $job alib]
    set_app_var verilogout_show_unconnected_pins true
    define_design_lib WORK -path [file join $job WORK]

    if {![analyze -format sverilog -library WORK $cvw_sources]} {
        error "SystemVerilog analysis failed"
    }
    elaborate cvw_synthesis_top -library WORK
    if {[sizeof_collection [get_designs -quiet cvw_synthesis_top]] != 1} {
        error "Synthesis wrapper elaboration failed"
    }
    current_design cvw_synthesis_top
    if {![link]} {error "Wrapper linking failed"}
    redirect [file join $job reports check_before.rep] {
        set design_ok [check_design]
    }
    if {!$design_ok} {error "check_design failed before compilation"}

    # Keep the boundary around the parameterized core. Hierarchical compile
    # retains ieu/dp/alu and ieu/dp/regf for fault scopes and register logging.
    set_ungroup [get_cells dut] false
    set_boundary_optimization [get_cells dut] false
    constrain_core $period
    if {![compile -exact_map]} {error "Technology mapping failed"}

    set core_ref [get_attribute [get_cells dut] ref_name]
    current_design $core_ref
    rename_design $core_ref wallypipelinedcore_gate
    current_design wallypipelinedcore_gate
    if {![link]} {error "Mapped core linking failed"}
    reset_design
    constrain_core $period
    redirect [file join $job reports check_after.rep] {
        set design_ok [check_design]
    }
    if {!$design_ok} {error "check_design failed after compilation"}
    foreach instance {ieu/dp/alu ieu/dp/regf} {
        if {[sizeof_collection [get_cells -quiet $instance]] != 1} {
            error "Required core hierarchy is missing: $instance"
        }
    }
    foreach pin_pattern {ieu/dp/regf/we3 ieu/dp/regf/a3* ieu/dp/regf/wd3*} {
        if {[sizeof_collection [get_pins -quiet $pin_pattern]] == 0} {
            error "Register logging interface is missing: $pin_pattern"
        }
    }

    set_app_var verilogout_no_tri true
    set_app_var verilogout_equation false
    set prefix [file join $job mapped wallypipelinedcore]
    write_file -format verilog -hierarchy -output ${prefix}.sv
    write_file -format ddc -hierarchy -output ${prefix}.ddc
    write_sdc ${prefix}.sdc
    write_sdf ${prefix}.sdf

    redirect [file join $job reports area.rep] {report_area -hierarchy -nosplit}
    redirect [file join $job reports timing.rep] {report_timing -max_paths 10 -nets}
    redirect [file join $job reports constraint.rep] {report_constraint -all_violators}
    redirect [file join $job reports qor.rep] {report_qor}
    redirect [file join $job reports hierarchy.rep] {report_hierarchy}
    set marker [open [file join $job SYNTHESIS_OK] w]
    puts $marker "Mapped wallypipelinedcore_gate; period=${period}ns"
    close $marker
}

if {[catch {synthesize_cvw_core} message]} {
    puts stderr "CVW SYNTHESIS FAILED: $message"
    if {[info exists ::errorInfo]} {puts stderr $::errorInfo}
    exit 1
}
exit 0
