`ifndef GUARD_WIS_PACKAGE__SV
`define GUARD_WIS_PACKAGE__SV

package wishbone_pkg;
	import uvm_pkg::*;

  	`include "wishbone_define.sv"
  	`include "wishbone_transaction.sv"
  	`include "wishbone_sequencer.sv"
  	`include "wishbone_driver.sv"
  	`include "wishbone_monitor.sv"
  	`include "wishbone_agent.sv"

endpackage: ahb_pkg

`endif


