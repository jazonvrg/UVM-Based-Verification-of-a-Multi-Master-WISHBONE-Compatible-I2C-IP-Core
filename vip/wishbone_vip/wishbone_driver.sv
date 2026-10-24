`ifndef WISHBONE_DRIVER_SV
`define WISHBONE_DRIVER_SV
class wishbone_driver extends uvm_driver #(wishbone_transaction);
  `uvm_component_utils(wishbone_driver)
  virtual wishbone_if vif;
  int unsigned ack_timeout_cycles = 100;

  function new(string name = "wishbone_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    if (!uvm_config_db#(virtual wishbone_if)::get(this, "", "vif", vif))
      `uvm_fatal(get_type_name(), "virtual wishbone_if was not provided")
  endfunction

  task drive_idle();
    @(negedge vif.wb_clk_i);
    vif.wb_adr_i = '0;
    vif.wb_dat_i = '0;
    vif.wb_we_i  = 1'b0;
    vif.wb_stb_i = 1'b0;
    vif.wb_cyc_i = 1'b0;
  endtask

  task drive_item(wishbone_transaction req, output bit [7:0] read_data, output bit success);
    bit got_ack;
    read_data = '0;
    success = 1'b0;
    got_ack = 1'b0;

    @(negedge vif.wb_clk_i);
    vif.wb_adr_i = req.addr;
    vif.wb_dat_i = (req.kind == WB_WRITE) ? req.wdata : 8'h00;
    vif.wb_we_i  = (req.kind == WB_WRITE);
    vif.wb_stb_i = 1'b1;
    vif.wb_cyc_i = 1'b1;

    for (int unsigned n = 0; n < ack_timeout_cycles; n++) begin
      @(posedge vif.wb_clk_i);
      #1ps;
      if (vif.wb_ack_o === 1'b1) begin
        got_ack = 1'b1;
        success = 1'b1;
        if (req.kind == WB_READ) read_data = vif.wb_dat_o;
        break;
      end
    end

    if (!got_ack)
      `uvm_error("WB_ACK_TIMEOUT", $sformatf("No wb_ack_o within %0d cycles: %s", ack_timeout_cycles, req.convert2string()))

    // Keep the request stable through one more active edge, then deassert at
    // the following falling edge. This matches the two-clock access timing
    // described by the supplied OpenCores specification.
    @(posedge vif.wb_clk_i);
    #1ps;
    @(negedge vif.wb_clk_i);
    vif.wb_adr_i = '0;
    vif.wb_dat_i = '0;
    vif.wb_we_i  = 1'b0;
    vif.wb_stb_i = 1'b0;
    vif.wb_cyc_i = 1'b0;
  endtask

  task run_phase(uvm_phase phase);
    wishbone_transaction req;
    wishbone_transaction rsp;
    bit [7:0] rdata;
    bit success;
    vif.wb_adr_i = '0;
    vif.wb_dat_i = '0;
    vif.wb_we_i = 1'b0;
    vif.wb_stb_i = 1'b0;
    vif.wb_cyc_i = 1'b0;
    forever begin
      seq_item_port.get_next_item(req);
      drive_item(req, rdata, success);
      rsp = wishbone_transaction::type_id::create("rsp");
      rsp.set_id_info(req);
      rsp.kind = req.kind;
      rsp.addr = req.addr;
      rsp.wdata = req.wdata;
      rsp.rdata = rdata;
      rsp.success = success;
      seq_item_port.item_done(rsp);
      `uvm_info("WB_DRV", rsp.convert2string(), UVM_HIGH)
    end
  endtask
endclass
`endif
