BATCH_MODE = -mode batch
NO_JOURNAL = -nojournal
TCL_SCRIPT = -source artix7a35t-artya7.tcl
VFLAGS = ${BATCH_MODE} ${NO_JOURNAL} ${TCL_SCRIPT}
BIT_FILE = jam-demo-artya7ca35t.bit

${BIT_FILE}: artya7c.sv artya7c.xdc
	vivado ${VFLAGS} -tclargs synthesize $<

reconfigure: ${BIT_FILE}
	vivado ${VFLAGS} -tclargs load-bitstream $<

.PHONY: clean
clean:
	${RM} jam-demo-firmware.bit

.PHONY: cleaner
cleaner: clean
	${RM} -r .Xil/
	${RM} -r vivado*
