class wishbone_driver extends uvm_driver #(wishbone_transaction);
  	`uvm_component_utils(wishbone_driver)

  	virtual wishbone_if wb_vif;
	wishbone_transaction req;
	logic [7:0] rdata;
	logic success, ack;
	int timeout = 100;
	
  	function new(string name = "wishbone_driver", uvm_component parent);
    		super.new(name, parent);
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
  
		/* Initialize */
		wait(wb_vif.wb_rst_i);
    		wb_vif.wb_adr_i = '0;
    		wb_vif.wb_dat_i = '0;
    		wb_vif.wb_we_i = 1'b0;
    		wb_vif.wb_stb_i = 1'b0;
    		wb_vif.wb_cyc_i = 1'b0;
		/* In process */
    		forever begin
			seq_item_port.get_next_item(req);
      			drive();
      			seq_item_port.item_done(rsp);
      			`uvm_info("WB_DRV", rsp.convert2string(), UVM_HIGH)
    		end
		
		`uvm_info("run_phase", "Exiting...", UVM_LOW)
  	endtask: run_phase

  	task drive();
		/* Initialize */
    		read_data = '0;
    		success = 1'b0;
    		got_ack = 1'b0;
		/* Setup */
    		@(posedge vif.wb_clk_i);
    		wb_vif.wb_adr_i <= req.addr;
    		wb_vif.wb_dat_i <= (req.kind == WB_WRITE) ? req.wdata : 8'h00;
    		wb_vif.wb_we_i  <= (req.kind == WB_WRITE);
    		wb_vif.wb_stb_i <= 1'b1;
    		wb_vif.wb_cyc_i <= 1'b1;
		/* Handshake */
		for(int i = 0; i < timeout; i++) begin
      			@(posedge vif.wb_clk_i);
      			if (vif.wb_ack_o === 1'b1) begin
        			ack = 1'b1;
        			success = 1'b1;
        			if (req.kind == WB_READ) begin
					read_data = vif.wb_dat_o;
				end
        			break;
			end
      		end
    		if (ack === 1'b0) begin
      			`uvm_error(get_type_name(), $sformatf("ACK signal is inactive"))
		end
		/* Response */
      		$cast(rsp, req.clone());
		rsp.set_id_info(req);
      		rsp.rdata = rdata;
      		rsp.success = success;
  	endtask

endclass: wishbone_driver
