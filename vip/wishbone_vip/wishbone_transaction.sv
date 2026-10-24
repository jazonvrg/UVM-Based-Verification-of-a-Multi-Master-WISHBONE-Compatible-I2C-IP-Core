class wishbone_transaction extends uvm_sequence_item;
	
	typedef enum logic {
		READ = 1'b0,
		WRITE = 1'b1
	} xact_type_enum;

	rand xact_type_enum xact_type;
  	rand logic [2:0]    addr;
  	rand logic [7:0]    wdata;
       	logic [7:0] 	    rdata;
       	logic 		    success = 1'b1;
	
  	`uvm_object_utils_begin(wishbone_transaction)
    		`uvm_field_enum	(xact_type_enum, xact_type, UVM_ALL_ON | UVM_HEX)
    		`uvm_field_int	(addr, 			    UVM_ALL_ON | UVM_HEX)
    		`uvm_field_int	(wdata, 		    UVM_ALL_ON | UVM_HEX)
    		`uvm_field_int	(rdata, 		    UVM_ALL_ON | UVM_HEX)
    		`uvm_field_int	(success, 		    UVM_ALL_ON | UVM_HEX)
  	`uvm_object_utils_end
	
  	function new(string name = "wishbone_transaction");
    		super.new(name);
  	endfunction: new
	
endclass: wishbone_transaction
