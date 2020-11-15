# compile the src code
vcom -93 -work ./work ../src/*
# compile the tb
vcom -93 -work ./work ../tb/clk_gen.vhd
vcom -93 -work ./work ../tb/data_maker_new.vhd
vcom -93 -work ./work ../tb/data_sink.vhd
vlog -work ./work ../tb/tb_fir.v

# simulate
vsim work.tb_iir
add waves *
run 2450 ns
