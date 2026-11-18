`timescale 1ns/1ps

// Part 2 testbench: one core, one memory. The gate core drives its own environment; there is
// no RTL shadow core supplying memory requests or deciding test completion.
module cvw_tb;
  import cvw::*;
  `include "config.vh"
  `include "parameter-defs.vh"

  // Follow the derivative's CVW uncore-RAM map. Keep a dense low region for
  // firmware loading, then use sparse storage for addresses elsewhere in RAM.
  localparam logic [33:0] MEM_BASE = P.UNCORE_RAM_BASE[33:0];
  localparam logic [33:0] MEM_RANGE = P.UNCORE_RAM_RANGE[33:0];
  localparam int MEM_BYTES = 'h80000;
  localparam logic [33:0] TOHOST = MEM_BASE + 'h40000;
  logic clk = 0;
  logic reset = 1;
  always #5 clk = ~clk;

  logic [31:0] HRDATA;
  wire HREADY = 1'b1;
  wire HRESP = 1'b0;
  wire [63:0] MTIME_CLINT = 64'b0;
  wire MTimerInt = 1'b0, MExtInt = 1'b0, SExtInt = 1'b0, MSwInt = 1'b0;
  wire ExternalStall = 1'b0;
  wire HCLK, HRESETn, HWRITE, HMASTLOCK;
  wire [33:0] HADDR;
  wire [31:0] HWDATA;
  wire [3:0] HWSTRB, HPROT;
  wire [2:0] HSIZE, HBURST;
  wire [1:0] HTRANS;

`ifdef CVW_GATE
  wallypipelinedcore_gate dut (
`else
  wallypipelinedcore #(P) dut (
`endif
    .clk, .reset, .MTimerInt, .MExtInt, .SExtInt, .MSwInt, .MTIME_CLINT,
    .HRDATA, .HREADY, .HRESP, .HCLK, .HRESETn, .HADDR, .HWDATA, .HWSTRB,
    .HWRITE, .HSIZE, .HBURST, .HPROT, .HTRANS, .HMASTLOCK, .ExternalStall
  );

  // AHB-Lite has separate address and data phases. Delay address/control
  // one cycle; HWDATA and HWSTRB already belong to that delayed transfer.
  logic active_d = 0, write_d = 0;
  logic [33:0] address_d = 0;
  logic [2:0] size_d = 0;
  bit [7:0] memory [0:MEM_BYTES-1];
  bit [7:0] extended_memory [int unsigned];
  string firmware;
  integer firmware_fd, result_fd, stores_fd, registers_fd;
  integer max_cycles = 100000;
  integer cycles = 0;
  integer offset;

  function automatic bit in_memory(input logic [33:0] address);
    return P.UNCORE_RAM_SUPPORTED && address >= MEM_BASE &&
           address - MEM_BASE <= MEM_RANGE;
  endfunction

  function automatic logic [7:0] read_byte(input int unsigned byte_offset);
    if (byte_offset < MEM_BYTES)
      return memory[byte_offset];
    if (extended_memory.exists(byte_offset))
      return extended_memory[byte_offset];
    return 8'h00;
  endfunction

  initial begin
    if (P.XLEN != 32 || P.AHBW != 32 || P.PA_BITS != 34 ||
        P.E_SUPPORTED || !P.ZICSR_SUPPORTED || P.M_SUPPORTED ||
        P.ICACHE_SUPPORTED || P.DCACHE_SUPPORTED ||
        P.RESET_VECTOR != 64'h80000000)
      $fatal(1, "Unsupported core configuration");
    if (!$value$plusargs("firmware=%s", firmware))
      $fatal(1, "Missing +firmware=/absolute/path/sbst.hex");
    if ($value$plusargs("max_cycles=%d", max_cycles)) begin end
    if (max_cycles <= 0) $fatal(1, "max_cycles must be positive");
    firmware_fd = $fopen(firmware, "r");
    if (!firmware_fd) $fatal(1, "Cannot read %s", firmware);
    $fclose(firmware_fd);
    // CVW's RAM model is zero initialized; firmware overlays its loaded bytes.
    $readmemh(firmware, memory);
    stores_fd = $fopen("stores.log", "w");
    if (!stores_fd) $fatal(1, "Cannot create stores.log");
    registers_fd = $fopen("register_writes.log", "w");
    if (!registers_fd) $fatal(1, "Cannot create register_writes.log");
    $display("CVW: firmware=%s reset=%h RAM=%h..%h", firmware,
             P.RESET_VECTOR, MEM_BASE, MEM_BASE + MEM_RANGE);
    repeat (5) @(negedge clk);
    reset = 0;
  end

  // Dump the core's ports. These are EVCD
  // core ports for Z01X, independent of the GUI waveform database.
  initial begin
    if ($test$plusargs("evcd")) begin
      $dumpports(dut, "core.evcd");
    end
`ifdef VCS
    $vcdplusfile("waves.vpd");
    $vcdpluson(0, dut);
`endif
  end

  // CVW writes its register file on the falling edge. These register-file
  // interface names also exist in the supplied synthesized netlist.
  always @(negedge clk) begin
    if (!reset && dut.ieu.dp.regf.we3 && dut.ieu.dp.regf.a3 != 0) begin
      $fdisplay(registers_fd, "%0t x%0d=%h", $time,
                dut.ieu.dp.regf.a3, dut.ieu.dp.regf.wd3);
      $fflush(registers_fd);
    end
  end

  // Combinational read during the data phase, zero wait states. Align down
  // to a bus word; the LSU chooses the requested byte/halfword lane.
  always_comb begin
    HRDATA = '0;
    if (active_d && !write_d && in_memory(address_d)) begin
      HRDATA = {
        read_byte(((address_d - MEM_BASE) & 34'h3fffffffc) + 3),
        read_byte(((address_d - MEM_BASE) & 34'h3fffffffc) + 2),
        read_byte(((address_d - MEM_BASE) & 34'h3fffffffc) + 1),
        read_byte(((address_d - MEM_BASE) & 34'h3fffffffc) + 0)
      };
    end
  end

  always @(posedge clk) begin
    if (reset) begin
      active_d <= 0;
      write_d <= 0;
      cycles <= 0;
    end else begin
      cycles <= cycles + 1;
      if (cycles >= max_cycles) $fatal(1, "CVW TIMEOUT after %0d cycles", cycles);
      if ($isunknown(HTRANS)) $fatal(1, "Unknown AHB transfer control");
      if (HTRANS[1]) begin
        if ($isunknown({HADDR, HWRITE, HSIZE}))
          $fatal(1, "Unknown AHB address/control");
        if (!in_memory(HADDR)) $fatal(1, "Address outside configured RAM: %h", HADDR);
        if (HSIZE > 2) $fatal(1, "Unsupported AHB access size %h", HSIZE);
      end
      active_d <= HTRANS[1];
      write_d <= HWRITE;
      address_d <= HADDR;
      size_d <= HSIZE;
      if (active_d && write_d) begin
        if ($isunknown({HWDATA, HWSTRB})) $fatal(1, "Unknown AHB store data/mask");
        offset = (address_d - MEM_BASE) & 34'h3fffffffc;
        for (int lane = 0; lane < 4; lane++) begin
          if (HWSTRB[lane]) begin
            if (offset + lane < MEM_BYTES)
              memory[offset + lane] <= HWDATA[8*lane +: 8];
            else
              extended_memory[offset + lane] = HWDATA[8*lane +: 8];
          end
        end
        $fdisplay(stores_fd, "%0t addr=%h data=%h mask=%h", $time, address_d, HWDATA, HWSTRB);
        $fflush(stores_fd);
        if (address_d == TOHOST) begin
          if (size_d != 2 || HWSTRB != 4'hf)
            $fatal(1, "Mailbox requires a full-word store");
          if (HWDATA !== 32'd1) $fatal(1, "CVW FAIL: exit mailbox=%h", HWDATA);
          $display("CVW PASS: exit=0 cycles=%0d", cycles);
          result_fd = $fopen("PASS", "w");
          if (!result_fd) $fatal(1, "Cannot create PASS marker");
          $fdisplay(result_fd, "CVW PASS cycles=%0d", cycles);
          $fclose(result_fd);
          // Allow the final bus transaction to reach Z01X's +2ns strobe.
          #3;
          $fclose(stores_fd);
          $fclose(registers_fd);
          $finish;
        end
      end
    end
  end
endmodule
