class wishbone_sequencer extends uvm_sequencer #(wishbone_transaction);
	`uvm_component_utils(wishbone_sequencer)

	local string msg = "[WISHBONE_VIP][WISHBONE_SEQUENCER]";

	function new(string name = "wishbone_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction: new

endclass: wishbone_sequencer
