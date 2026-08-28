class wishbone_driver extends uvm_driver #(wishbone_transaction);
	`uvm_component_utils(wishbone_driver)
	
	virtual wishbone_if wishbone_vif;

	function new(string name = "wishbone_driver", uvm_component parent);
		super.new(name, parent);
	endfunction: new	

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("build_phase", "Entered...", UVM_HIGH)
		if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "wishbone_vif", wishbone_vif) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get wishbone_vif from uvm_config_db"));
		end	
		`uvm_info("build_phase", "Exiting...", UVM_HIGH)
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_HIGH)
		wishbone_vif.wb_addr <= 3'h0;
		wishbone_vif.we_i <= 1'b0;
		wishbone_vif.stb_i <= 1'b0;
		wishbone_vif.cyc_i <= 1'b0;
		wishbone_vif.wb_dat_i <= 8'h0;
		wait (!wishbone_vif.wb_rst_i);
		forever begin
			seq_item_port.get_next_item(req);
			drive();
			seq_item_port.item_donersp);
		end
		`uvm_info("run_phase", "Exiting...", UVM_HIGH)
	endtask: run_phase

	virtual task drive();
		/** Address phase **/
		@(posedge wishbone_vif.wb_clk_in);
		wishbone_vif.wb_adr_i <= req.addr;
		if (req.xact_type == wishbone_transaction::WRITE) begin
			wishbone_vif.we_i <= 1'b1;
		end else begin
			wishbone_vif.we_i <= 1'b0;
		end
		wishbone_vif.stb_i <= 1'b1;
		wishbone_vif.cyc_i <= 1'b1;
		if (req.xact_type == wishbone_transaction::WRITE) begin
			wishbone_vif.wb_dat_i <= req.data;
		end
		/** Data phase **/
		do begin
			@(posedge wishbone_vif.wb_clk_in);
		end while (wishbone_vif.wb_ack_o === 1);
		$cast(rsp, req.clone());
		rsp.set_id_info(req);
		if (req.xact_type == wishbone_transaction::READ) begin
			rsp.data = wishbone_vif.wb_dat_o;
		end
		/** Idle **/
		wishbone_vif.stb_i <= 1'b0;
		wishbone_vif.cyc_i <= 1'b0;
		wishbone_vif.we_i <= 1'b0;
		if (req.xact_type == wishbone_transaction::READ) begin
			`uvm_info(get_type_name(), $sformatf("READ! addr = %0h, data = %0h", req.addr, req.data), UVM_HIGH);
		end else begin
			`uvm_info(get_type_name(), $sformatf("WRITE! addr = %0h, data = %0h", req.addr, req.data), UVM_HIGH);
		end
	endtask

endclass: wishbone_driver
