read_verilog -netlist ../netlist/iir.v
read_saif -input ../saif/iir_syn.saif -instance tb_iir/UUT -unit ns -scale 1
create_clock -name MY_CLK clk
report_power > report_switching_activity.txt
