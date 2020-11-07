if test -d work; then
	echo "removing old work folder"
	rm -rf work
fi

if test -f command.log; then
	echo "removing command.log"
	rm command.log
fi

if test -f default.svf; then
	echo "removing default.svf"
	rm default.svf
fi

if test -f filenames.log; then
	echo "removing filenames.log"
	rm filenames.log
fi

echo "sourcing init_synopsys_64.18"
source /software/scripts/init_synopsys_64.18

if test -f ../vcd/iir_syn.vcd; then
	echo "converting ../vcd/iir_syn.vcd to ../saif/iir_syn.saif"
	vcd2saif -input ../vcd/iir_syn.vcd -output ../saif/iir_syn.saif
fi

echo "creating work folder"
mkdir work
echo "launching synopsys shell"
dc_shell-xg-t
