class i2c_agent extends uvm_agent;
	`uvm_component_utils(i2c_agent)

	i2c_sequencer seq;
	i2c_driver drv;
	i2c_monitor mnt;

	virtual i2c_if i2c_vif;

	function new(string name = "i2c_agent", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH)
		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "i2c_vif", i2c_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_if from uvm_config_db"));
		end
		if (is_active == UVM_ACTIVE) begin
			`uvm_info(get_type_name(), $sformatf("Active agent is configured"), UVM_HIGH);
			seq = i2c_sequencer::type_id::create("seq", this);
			drv = i2c_driver::type_id::create("drv", this);
			mnt = i2c_monitor::type_id::create("mnt", this);
			uvm_config_db#(virtual i2c_if)::set(this, "drv", "i2c_vif", i2c_vif);
			uvm_config_db#(virtual i2c_if)::set(this, "mnt", "i2c_vif", i2c_vif);
		end else begin
			mnt = i2c_monitor::type_id::create("mnt", this);
			uvm_config_db#(virtual i2c_if)::set(this, "mnt", "i2c_vif", i2c_vif);
		end
		`uvm_info("build_phase", "Exiting...", UVM_HIGH)
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		if (get_is_active() == UVM_ACTIVE) begin
			drv.seq_item_port.connect(seq.seq_item_export);
		end
	endfunction: connect_phase

endclass: i2c_agent
