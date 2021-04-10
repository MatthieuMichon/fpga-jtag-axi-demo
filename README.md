# Xilinx AXI JTAG Demo

A basic demonstration showcasing how to remotely control an FPGA board through a Python script via the [JTAG][w-jtag] interface using Xilinx's `jtag_axi_master` IP core.

## Usage

```shell
$ git clone <repo>
$ cd <repo>
$ make
$ jtag_axi_tool
```

## FPGA Firmware

This demonstration requires the targeted FPGA to be configured with a bitstream instantiating the `jtag_axi` IP core.

Such bitstream can be built for the Digilent [Arty A7][d-arty] FPGA board using the project located in the [`jam-demo-firmware/`](jam-demo-firmware/) directory.

[d-arty]: https://store.digilentinc.com/arty-a7-artix-7-fpga-development-board/
[w-jtag]: https://en.wikipedia.org/wiki/JTAG#Uses
[x-jtag-axi-microzed]: https://forums.xilinx.com/t5/Xcell-Daily-Blog-Archived/Adam-Taylor-s-MicroZed-Chronicles-Part-226-Debugging-FPGA/ba-p/811281
[x-jtag-axi-example]: https://xilinx-wiki.atlassian.net/wiki/spaces/A/pages/64488613/Using+the+JTAG+to+AXI+to+test+Peripherals+in+Zynq+Ultrascale
[x-jtag-axi-v12]: https://www.xilinx.com/support/documentation/ip_documentation/jtag_axi/v1_2/pg174-jtag-axi.pdf
[x-vivado]: https://www.xilinx.com/products/design-tools/vivado.html
