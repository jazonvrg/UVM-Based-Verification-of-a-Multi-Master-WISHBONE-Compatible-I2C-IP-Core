class wishbone_transaction extends uvm_object;
	`uvm_utils_component(wishbone_transcation)

	typedef enum logic {
		READ  : 1'b0,
		WRITE : 1'b1
	} xact_type_enum;

	logic [`WIS_ADDR_WIDTH-1:0] addr;
	logic [`WIS_DATA_WIDTH-1:0] data;
	xact_type_enum              xact_type;

	`uvm_object_utils_begin (wishbone_transaction)
		`uvm_field_logic (addr),
		`uvm_field_logic (data),
		`uvm_field_enum (xact_type_enum, xact_type);
	`uvm_object_utils_end

endclass: wishbone_transaction
