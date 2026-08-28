interface wishbone_if();

	logic                       wb_clk_i;     
	logic                       wb_rst_i;     
	logic                       arst_i;     
	logic [`WIS_ADDR_WIDTH-1:0] wb_adr_i;     
	logic [`WIS_DATA_WIDTH-1:0] wb_dat_i;     
	logic [`WIS_DATA_WIDTH-1:0] wb_dat_o;     
	logic                       wb_we_i;     
	logic                       wb_stb_i;     
	logic                       wb_cyc_i;     
	logic                       wb_ack_o;     
	logic                       wb_inta_o;     

endinterface
