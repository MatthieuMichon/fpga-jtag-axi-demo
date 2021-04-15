BATCH_MODE = -mode batch
NO_JOURNAL = -nojournal
TCL_SCRIPT = -source artix7a35t-artya7.tcl
VFLAGS = ${BATCH_MODE} ${NO_JOURNAL} ${TCL_SCRIPT}
BIT_FILE = jam-demo-artya7ca35t.bit
SV_FILES := $(wildcard *.sv)
XDC_FILES := ${wildcard *.xdc}

.PHONY: create_bd
create_bd:
	vivado ${VFLAGS} -tclargs create_bd

${BIT_FILE}: ${SV_FILES} ${XDC_FILES}
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
