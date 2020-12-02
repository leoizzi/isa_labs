# compile the source code
vcom -96 -work ./work #source folder
# compile the tb
vcom -93 -work ./work # tb
vcom -93 -work ./work # tb
vcom -93 -work ./work # tb
vlog -work ./work # tb
vsim work.
# simulate
add waves *
run 2000 ns

