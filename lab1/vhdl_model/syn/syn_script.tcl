# set constant values
set t_min 2.81
set tx4 11.24
set clk_period 0
set use_tx4 1
# analyse the source ccode
analyze -f vhdl -lib WORK {../src/reg.vhd ../src/multiplier.vhd ../src/adder.vhd ../src/subtractor.vhd ../src/iir.vhd }
set power_preserve_rtl_hier_names true
# elaborate the design
elaborate iir -arch structural -lib WORK 
# applying constriants
if {$use_tx4 == 0} {
	set clk_period $t_min
} else {
	set clk_period $tx4	
}
create_clock -name my_clk -period $clk_period clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
# compile the architecture
compile
# results
if {$use_tx4 == 0} {
	report_timing > report_timing_max_freq.txt
	report_area > report_area_max_freq.txt
} else {
	report_timing > report_timing.txt
	report_area > report_area.txt
}
# save netlist
ungroup -all -flatten
change_names -hierarchy -rules verilog
if {$use_tx4 == 0} {
	write_sdf ../netlist/iir_max_freq.sdf
	write -f verilog -hierarchy -output ../netlist/iir_max_freq.v
	write_sdc ../netlist/iir_max_freq.sdc
} else {
	write_sdf ../netlist/iir.sdf
	write -f verilog -hierarchy -output ../netlist/iir.v
	write_sdc ../netlist/iir.sdc
}
quit

