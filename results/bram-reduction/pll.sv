/**
 * PLL configuration
 *
 * This Verilog module was generated automatically
 * using the gowin-pll tool.
 * Use at your own risk.
 *
 * Target-Device:                GW2AR-18 C8/I7
 * Given input frequency:        27.000 MHz
 * Requested output frequency:   114.750 MHz
 * Achieved output frequency:    114.750 MHz
 */

module inference_clock(
        input  clock_in,
        output clock_out,
        output locked
    );

    rPLL #(
        .FCLKIN("27.0"),
        .IDIV_SEL(3), // -> PFD = 6.75 MHz (range: 3-500 MHz)
        .FBDIV_SEL(16), // -> CLKOUT = 114.75 MHz (range: 3.90625-625 MHz)
        .ODIV_SEL(8) // -> VCO = 918.0 MHz (range: 500-1250 MHz)
    ) pll (.CLKOUTP(), .CLKOUTD(), .CLKOUTD3(), .RESET(1'b0), .RESET_P(1'b0), .CLKFB(1'b0), .FBDSEL(6'b0), .IDSEL(6'b0), .ODSEL(6'b0), .PSDA(4'b0), .DUTYDA(4'b0), .FDLY(4'b0), 
        .CLKIN(clock_in), // 27.0 MHz
        .CLKOUT(clock_out), // 114.75 MHz
        .LOCK(locked)
    );

endmodule
