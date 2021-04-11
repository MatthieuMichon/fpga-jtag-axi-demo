proc synthesize {} {
	foreach sv_file [glob *.sv] {
		read_verilog -sv ${sv_file}
	}
	foreach xdc_file [glob *.xdc] {
		read_xdc ${xdc_file}
	}
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
	write_bitstream -force -file jam-demo-artya7ca35t.bit -verbose
}

proc reconfigure {
	open_hw_manager
	connect_hw_server
	open_hw_target
	set_property PROGRAM.FILE ${bit_file} [lindex [get_hw_devices] 0]
	program_hw_devices [lindex [get_hw_devices] 0]
	refresh_hw_device -update_hw_probes false [current_hw_device]
	set userid [get_property REGISTER.USERCODE [current_hw_device]]
	puts $userid
	close_hw_target
	disconnect_hw_server
	close_hw_manager
}

set action [lindex $argv 0]
switch ${action} {
	"synthesize" { synthesize }
	"reconfigure" { reconfigure }
}

