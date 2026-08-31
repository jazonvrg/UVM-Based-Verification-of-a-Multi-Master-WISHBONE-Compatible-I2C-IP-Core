class i2c_driver extends uvm_driver;
	`uvm_utils_component(i2c_driver)

	typedef enum logic {
		WRITE = 1'b0,
		READ  = 1'b1
	} xact_type_enum;

	logic [6:0] mem_addr;
	xact_type_enum mem_rw;

	function new(string name = "i2c_driver", uvm_component parent);
		super.new(name, parent);
		item_observed_port = new("item_observed_port", this);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH)
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_if from uvm_config_db"));
		end
		`uvm_info("build_phase", "Exiting...", UVM_HIGH) 
	endfunction: build_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_HIGH)
		i2c_vif.scl_padoen_oe = 1'b1;
		i2c_vif.sda_padoen_oe = 1'b1;
		forever begin
			drive();
		end	
		`uvm_info("run_phase", "Exiting...", UVM_HIGH)
	endtask: run_phase

	virtual task drive();
		wait (i2c_vif.scl_pad_i === 1'b1 && i2c_vif.sda === 1'b1);
		@(negedge i2c_vif.sda iff i2c_vif.scl === 1'b1);
		for (int i = 6; i >= 0; i = i - 1) begin
			@(posedge i2c_vif.scl);
			mem_addr[i] = i2c_vif.sda;
		end
		@(posedge i2c_vif.scl);
		mem_rw = i2c_vif.sda;
		
	endtask

endclass: i2c_driver
