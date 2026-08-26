class register_reserved_test extends uart_base_test;
	`uvm_component_utils(register_reserved_test)
	
	write_register_reserved_sequence write_reserved_seq;
	read_register_reserved_sequence read_reserved_seq;
	uvm_status_e status;
	logic [`AHB_DATA_WIDTH-1:0] rdata;

	function new(string name = "register_reserved_test", uvm_component parent);
		super.new(name, parent);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction: build_phase

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		reset();
		write_reserved_seq = write_register_reserved_sequence::type_id::create("write_reserved_seq");
		read_reserved_seq = read_register_reserved_sequence::type_id::create("read_reserved_seq");
		$display("============================================================================================================================");
		$display("==========================================  ### ERROR HANDLING | RESERVED  ###  ============================================");
		$display("============================================================================================================================");
		// WRITE ON RESERVED
		for(int i = 10'h020; i <= 10'h3FF; i = i + 4) begin
			write_reserved_seq.address = i;
			write_reserved_seq.start(env.ahb_agt.seq);
		end
		// READ ON RESERVED  |  RDATA = 32'hFFFF_FFFF
		for(int i = 10'h020; i <= 10'h3FF; i = i + 4) begin
			read_reserved_seq.address = i;
			read_reserved_seq.start(env.ahb_agt.seq);
		end
		#500ns;	
		phase.drop_objection(this);
	endtask: run_phase

endclass
