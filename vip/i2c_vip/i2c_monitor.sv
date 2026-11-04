class i2c_monitor extends uvm_monitor;
	`uvm_component_utils(i2c_monitor)
		
  	virtual i2c_if vif;
  	uvm_analysis_port #(i2c_transaction) observed_bus_ap;
  	
	logic active;
  	i2c_transaction current_item;
  	int bit_count;
  	logic [7:0] shift_byte;

  	function new(string name = "i2c_monitor", uvm_component parent);
    		super.new(name, parent);
    		observed_bus_ap = new("observed_bus_ap", this);
    		bus_cg = new();
    		active = 0;
    		bit_count = 0;
    		shift_byte = '0;
  	endfunction: new
	
  	function void build_phase(uvm_phase phase);
		`uvm_info("build_phase", "Entered...", UVM_LOW)
    		
		super.build_phase(phase);
    		if (!uvm_config_db#(virtual i2c_if)::get(this, "", "vif", vif)) begin
      			`uvm_fatal(get_type_name(), "Failed to get i2c_if from config_db")
		end		

		`uvm_info("build_phase", "Exiting...", UVM_LOW)
  	endfunction: build_phase

  	task run_phase(uvm_phase phase);
		`uvm_info("run_phase", "Entered...", UVM_LOW)

    		fork
      			capture_start_and_restart();
      			capture_bytes_and_ack_slots();
      			capture_stop_and_publish();
    		join
		
		`uvm_info("run_phase", "Exiting...", UVM_LOW)
  	endtask: run_phase
	
  	task capture_start_and_restart();
    		forever begin
      			@(negedge vif.sda_line);
      			if (vif.scl_line === 1'b1) begin
        			if (!active) begin
          				current_item = i2c_transaction::type_id::create("observed_bus_packet");
          				current_item.start_seen = 1'b1;
          				current_item.stop_seen = 1'b0;
          				current_item.repeated_start_seen = 1'b0;
          				bit_count = 0;
          				shift_byte = '0;
          				active = 1'b1;
          				`uvm_info("I2C_MON", "START detected", UVM_HIGH)
        			end else begin
          				current_item.repeated_start_seen = 1'b1;
          				bit_count = 0;
          				shift_byte = '0;
          				`uvm_info("I2C_MON", "Repeated START detected", UVM_HIGH)
        			end
      			end
    		end
  	endtask
	
  	task capture_bytes_and_ack_slots();
    		logic [7:0] completed_byte;
    		logic ack_bit;
    		forever begin
      			@(posedge vif.scl_line);
      			#1ps;
      			if (active && current_item != null && vif.scl_line === 1'b1) begin
        			if (bit_count < 8) begin
          				shift_byte = {shift_byte[6:0], vif.sda_line};
          				bit_count++;
        			end else begin
          				completed_byte = shift_byte;
          				ack_bit = (vif.sda_line === 1'b1) ? 1'b1 : 1'b0;
          				current_item.byte_stream.push_back(completed_byte);
          				current_item.ack_nack.push_back(ack_bit);
          				bit_count = 0;
          				shift_byte = '0;
        			end
      			end
    		end
  	endtask
	
  	task capture_stop_and_publish();
    		logic [6:0] addr;
    		logic rw;
    		logic nack_seen;
    		int address_count;
    		int payload_count;
    		forever begin
      			@(posedge vif.sda_line);
      			if (active && vif.scl_line === 1'b1) begin
        			#1ps;
        			if (current_item != null) begin
          				current_item.stop_seen = 1'b1;
          				active = 1'b0;
					observed_bus_ap.write(current_item);
          				current_item = null;
          				bit_count = 0;
          				shift_byte = '0;
        			end
      			end
    		end
  	endtask
		  
endclass: i2c_monitor
