variable part xc7a35t-csg324-1
variable bd_project_name simple_bd

proc create_bd {} {
	create_project \
		-part ${::part} \
		-verbose \
		${::bd_project_name} \
		vivado_${::bd_project_name}

	create_bd_design ${::bd_project_name}

	set clock [create_bd_port -dir I -type clk -freq_hz 100000000 clock]
	set resetn [create_bd_port -dir I -type rst resetn]

	set jtag_axi_0 [create_bd_cell \
		-type ip \
		-vlnv xilinx.com:ip:jtag_axi:1.2 \
		jtag_axi_0 \
	]

	set axi_bram_ctrl_0 [create_bd_cell \
		-type ip \
		-vlnv xilinx.com:ip:axi_bram_ctrl:4.1 \
		axi_bram_ctrl_0 \
	]

	set axi_bram_ctrl_0_bram [create_bd_cell \
		-type ip \
		-vlnv xilinx.com:ip:blk_mem_gen:8.4 \
		axi_bram_ctrl_0_bram \
	]

	set_property -dict [list CONFIG.Memory_Type True_Dual_Port_RAM] $axi_bram_ctrl_0_bram

	connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTA [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTA] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTA]
	connect_bd_intf_net -intf_net axi_bram_ctrl_0_BRAM_PORTB [get_bd_intf_pins axi_bram_ctrl_0/BRAM_PORTB] [get_bd_intf_pins axi_bram_ctrl_0_bram/BRAM_PORTB]
	connect_bd_intf_net -intf_net jtag_axi_0_M_AXI [get_bd_intf_pins axi_bram_ctrl_0/S_AXI] [get_bd_intf_pins jtag_axi_0/M_AXI]
																														
	# Create port connections                                                                                            
	connect_bd_net -net clock [get_bd_ports clock] [get_bd_pins axi_bram_ctrl_0/s_axi_aclk] [get_bd_pins jtag_axi_0/aclk]
	connect_bd_net -net resetn [get_bd_ports resetn] [get_bd_pins axi_bram_ctrl_0/s_axi_aresetn] [get_bd_pins jtag_axi_0/aresetn]
																														
	# Create address segments                                                                                            
	assign_bd_address -offset 0xC0000000 -range 0x00002000 -target_address_space [get_bd_addr_spaces jtag_axi_0/Data] [get_bd_addr_segs axi_bram_ctrl_0/S_AXI/Mem0] -force
																														
	validate_bd_design
	save_bd_design

	generate_target all [get_files vivado_${::bd_project_name}/${::bd_project_name}.srcs/sources_1/bd/${::bd_project_name}/${::bd_project_name}.bd]
}

proc synthesize {} {
	create_project -in_memory -part ${::part}
	foreach sv_file [glob *.sv] {
		read_verilog -sv ${sv_file}
	}
	foreach xdc_file [glob *.xdc] {
		read_xdc ${xdc_file}
	}
	set bd_file vivado_${::bd_project_name}/${::bd_project_name}.srcs/sources_1/bd/${::bd_project_name}/${::bd_project_name}.bd
	read_bd ${bd_file}
	open_bd_design ${bd_file}
	#report_ip_status
	set_property synth_checkpoint_mode None [get_files ${bd_file}]
	generate_target all [get_files ${bd_file}]

	#create_ip -name jtag_axi -module_name jtag_axi_xip
	# synth_ip [get_ips jtag_axi_xip]

	# create_ip -name ila -module_name ila_xip
	# set_property -dict [list \
	# 	CONFIG.C_PROBE0_WIDTH  32 \
	# 	CONFIG.C_DATA_DEPTH 1024 \
	# 	CONFIG.C_NUM_OF_PROBES 1 \
	# ] [get_ips ila_xip]
	# synth_ip [get_ips ila_xip]

	synth_design \
		-top artya7c \
		-flatten_hierarchy none \
		-verilog_define synthesis \
		-verbose
	opt_design -directive ExploreSequentialArea -verbose
	place_design -directive ExtraPostPlacementOpt -timing_summary -verbose
	phys_opt_design -directive AggressiveExplore -verbose
	route_design -directive Explore -tns_cleanup -verbose
	phys_opt_design -directive AggressiveExplore -verbose
	set_property BITSTREAM.CONFIG.USERID 0xCAFEDECA [current_design]
	write_bitstream -force -file jam-demo-artya7ca35t.bit -verbose

	report_ram_utilization -include_lutram -file ram_utilization_report.txt
	report_utilization -packthru -file utilization_packthru_report.txt
	report_utilization -packthru -hierarchical -file utilization_packthru_hier_report.txt
	report_timing_summary -path_type summary -file timing_summary_report.txt
}

proc reconfigure {} {
	open_hw_manager
	connect_hw_server -url 127.0.0.1:3121
	open_hw_target
	set_property PROGRAM.FILE jam-demo-artya7ca35t.bit [lindex [get_hw_devices] 0]
	program_hw_devices [lindex [get_hw_devices] 0]
	refresh_hw_device -update_hw_probes false [current_hw_device]
	set userid [get_property REGISTER.USERCODE [current_hw_device]]
	puts "Readback userid: $userid"
	close_hw_target
	disconnect_hw_server
	close_hw_manager
}

set action [lindex $argv 0]
switch ${action} {
	"create_bd" { create_bd }
	"synthesize" { synthesize }
	"reconfigure" { reconfigure }
}

