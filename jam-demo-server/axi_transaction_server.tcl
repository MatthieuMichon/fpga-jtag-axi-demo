set server_port [lindex $argv 0]

proc open_jtag {} {
    catch close_hw
    open_hw_manager
    connect_hw_server -url 127.0.0.1:3121
    open_hw_target
    refresh_hw_device -update_hw_probes false [current_hw_device]
}

proc vivado_command_server {channel clientaddr clientport} {
    global disconnect
    fconfigure ${channel} -buffering none
    flush ${channel}
    puts "axi_transaction_server: new client: ${clientaddr}:${clientport}"
    while { true } {
        set request [gets ${channel}]
        puts "axi_transaction_server: client request: ${request}"
        lassign ${request} cmd addr data
        switch ${cmd} {
            version {
                set ret_version [version -short -quiet]
                puts "axi_transaction_server: version ${ret_version}"
                puts ${channel} ${ret_version}
            }
            read {
                create_hw_axi_txn -force rd_txn1 [get_hw_axis hw_axi_1] -address ${addr} -type read
                run_hw_axi [get_hw_axi_txns rd_txn1]
                set data [get_property DATA [get_hw_axi_txns  rd_txn1]]
                puts ${channel} "read @0x${addr}: 0x${data}"
            }
            write {
                create_hw_axi_txn -force wr_txn1 [get_hw_axis hw_axi_1] -address ${addr} -data ${data} -type write
                run_hw_axi [get_hw_axi_txns wr_txn1]
                set data [get_propert DATA [get_hw_axi_txns  wr_txn1]]
                puts ${channel} "write @0x${addr}: 0x${data}"
            }
            quit {
                puts ${channel} "Closing"
                break
            }
            default {
                puts "axi_transaction_server: unknown cmd: $cmd"
            }
        }
        flush ${channel}
    }
    flush ${channel}
    close ${channel}
    puts "axi_transaction_server: exiting"
    set disconnect true
}

proc close_jtag {} {
	close_hw_target
	disconnect_hw_server
	close_hw_manager
}

open_jtag
set server [socket -server vivado_command_server ${server_port}]
vwait disconnect
close ${server}
close_jtag
exit
