`ifndef WISHBONE_TRANSACTION_SV
`define WISHBONE_TRANSACTION_SV

typedef enum bit { WB_READ = 1'b0, WB_WRITE = 1'b1 } wb_kind_e;

class wishbone_transaction extends uvm_sequence_item;
  rand wb_kind_e kind;
  rand bit [2:0] addr;
  rand bit [7:0] wdata;
       bit [7:0] rdata;
       bit        success = 1'b1;

  `uvm_object_utils_begin(wishbone_transaction)
    `uvm_field_enum(wb_kind_e, kind, UVM_ALL_ON)
    `uvm_field_int(addr, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(wdata, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(rdata, UVM_ALL_ON | UVM_HEX)
    `uvm_field_int(success, UVM_ALL_ON)
  `uvm_object_utils_end

  function new(string name = "wishbone_transaction");
    super.new(name);
  endfunction

  function string convert2string();
    if (kind == WB_WRITE)
      return $sformatf("WB WRITE addr=0x%0h data=0x%02h success=%0b", addr, wdata, success);
    else
      return $sformatf("WB READ addr=0x%0h data=0x%02h success=%0b", addr, rdata, success);
  endfunction
endclass
`endif
