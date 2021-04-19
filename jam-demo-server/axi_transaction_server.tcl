set server_port [lindex $argv 0]

proc open_jtag {} {
    catch close_hw
    open_hw
    connect_hw_server -url 127.0.0.1:3121
    open_hw_target
}

proc vivado_command_server {channel clientaddr clientport} {
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
                set data [run_hw_axi rd_txn1]
                puts ${channel} "read @0x${addr}: 0x${data}"
            }
            quit {
                break
            }
            default {
                puts "axi_transaction_server: unknown cmd: $cmd"
            }
        }
        flush ${channel}
    }
    puts "axi_transaction_server: exiting"
    close $channel
    exit
}

#open_jtag
socket -server vivado_command_server $server_port
vwait connection_state
