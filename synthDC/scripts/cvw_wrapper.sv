// Bind the same generated parameter structure used by testbench/cvw_tb.sv.
// Keep the core's external interface and dut instance for the DC export step.
import cvw::*;
`include "config.vh"
`include "parameter-defs.vh"

module cvw_synthesis_top (
  input  logic                 clk, reset,
  input  logic                 MTimerInt, MExtInt, SExtInt, MSwInt,
  input  logic [63:0]          MTIME_CLINT,
  input  logic [P.AHBW-1:0]    HRDATA,
  input  logic                 HREADY, HRESP,
  output logic                 HCLK, HRESETn,
  output logic [P.PA_BITS-1:0] HADDR,
  output logic [P.AHBW-1:0]    HWDATA,
  output logic [P.XLEN/8-1:0]  HWSTRB,
  output logic                 HWRITE,
  output logic [2:0]           HSIZE, HBURST,
  output logic [3:0]           HPROT,
  output logic [1:0]           HTRANS,
  output logic                 HMASTLOCK,
  input  logic                 ExternalStall
);
  wallypipelinedcore #(P) dut (.*);
endmodule
