set power_preserve_rtl_hier_names true
read_file {../fpuvhdl/common/ ../fpuvhdl/multiplier/} -exclude {../fpuvhdl/multiplier/fpmul_single_cycle.vhd ../fpuvhdl/multiplier/fpmul_stage2_struct.vhd ../fpuvhdl/multiplier/fpmul_stage2_struct_reg.vhd ../fpuvhdl/multiplier/fpmul_stage2_struct_mod.vhd ../fpuvhdl/multiplier/dadda.vhd ../fpuvhdl/multiplier/mbe.vhd ../fpuvhdl/multiplier/fa.vhd ../fpuvhdl/multiplier/ha.vhd ../fpuvhdl/multiplier/mult.vhd} -autoread -format vhdl -top FPmul
create_clock -name my_clk -period 0.7 clk
set_dont_touch_network my_clk
set_clock_uncertainty 0.07 [get_clocks my_clk]
set_input_delay 0.5 -max -clock my_clk [remove_from_collection [all_inputs] clk]
set_output_delay 0.5 -max -clock my_clk [all_outputs]
set OLOAD [load_of NangateOpenCellLibrary/BUF_X4/A]
set_load $OLOAD [all_outputs]
ungroup -all -flatten
compile
optimize_registers
report_resources > resources_reg_mbe.txt
report_timing > timing_reg_mbe.txt
report_area > area_reg_mbe.txt
quit

