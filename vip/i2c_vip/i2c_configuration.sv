class i2c_configuration extends uvm_object;

	typedef enum logic {
		MASTER = 1'b0,
		SLAVE  = 1'b1
	} mode_enum;

	rand mode_enum mode;
	rand logic [6:0] addr;
 	rand logic [7:0] data;
	
	`uvm_object_utils_begin (i2c_configuration)
		`uvm_field_enum (mode_enum ,mode, UVM_ALL_ON | UVM_STRING)
		`uvm_field_int  (addr,            UVM_ALL_ON | UVM_DEC)
		`uvm_field_int  (data,            UVM_ALL_ON | UVM_DEC)
	`uvm_object_utils_end

	function new(string name = "i2c_configuration");
		super.new(name);
	endfunction: new

endclass: i2c_configuration
