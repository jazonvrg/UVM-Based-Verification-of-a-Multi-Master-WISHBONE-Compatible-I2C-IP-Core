`ifndef WISHBONE_AGENT_SV
`define WISHBONE_AGENT_SV
class wishbone_agent extends uvm_agent;
  `uvm_component_utils(wishbone_agent)
  virtual wishbone_if vif;
  wishbone_sequencer seqr;
  wishbone_driver drv;
  wishbone_monitor mon;

  function new(string name = "wishbone_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual wishbone_if was not provided")
    mon = wishbone_monitor::type_id::create("mon", this);
    uvm_config_db#(virtual wishbone_if)::set(this, "mon", "vif", vif);
    if (is_active == UVM_ACTIVE) begin
      seqr = wishbone_sequencer::type_id::create("seqr", this);
      drv = wishbone_driver::type_id::create("drv", this);
      uvm_config_db#(virtual wishbone_if)::set(this, "drv", "vif", vif);
    end
  endfunction

  function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    if (is_active == UVM_ACTIVE)
      drv.seq_item_port.connect(seqr.seq_item_export);
  endfunction
endclass
`endif
