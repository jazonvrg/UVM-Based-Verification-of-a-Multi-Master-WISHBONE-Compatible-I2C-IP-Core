class i2c_monitor extends uvm_monitor;
	`uvm_component_utils(i2c_monitor)

	function new(string name = "i2c_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH)
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_if from uvm_config_db"));	
		end
		if (!uvm_config_db#(virtual i2c_configuration)::get(this, "", "cfg", cfg)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_configuration from uvm_config_db"));
		end
		`uvm_info("build_ohase", "Exiting...", UVM_HIGH)
	endfunction: build_phase

	virtual task run_phase(uvm_phase);
		`uvm_info("run_phase", "Entered...", UVM_HIGH)
			
		`uvm_info("run_phase", "Exiting...", UVM_HIGH)
	endtask: run_phase

endclass: i2c_monitor
