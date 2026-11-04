class i2c_transaction extends uvm_sequence_item;
	`uvm_object_utils(i2c_transaction)
	
  logic start_seen;
  logic stop_seen;
  logic repeated_start_seen;
  logic [7:0] byte_stream[$];
  logic ack_nack[$];
	
  function new(string name = "i2c_bus_item");
	  super.new(name);
  endfunction

  function void do_copy(uvm_object rhs);
    i2c_bus_item r;
    if (!$cast(r, rhs)) `uvm_fatal("I2C_COPY", "do_copy type mismatch")
    super.do_copy(rhs);
    start_seen = r.start_seen;
    stop_seen = r.stop_seen;
    repeated_start_seen = r.repeated_start_seen;
    byte_stream.delete();
    ack_nack.delete();
    foreach (r.byte_stream[i]) byte_stream.push_back(r.byte_stream[i]);
    foreach (r.ack_nack[i]) ack_nack.push_back(r.ack_nack[i]);
  endfunction
	
endclass
