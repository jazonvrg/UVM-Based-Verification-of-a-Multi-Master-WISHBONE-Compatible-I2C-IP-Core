class wishbone_agent extends uvm_agent;
	`uvm_component_utils(wishbone_agent)
  	
  	wishbone_sequencer seq;
  	wishbone_driver drv;
  	wishbone_monitor mnt;
	
	virtual wishbone_if vif;

  	function new(string name = "wishbone_agent", uvm_component parent = null);
    		super.new(name, parent);
  	endfunction: new
	
  	function void build_phase(uvm_phase phase);
    		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)
    		if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "vif", vif)) begin
      			`uvm_fatal(get_type_name(), "virtual wishbone_if was not provided")
		end
    		mnt = wishbone_monitor::type_id::create("mnt", this);
    		`uvm_config_db#(virtual wishbone_if)::set(this, "mnt", "vif", vif);
    		if (is_active == UVM_ACTIVE) begin
      			seq = wishbone_sequencer::type_id::create("seq", this);
      			drv = wishbone_driver::type_id::create("drv", this);
      			uvm_config_db#(virtual wishbone_if)::set(this, "drv", "vif", vif);
    		end
		`uvm_info("build_phase", "Exiting...", UVM_LOW)
  	endfunction: build_phase
	
  	function void connect_phase(uvm_phase phase);
    		super.connect_phase(phase);
		`uvm_info("connect_phase", "Entered...", UVM_LOW)
    		if (is_active == UVM_ACTIVE) begin
      			drv.seq_item_port.connect(seq.seq_item_export);
		end
		`uvm_info("connect_phase", "Exiting...", UVM_LOW)
  	endfunction: connect_phase

endclass: wishbone_agent
