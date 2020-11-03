read_verilog -netlist ../netlist /iir.v
read_saif -input ../saif/iir_syn.saif -instance tb_fir/UUT -unit ns -scale 1
create_clock -name my_clk clk
report_power > report_area_switching_activity.txt
