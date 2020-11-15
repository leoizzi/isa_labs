# compile the tb
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker_new.vhd
vcom -93 -work ./work ../tb/data_sink.vhd
vlog -work ./work ../innovus/iir.v
vlog -work ./work ../tb/tb_fir.v

# link the compiled library
vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_iir

# link the delay file
vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_iir/UUT=../innovus/iir.sdf work.tb_iir

vcd file ../vcd/iir_design.vcd
vcd add /tb_iir/UUT/*

# simulate
run 2450 ns
