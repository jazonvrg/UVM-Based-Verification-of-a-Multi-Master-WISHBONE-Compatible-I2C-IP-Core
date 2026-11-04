class i2c_transaction extends uvm_sequence_item;
	`uvm_object_utils(i2c_transaction)
		
  	logic start_seen;
  	logic stop_seen;
  	logic repeated_start_seen;
  	logic [7:0] byte_stream[$];
  	logic ack_nack[$];
	
  	function new(string name = "i2c_bus_item");
		super.new(name);
  	endfunction: new
	
  	function void do_copy(uvm_object rhs);
    		i2c_bus_item r;
    		if (!$cast(r, rhs)) begin
			 `uvm_fatal("i2c_copy", "do_copy type mismatch")
		end
    		super.do_copy(rhs);
    		start_seen = r.start_seen;
    		stop_seen = r.stop_seen;
    		repeated_start_seen = r.repeated_start_seen;
    		byte_stream.delete();
    		ack_nack.delete();
    		foreach (r.byte_stream[i]) begin
			byte_stream.push_back(r.byte_stream[i]);
		end
    		foreach (r.ack_nack[i]) begin
			ack_nack.push_back(r.ack_nack[i]);
		end
  	endfunction
	
endclass: i2c_transaction
