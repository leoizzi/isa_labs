vcom -93 -work work ../src/ha.vhd
vcom -93 -work work ../src/fa.vhd
vcom -93 -work work ../src/dadda.vhd
vcom -93 -work work ../src/mbe.vhd
vcom -93 -work work ../src/mult.vhd
vcom -93 -work work ../src/fpnormalize_fpnormalize.vhd
vcom -93 -work work ../src/fpround_fpround.vhd
vcom -93 -work work ../src/packfp_packfp.vhd
vcom -93 -work work ../src/unpackfp_unpackfp.vhd
vcom -93 -work work ../src/fpmul_stage1_struct.vhd
vcom -93 -work work ../src/fpmul_stage2_struct_reg_mod.vhd
vcom -93 -work work ../src/fpmul_stage3_struct.vhd
vcom -93 -work work ../src/fpmul_stage4_struct.vhd
vcom -93 -work work ../src/fpmul_pipeline.vhd

vlog -sv ../tb/top.sv
vsim top
run 10 us
