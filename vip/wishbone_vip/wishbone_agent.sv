class wishbone_agent extends uvm_agent;
	`uvm_component_utils(wishbone_agent)

	wishbone_sequencer seq;
	wishbone_driver drv;
	wishbone_monitor mnt;
	
	virtual wishbone_if wishbone_vif;

	function new(string name = "wishbone_agent", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH)
		if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "wishbone_vif", wishbone_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get wishbone_vif from uvm_config_db"));
		end
		if (is_active == UVM_ACTIVE) begin
			seq = wishbone_sequecer::type_id::create("seq", this);
			drv = wishbone_driver::type_id::create("drv", this);
			mnt = wishbone_monitor::type_id::create("mnt", this);
			uvm_config_db#(virtual wishbone_if)::set(this, "drv", "wishbone_vif", wishbone_vif);
			uvm_config_db#(virtual wishbone_if)::set(this, "mnt", "wishbone_vif", wishbone_vif);
		end else begin
			`uvm_info(get_type_name(), $sformatf("Passive agent is configured"), UVM_HIGH)
			mnt = wishbone_monitor::type_id::create("mnt", this);
			uvm_config_db#(virtual wishbone_if)::set(this, "mnt", "wishbone_vif", wishbone_vif);
		end
		`uvm_info("build_phase", "Exiting...", UVM_HIGH)
	endfunction: build_phase

	virtual function void connect_phase(uvm_phase phase)
		super.connect_phase(phase);
		if (get_is_active() == UVM_ACTIVE) begin
			drv.seq_item_port.connect(seq.seq_item_export);
		end
	endfunction: connect_phase

endclass: wishbone_agent

