vlog -work ./work ../syn/syn_riscv.v
vcom -93 -work ./work ../src/ram.vhd
vcom -93 -work ./work ../src/rom.vhd
vcom -93 -work ./work ../src/riscv_sim.vhd
vcom -93 -work ./work ../tb/tb_riscv.vhd

vsim -L /software/dk/nangate45/verilog/msim6.2g work.tb_riscv

run 2000 ns
