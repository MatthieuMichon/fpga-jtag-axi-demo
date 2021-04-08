`default_nettype none
`timescale 1 ns / 1 ps

module artya7c #(
	// 
    parameter TARGET_FREQUENCY = 100
)(
	input wire clk100,
	input wire rst,

	input wire [8-1:0] ja,
	input wire [8-1:0] jb,
	output reg [8-1:0] jc,
	output reg [8-1:0] jd
);
// -----------------------------------------------------------------------------
`ifdef vivado

wire pll_lock;
wire clk_pll_local;
wire fb;

localparam real CLKOUT0_DIVIDE_F = 1200.0/(1.0 * TARGET_FREQUENCY);
// MMCM (fancy PLL) refer to Xilinx UG472 for details
MMCME2_BASE #(
    .CLKIN1_PERIOD (10.0), // = 1 / Fin
    .CLKFBOUT_MULT_F (12.0),  // = M (Fvco = Fin * M)
    .CLKOUT0_DIVIDE_F (CLKOUT0_DIVIDE_F)
) inst_mmcme2_base_clk100 (
    .CLKIN1 (clk100),
    .CLKFBOUT (fb),
    .CLKFBIN (fb),
    .CLKOUT0 (clk_pll_local),
    .LOCKED (pll_lock)
);
BUFG bufg_inst (.I (clk_pll_local), .O (clk_pll));

reg clk_pll_resetn;
always @(posedge clk_pll) clk_pll_resetn <= pll_lock;

jtag_axi inst_jtag_axi (
    .aclk (clk_pll),
    .aresetn (clk_pll_resetn),

    .m_axi_awid (awid), // undocumented
    .m_axi_awaddr (awaddr),
    .m_axi_awlen (awlen),
    .m_axi_awsize (awsize),
    .m_axi_awburst (awburst),
    .m_axi_awlock (awlock),
    .m_axi_awcache (awcache),
    .m_axi_awprot (awprot), // constant
    .m_axi_awqos (awqos), // undocumented
    .m_axi_awvalid (awvalid),
    .m_axi_awready (awready),

    .m_axi_wdata (wdata),
    .m_axi_wstrb (wstrb),
    .m_axi_wlast (wlast),
    .m_axi_wvalid (wvalid),
    .m_axi_wready (wready),

    .m_axi_bid (bid),
    .m_axi_bresp (bresp),
    .m_axi_bvalid (bvalid),
    .m_axi_bready (bready),

    .m_axi_arid (arid),
    .m_axi_araddr (araddr),
    .m_axi_arlen (arlen),
    .m_axi_arsize (arsize),
    .m_axi_arburst (arburst),
    .m_axi_arlock (arlock),
    .m_axi_arcache (arcache),
    .m_axi_arprot (arprot),
    .m_axi_arqos (arqos),
    .m_axi_arvalid (arvalid),
    .m_axi_arready (arready),

    .m_axi_rid (rid),
    .m_axi_rdata (rdata),
    .m_axi_rresp (rresp),
    .m_axi_rlast (rlast),
    .m_axi_rvalid (rvalid),
    .m_axi_rready (rready)
);
`endif
endmodule
