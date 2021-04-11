BATCH_MODE = -mode batch
NO_JOURNAL = -nojournal
TCL_SCRIPT = -source artix7a35t-artya7.tcl
VFLAGS = ${BATCH_MODE} ${NO_JOURNAL} ${TCL_SCRIPT}
BIT_FILE = jam-demo-artya7ca35t.bit

${BIT_FILE}: artya7c.sv artya7c.xdc
	vivado ${VFLAGS} -tclargs synthesize

.PHONY: board-reconfigure
board-reconfigure: ${BIT_FILE}
	vivado ${VFLAGS} -tclargs reconfigure

.PHONY: clean
clean:
	${RM} ${BIT_FILE}

.PHONY: cleaner
cleaner: clean
	${RM} -r .Xil/ .hbs/ .srcs/
	${RM} -r usage_statistics_webtalk.*
	${RM} -r vivado*
	${RM} -r *_report.txt
