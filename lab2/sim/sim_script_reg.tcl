# compile the source code
vcom -93 -work work ../fpuvhdl/common/*
vcom -93 -work work ../fpuvhdl/multiplier/fpmul_stage1_struct.vhd
vcom -93 -work work ../fpuvhdl/multiplier/fpmul_stage2_struct_reg.vhd
vcom -93 -work work ../fpuvhdl/multiplier/fpmul_stage3_struct.vhd
vcom -93 -work work ../fpuvhdl/multiplier/fpmul_stage4_struct.vhd
vcom -93 -work work ../fpuvhdl/multiplier/fpmul_pipeline.vhd
# compile the tb
vcom -93 -work ./work ../tb/data_maker.vhd
vcom -93 -work ./work ../tb/tb_fpumult_reg.vhd
vsim work.tb_fpumult
# simulate
add waves *
run 2000 ns

