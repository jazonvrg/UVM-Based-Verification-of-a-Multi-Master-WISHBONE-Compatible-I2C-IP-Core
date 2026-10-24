class wishbone_monitor extends uvm_monitor;
	`uvm_component_utils(wishbone_monitor)
  	
	virtual wishbone_if wb_vif;
	wishbone_transaction trans;
  	uvm_analysis_port #(wishbone_transaction) wb_observed_port;
  	logic last_req;

  	function new(string name = "wishbone_monitor", uvm_component parent);
		super.new(name, parent);
  		wb_observed_port = new("wb_observed_port", this);
	endfunction: new
	
	function void build_phase(uvm_phase phase);
    	super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)

    	if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "wb_vif", wb_vif)) begin
      		`uvm_fatal(get_type_name(), "Failed to get wb_vif from uvm_config_db")
		end

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
  	endfunction: build_phase
	
  	task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)

		last_req = 1'b0;
    	forever begin
      		@(posedge wb_vif.wb_clk_i);
      		if (wb_vif.wb_cyc_i === 1'b0 && vif.wb_stb_i === 1'b0) last_req = 0;
      		if (wb_vif.wb_cyc_i === 1'b1 && vif.wb_stb_i === 1'b1 && vif.wb_ack_o === 1'b1 && last_req === 1'b0) begin
        		last_req = 1;
        		trans = wishbone_transaction::type_id::create("trans", this);
				$cast(trans.xact_type, wb_vif.wb_we_i);
        		trans.addr = wb_vif.wb_adr_i;
        		trans.wdata = wb_vif.wb_dat_i;
        		trans.rdata = wb_vif.wb_dat_o;
        		trans.success = 1'b1;
				`uvm_info(get_type_name(), $sformatf("Observed transaction: \n%s", trans.sprint(), UVM_LOW)
        		wb_observed_port.write(trans);
      		end
    	end

		`uvm_info("run_phase", "Exiting...", UVM_LOW)
  	endtask: run_phase

endclass: wishbone_monitor
