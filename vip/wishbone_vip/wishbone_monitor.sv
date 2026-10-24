`ifndef WISHBONE_MONITOR_SV
`define WISHBONE_MONITOR_SV
class wishbone_monitor extends uvm_monitor;
  `uvm_component_utils(wishbone_monitor)
  virtual wishbone_if vif;
  uvm_analysis_port #(wishbone_transaction) observed_ap;
  bit request_seen;

  function new(string name = "wishbone_monitor", uvm_component parent = null);
    super.new(name, parent);
    observed_ap = new("observed_ap", this);
    request_seen = 0;
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual wishbone_if was not provided")
  endfunction

  task run_phase(uvm_phase phase);
    wishbone_transaction tr;
    forever begin
      @(posedge vif.wb_clk_i);
      #1ps; // sample registered ACK/data after the NBA update
      if (!(vif.wb_cyc_i && vif.wb_stb_i)) request_seen = 0;
      if ((vif.wb_cyc_i === 1'b1) && (vif.wb_stb_i === 1'b1) &&
          (vif.wb_ack_o === 1'b1) && !request_seen) begin
        request_seen = 1;
        tr = wishbone_transaction::type_id::create("observed_wb_transaction", this);
        tr.kind = vif.wb_we_i ? WB_WRITE : WB_READ;
        tr.addr = vif.wb_adr_i;
        tr.wdata = vif.wb_dat_i;
        tr.rdata = vif.wb_dat_o;
        tr.success = 1'b1;
        observed_ap.write(tr);
        `uvm_info("WB_MON", tr.convert2string(), UVM_HIGH)
      end
    end
  endtask
endclass
`endif
