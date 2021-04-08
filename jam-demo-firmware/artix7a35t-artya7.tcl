read_verilog artya7c.sv
read_xdc artya7c.xdc

create_ip -name jtag_axi -vendor xilinx.com -library ip -module_name jtag_axi
# set_property -dict [list \
# 	CONFIG.C_PROBE_IN0_WIDTH 8 \
# 	CONFIG.C_PROBE_OUT0_WIDTH 8 \
# 	CONFIG.C_NUM_PROBE_IN 1 \
# 	CONFIG.C_NUM_PROBE_OUT 1 \
# ] [get_ips vio]
synth_ip [get_ips jtag_axi]
