# Xilinx AXI JTAG Demo

Basic demonstration showcasing a solution for remotely controlling an FPGA board through a Python script using Xilinx's `jtag_axi_master` IP core.

## Usage

```shell
$ git clone <repo>
$ cd <repo>
$ make
$ jtag_axi_tool
```

## Requirements

* A Digilent [Arty A7][d-arty] FPGA board.
* Xilinx [Vivado][x-vivado] version 2020.2.

[d-arty]: https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/
[x-jtag-axi-microzed]: https://forums.xilinx.com/t5/Xcell-Daily-Blog-Archived/Adam-Taylor-s-MicroZed-Chronicles-Part-226-Debugging-FPGA/ba-p/811281
[x-jtag-axi-example]: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/64488613/Using+the+JTAG+to+AXI+to+test+Peripherals+in+Zynq+Ultrascale
[x-jtag-axi-v12]: https://www.xilinx.com/support/documentation/ip_documentation/jtag_axi/v1_2/pg174-jtag-axi.pdf
[x-vivado]: https://www.xilinx.com/products/design-tools/vivado.html