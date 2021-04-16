BATCH_MODE = -mode batch
NO_JOURNAL = -nojournal
NO_TRACE = -notrace
TCL_SCRIPT = -source artix7a35t-artya7.tcl
VFLAGS = ${BATCH_MODE} ${NO_JOURNAL} ${TCL_SCRIPT} ${NO_TRACE}
BIT_FILE = jam-demo-artya7ca35t.bit
SV_FILES := $(wildcard *.sv)
XDC_FILES := ${wildcard *.xdc}
BD_FILE = vivado_simple_bd/simple_bd.srcs/sources_1/bd/simple_bd/simple_bd.bd

.PHONY: all
all: board-reconfigure

.PHONY: bd
bd: ${BD_FILE}

${BD_FILE}:
	vivado ${VFLAGS} -tclargs create_bd

.PHONY: bitstream
bitstream: ${BIT_FILE}

${BIT_FILE}: ${SV_FILES} ${XDC_FILES} ${BD_FILE}
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
