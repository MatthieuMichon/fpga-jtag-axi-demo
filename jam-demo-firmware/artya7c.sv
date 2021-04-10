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

wire pll_lock;
wire clk_pll_local;
wire clk_pll;
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

localparam C_M_AXI_ADDR_WIDTH = 32;
localparam C_M_AXI_DATA_WIDTH = 32;

(* dont_touch = "true" *) wire awready;
(* dont_touch = "true" *) wire awvalid;
(* dont_touch = "true" *) wire [C_M_AXI_ADDR_WIDTH-1:0] awaddr;
(* dont_touch = "true" *) wire [C_M_AXI_DATA_WIDTH-1:0] wdata;
(* dont_touch = "true" *) wire [C_M_AXI_DATA_WIDTH/8-1:0] wstrb;
(* dont_touch = "true" *) wire wready;
(* dont_touch = "true" *) wire wvalid;
(* dont_touch = "true" *) wire wlast;
(* dont_touch = "true" *) wire bready;
(* dont_touch = "true" *) wire bvalid;
(* dont_touch = "true" *) wire [0:0] bid;
(* dont_touch = "true" *) wire [1:0] bresp;
(* dont_touch = "true" *) wire arid;
(* dont_touch = "true" *) wire [C_M_AXI_ADDR_WIDTH-1:0] araddr;
(* dont_touch = "true" *) wire arlock;
(* dont_touch = "true" *) wire arqos;
(* dont_touch = "true" *) wire arvalid;
(* dont_touch = "true" *) wire arready;
(* dont_touch = "true" *) wire [0:0] rid;
(* dont_touch = "true" *) wire [C_M_AXI_DATA_WIDTH-1:0] rdata;
(* dont_touch = "true" *) wire [1:0] rresp;
(* dont_touch = "true" *) wire rlast;
(* dont_touch = "true" *) wire rvalid;
(* dont_touch = "true" *) wire rready;

jtag_axi_xip inst_jtag_axi_xip (
        .aclk (clk_pll),
        .aresetn (clk_pll_resetn),
    // write address channel
        .m_axi_awready (awready),
        .m_axi_awvalid (awvalid),
        .m_axi_awaddr (awaddr),
    // write data channel
        .m_axi_wready (wready),
        .m_axi_wvalid (wvalid),
        .m_axi_wdata (wdata),
        .m_axi_wstrb (wstrb),
        .m_axi_wlast (wlast),
    // write response channel
        .m_axi_bready (bready),
        .m_axi_bvalid (bvalid),
        .m_axi_bid (bid),
        .m_axi_bresp (bresp),
    // read address channel
        .m_axi_arid (arid),
        .m_axi_araddr (araddr),
        .m_axi_arlock (arlock),
        .m_axi_arqos (arqos),
        .m_axi_arvalid (arvalid),
        .m_axi_arready (arready),
    // read data channel
        .m_axi_rid (rid),
        .m_axi_rdata (rdata),
        .m_axi_rresp (rresp),
        .m_axi_rlast (rlast),
        .m_axi_rvalid (rvalid),
        .m_axi_rready (rready)
);

assign ja = awaddr[$bits(ja)-1:0];
assign jb = wdata[$bits(ja)-1:0];
assign jc = araddr[$bits(ja)-1:0];
assign jd = rdata[$bits(ja)-1:0];

ila_xip inst_ila_xip (
    .clk (clk_pll),
    .probe0 (awaddr)
);
endmodule
