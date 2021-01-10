# compile the source code
vcom -93 -work work ../src/constants.vhd
vcom -93 -work work ../src/cw.vhd
vcom -93 -work work ../src/opcodes.vhd
vcom -93 -work work ../src/fun_pack.vhd
vcom -93 -work work ../src/eq_comp.vhd
vcom -93 -work work ../src/mux2x1.vhd
vcom -93 -work work ../src/mux4x1.vhd
vcom -93 -work work ../src/lt_comp.vhd
vcom -93 -work work ../src/adder.vhd
vcom -93 -work work ../src/imm_gen.vhd
vcom -93 -work work ../src/reg_en.vhd
vcom -93 -work work ../src/pc_adder.vhd
vcom -93 -work work ../src/shifter.vhd
vcom -93 -work work ../src/rf.vhd
vcom -93 -work work ../src/logicals.vhd
vcom -93 -work work ../src/alu.vhd
vcom -93 -work work ../src/if_stage.vhd
vcom -93 -work work ../src/id_stage.vhd
vcom -93 -work work ../src/exe_stage.vhd
vcom -93 -work work ../src/wb_stage.vhd
vcom -93 -work work ../src/if_id_regs.vhd
vcom -93 -work work ../src/id_exe_regs.vhd
vcom -93 -work work ../src/exe_mem_regs.vhd
vcom -93 -work work ../src/mem_wb_regs.vhd
vcom -93 -work work ../src/datapath.vhd
vcom -93 -work work ../src/cu.vhd
vcom -93 -work work ../src/core.vhd
vcom -93 -work work ../src/ram.vhd
vcom -93 -work work ../src/rom.vhd
vcom -93 -work work ../src/riscv_sim.vhd
# compile the tb
vcom -93 -work work ../tb/tb_riscv.vhd
vsim work.tb_riscv
# simulate
add waves *
run 2000 ns
