# Xilinx AXI JTAG Demo

Remotely control FPGA-based AXI buses. This repository hosts the source code for a *simple* application showcasing an implementation for issuing remotely read and write commands on an AXI4 bus using a TCP socket.

> :memo: Note:
> 
> Only Digilent [Arty A7][d-arty] FPGA boards are supported. 

## Quick Start

### Configuring the FPGA

First thing is to build a *bitstream* (aka FPGA configuration file) embedding the required IP cores. The `Makefile` file present in the root directory provides a default targets which builds the required bitstream and loads it into an Arty A7 hooked on the host.

```shell
$ make
```

### Launching the AXI Transaction Server

```shell
$ ./jam-demo-server/run_server
```

### Running Commands

```shell
$ nc 127.0.0.1 9900
version
2020.1
quit
```

Supported commands:

- [x] version
- [x] read
- [ ] write
- [x] quit


## FPGA Firmware

This demonstration requires the targeted FPGA to be configured with a bitstream instantiating the `jtag_axi` IP core.

Such bitstream can be built for the Digilent [Arty A7][d-arty] FPGA board using the project located in the [`jam-demo-firmware/`](jam-demo-firmware/) directory.

[d-arty]: https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/
[w-jtag]: https://en.wikipedia.org/wiki/JTAG#Uses
[x-jtag-axi-microzed]: https://forums.xilinx.com/t5/Xcell-Daily-Blog-Archived/Adam-Taylor-s-MicroZed-Chronicles-Part-226-Debugging-FPGA/ba-p/811281
[x-jtag-axi-example]: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/64488613/Using+the+JTAG+to+AXI+to+test+Peripherals+in+Zynq+Ultrascale
[x-jtag-axi-v12]: https://www.xilinx.com/support/documentation/ip_documentation/jtag_axi/v1_2/pg174-jtag-axi.pdf
[x-vivado]: https://www.xilinx.com/products/design-tools/vivado.html
