# compile the src code
vcom -reportprogress 300 -work work ../src/*
# compile the tb
vcom -reportprogress 300 -work work ../tb/clk_gen.vhd
vcom -reportprogress 300 -work work ../tb/data_maker_new.vhd
vcom -reportprogress 300 -work work ../tb/data_sink.vhd
vlog -reportprogress 300 -work work ../tb/tb_fir.v
# simulate
vsim -t 100ps -novopt work.tb_iir
add waves *
run 2160 ns
