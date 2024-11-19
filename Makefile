all: ulx3s.bit

clean:
	rm -rf uart.json ulx3s_out.config ulx3s.bit

ulx3s.bit: ulx3s_out.config
	ecppack ulx3s_out.config ulx3s.bit

ulx3s_out.config: uart.json
	nextpnr-ecp5 --85k --json uart.json --lpf ulx3s_v20.lpf --textcfg ulx3s_out.config

uart.json: top.sv
	yosys -p "hierarchy -top top" -p "proc; opt" -p "synth_ecp5 -noccu2 -nomux -nodram -json uart.json" top.sv uart.v

prog: ulx3s.bit
	fujprog ulx3s.bit

