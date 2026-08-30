class i2c_sequencer extends uvm_sequencer #(i2c_transaction);
	`uvm_utils_component(i2c_sequencer)

	logic string msg = "[I2C_VIP][I2C_SEQUENCER]";

	function new(string name = "i2c_sequencer", uvm_component parent);
		super.new(name, parent);
	endfunction: new

endclass: i2c_sequencer
