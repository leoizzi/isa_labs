set power_preserve_rtl_hier_names true
read_file {./fpuvhdl/common/ ./fpuvhdl/adder/ ./fpuvhdl/multiplier/} -exclude {./fpuvhdl/multiplier/fpmul_single_cycle.vhd} -autoread -format vhdl -top FPmul
create_clock -name my_clk -period 4.6 clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
ungroup -all -flatten
set_implementation DW02_mult/csa [find cell *mult*]
compile
report_resources > resources_csa.txt
report_timing > timing_csa.txt
report_area > area_csa.txt
quit

