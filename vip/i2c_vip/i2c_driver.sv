class i2c_driver extends uvm_driver;
	`uvm_utils_component(i2c_driver)

	function new(string name = "i2c_driver", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info(
	end


endclass: i2c_driver
