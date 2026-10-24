`ifndef WISHBONE_IF_SV
`define WISHBONE_IF_SV
interface wishbone_if;
  timeunit 1ns;
  timeprecision 1ps;
  logic        wb_clk_i;
  logic        wb_rst_i;
  logic [2:0]  wb_adr_i;
  logic [7:0]  wb_dat_i;
  wire  [7:0]  wb_dat_o;
  logic        wb_we_i;
  logic        wb_stb_i;
  logic        wb_cyc_i;
  wire         wb_ack_o;
  wire         wb_inta_o;
endinterface
`endif
