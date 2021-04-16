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

simple_bd inst_simple_bd (
    .clock (clk_pll),
    .resetn (clk_pll_resetn)
);

endmodule
