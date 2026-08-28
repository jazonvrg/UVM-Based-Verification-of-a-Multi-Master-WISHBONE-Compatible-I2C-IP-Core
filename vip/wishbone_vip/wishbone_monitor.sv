class wishbone_monitor extends uvm_monitor;
	`uvm_component_utils(wishbone_monitor)

	virtual wishbone_if wishbone_vif;
	uvm_analysis_port #(wishbone_transaction) wishbone_observed_port;	

	function new(string name = "wishbone_monitor", uvm_component parent);
		super.new(name, parent);
	endfunction: new

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH);
		if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "wishbone_vif", wishbone_vif)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get wishbone_vif from uvm_config_db"));
		end
		`uvm_info("build_phase", "Exiting...", UVM_HIGH);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_HIGH);
		forever begin
			drive();
		end
		`uvm_info("run_phase", "Exiting...", UVM_HIGH);
	endtask: run_phase
	
	virtual task drive();
		trans = wishbone_transaction::type_id::create("trans", this);
		do begin
			@(posedge ahb_vif.HCLK);
		end while (wishbone_vif.wb_ack_o === 1);
		trans.addr = wishbone_vif.addr;
		if (wishbone_vif.wb_we_i === 1'b1) begin
			trans.data = wishbone_vif.wb_dat_i;
		end else begin
			trans.data = wishbone_vif.wb_data_o;
		end
		$cast(trans.xact_type, wishbone_vif.wb_we_i);
		`uvm_info(get_type_name(), $sformatf("Observed transaction: \n%s", trans.sprint()), UVM_HIGH)
		wishbone_observed_port.write(trans);
	endtask: drive	

endclass: wishbone_monitor
