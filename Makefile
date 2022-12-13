SHELL=/bin/bash
IVERILOG=iverilog -g2012 -Wall -Wno-sensitivity-entire-vector -Wno-sensitivity-entire-array -y./hdl -y./tests -Y.sv -I./hdl
VVP=vvp
VVP_POST=-fst
VIVADO=vivado -mode batch -source

ENCODING_SRCS=hdl/hamming_7_4_encoder.sv
DECODING_SRCS=hdl/hamming_7_4_decoder.sv
MAIN_SRCS=hdl/main.sv ${ENCODING_SRCS} ${DECODING_SRCS}


# Look up .PHONY rules for Makefiles
.PHONY: clean submission remove_solutions waves_rv32i_system analyze_rv32i_system

test_hamming_7_4_encoder: tests/test_hamming_7_4_encoder.sv ${ENCODING_SRCS}
	${IVERILOG} $^ -o test_hamming_7_4_encoder.bin && ${VVP} test_hamming_7_4_encoder.bin ${VVP_POST}

test_hamming_7_4_decoder: tests/test_hamming_7_4_decoder.sv ${DECODING_SRCS}
	${IVERILOG} $^ -o test_hamming_7_4_decoder.bin && ${VVP} test_hamming_7_4_decoder.bin ${VVP_POST}

waves_rv32i_system:
	gtkwave rv32i_system.fst -a tests/rv32i_system.gtkw

main.bit: ${MAIN_SRCS} build.tcl main.xdc
	@echo "########################################"
	@echo "#### Building FPGA bitstream        ####"
	@echo "########################################"
	${VIVADO} build.tcl

analyze_rv32i_system: ${RV32I_SRCS} analysis.tcl asm/peripherals.memh
	${VIVADO} analysis.tcl

program_fpga_vivado: main.bit build.tcl program.tcl
	@echo "########################################"
	@echo "#### Programming FPGA (Vivado)      ####"
	@echo "########################################"
	${VIVADO} program.tcl

program_fpga_digilent: main.bit build.tcl
	@echo "########################################"
	@echo "#### Programming FPGA (Digilent)    ####"
	@echo "########################################"
	djtgcfg enum
	djtgcfg prog -d CmodA7 -i 0 -f main.bit

lint_all: hdl/*.sv
	verilator --lint-only -DSIMULATION -I./hdl -I./tests $^

# Call this to clean up all your generated files
clean:
	rm -f *.bin *.vcd *.fst vivado*.log *.jou vivado*.str *.log *.checkpoint *.bit *.html *.xml *.out
	rm -rf .Xil
	rm -rf __pycache__
	rm -f asm/*.memh

# Call this to generate your submission zip file.
submission:
	zip submission.zip Makefile asm/*.s hdl/*.sv README.md docs/* *.tcl *.xdc tests/*.sv *.pdf
