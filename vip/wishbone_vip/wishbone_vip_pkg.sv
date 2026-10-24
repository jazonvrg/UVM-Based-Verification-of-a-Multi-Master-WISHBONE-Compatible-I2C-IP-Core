`ifndef WISHBONE_VIP_PKG_SV
`define WISHBONE_VIP_PKG_SV
package wishbone_vip_pkg;
  timeunit 1ns;
  timeprecision 1ps;
  import uvm_pkg::*;
  `include "uvm_macros.svh"
  `include "wishbone_transaction.sv"
  `include "wishbone_sequencer.sv"
  `include "wishbone_driver.sv"
  `include "wishbone_monitor.sv"
  `include "wishbone_agent.sv"
endpackage
`endif
