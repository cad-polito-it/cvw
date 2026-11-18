`timescale 1ns/1ps

// Observe the core's external AHB outputs, as the RI5CY flow observes the
// processor's instruction/data interface outputs. The first rising edge after
// reset is 55ns; sample settled outputs at 57ns, then every 10ns.
module strobe;
  initial begin
    #57;
    forever begin
      $fs_strobe(wallypipelinedcore_gate.HADDR);
      $fs_strobe(wallypipelinedcore_gate.HWDATA);
      $fs_strobe(wallypipelinedcore_gate.HWSTRB);
      $fs_strobe(wallypipelinedcore_gate.HWRITE);
      $fs_strobe(wallypipelinedcore_gate.HSIZE);
      $fs_strobe(wallypipelinedcore_gate.HBURST);
      $fs_strobe(wallypipelinedcore_gate.HPROT);
      $fs_strobe(wallypipelinedcore_gate.HTRANS);
      $fs_strobe(wallypipelinedcore_gate.HMASTLOCK);
      #10;
    end
  end
endmodule
