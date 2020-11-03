# compile the src code
vcom -reportprogress 300 -work work ../src/*
# compile the tb
vcom -reportprogress 300 -work work ../tb/clk_gen.vhd
vcom -reportprogress 300 -work work ../tb/data_maker_new.vhd
vcom -reportprogress 300 -work work ../tb/data_sink.vhd
vlog -reportprogress 300 -work work ../netlist/iir.v
vlog -reportprogress 300 -work work ../tb/tb_fir.v

# link the compiled library
vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_iir

# link the delay file
#vsim -L /software/dk/nangate45/verilog/msim6.2g -sdftyp /tb_iir/UUT=../netlist/iir.sdf work.tb_iir

#vcd file ../vcd/iir_syn.vcd
#vcd add /tb_iir/UUT/*

# simulate
#vsim -t 1ps -novopt work.tb_iir
#add waves *
#run 2450 ns
