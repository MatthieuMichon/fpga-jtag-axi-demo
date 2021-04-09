read_xdc artya7c.xdc
read_verilog -sv artya7c.sv

create_ip -name jtag_axi -module_name jtag_axi_xip
synth_ip [get_ips jtag_axi_xip]

create_ip -name ila -module_name ila_xip
set_property -dict [list \
	CONFIG.C_PROBE0_WIDTH  32 \
	CONFIG.C_DATA_DEPTH 1024 \
	CONFIG.C_NUM_OF_PROBES 1 \
] [get_ips ila_xip]
synth_ip [get_ips ila_xip]

synth_design -top artya7c -part xc7a35t-csg324-1 -flatten_hierarchy none \
    -verilog_define synthesis -verbose
opt_design -directive ExploreSequentialArea -verbose
place_design -directive ExtraPostPlacementOpt -timing_summary -verbose
phys_opt_design -directive AggressiveExplore -verbose
route_design -directive Explore -tns_cleanup -verbose
phys_opt_design -directive AggressiveExplore -verbose
set_property BITSTREAM.CONFIG.USERID 0xCAFEDECA [current_design]
write_bitstream -force -file artya7c.bit -verbose

