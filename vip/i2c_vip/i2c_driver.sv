class i2c_driver extends uvm_driver;
	`uvm_component_utils(i2c_driver)

	typedef enum logic {
		WRITE = 1'b0,
		READ  = 1'b1
	} xact_type_enum;

	logic [6:0] mem_addr;
	xact_type_enum mem_rw;

	virtual i2c_if i2c_vif;

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
		if (!uvm_config_db#(virtual i2c_configuration)::get(this, "", "cfg", cfg)) begin
			`uvm_fatal(get_type_name(), $sformatf("Failed to get i2c_configuration from uvm_config_db"));
		end
		`uvm_info("build_phase", "Exiting...", UVM_HIGH) 
	endfunction: build_phase
	
	virtual task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_HIGH)
		drv_scl = 1'b1;
		drv_sda = 1'b1;	
		forever begin
			drive();
		end	
		`uvm_info("run_phase", "Exiting...", UVM_HIGH)
	endtask: run_phase

	virtual task drive();
		/* Start */
		wait (vif.scl === 1'b1 && vif.sda === 1'b1);
		@(negedge vif.sda iff vif.scl === 1'b1);
		/* Address phase */
		for (int i = 6; i >= 0; i = i - 1) begin
			@(posedge i2c_vif.scl);
			mem_addr[i] = xact_type_enum'(i2c_vif.sda);
		end
		/* Read\Write Enable */
		@(posedge i2c_vif.scl);
		mem_rw = i2c_vif.sda;
		if (mem_addr === cfg.addr) begin
			@(negedge i2c_vif.scl);
			vif.sda = 1'b0;
			/* Release */
			@(negedge i2c_vif.scl);
			vif.sda = 1'b1;
			seq_item_port.get_next_item(req);				
			if (mem_rw === WRITE) begin
				/* Data phase */
				for (int i = 7; i >= 0; i = i - 1) begin
					@(posedge i2c_vif.scl);
					req.data[i] = i2c_vif.sda;
				end
				/* Ack */
				@(negedge i2c_vif.scl);
				drv_sda = 1'b0;
				/* Release */
				@(negedge i2c_vif.scl);
				drv_sda = 1'b1;	
			end else begin
				/* Data phase */
				for (int i = 7; i >= 0; i = i - 1) begin
					drv_sda = req.data[i];
					@(negedge i2c_v.sda);
				end
				/* Release */
				ack_signal = 1'b1;
				/* Ack / Nack */
				@(posedge i2c_vif.scl);
			end
			seq_item_port.item_done();
		end
	endtask

endclass: i2c_driver
