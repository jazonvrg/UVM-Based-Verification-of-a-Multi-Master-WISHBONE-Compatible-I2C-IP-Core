class i2c_transaction extends uvm_sequence_item;
	
	typedef enum logic {
		WRITE = 1
		READ  = 0
	} xact_type_enum;

	rand logic [`WIS_ADDR_WIDTH-1:0] addr;
	rand logic [`WIS_DATA_WIDTH-1:0] data;
	xact_type_enum                   xact_type;
	rand logic                       ack;

	`uvm_object_utils_begin (wishbone_transaction)
		`uvm_field_logic (addr                      , UVM_ALL_ON | UVM_HEX)
		`uvm_field_int   (data                      , UVM_ALL_ON | UVM_HEX)
    		`uvm_field_enum  (xact_type_enum , xact_type, UVM_ALL_ON | UVM_STRING)
		`uvm_field_int   (ack                       , UVM_ALL_ON | UVM_HEX)
	`uvm_object_utils_end

	function new(string name = "i2c_transaction");
		super.new(name);
	endfunction: new

endclass: i2c_transaction
