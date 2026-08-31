module testbench;
	import uvm_pkg::*;
	import i2c_pkg::*;
	import wishbone_pkg::*;
	import test_pkg::*;

	wishbone_if wishbone_vif();
	i2c_if i2c_vif();

	i2c_master_top dut(
		/** Wishbone Interfaces **/
		.wb_clk_i	(wishbone_vif.wb_clk_i),
		.wb_rst_i	(wishbone_vif.wb_rst_i),
		.arst_i		(1'b1),
		.wb_adr_i	(wishbone_vif.wb_adr_i),
		.wb_dat_i	(wishbone_vif.wb_dat_i),
		.wb_we_i	(wishbone_vif.wb_we_i),
		.wb_stb_i	(wishbone_vif.wb_stb_i),
		.wb_cyc_i	(wishbone_vif.wb_cyc_i),
		.wb_ack_o	(wishbone_vif.wb_ack_o),
		.wb_inta_o	(wishbone_vif.wb_inta_o),
		/** I2C Signals **/
		.scl_pad_i	(scl_pad_i),
		.scl_pad_o	(scl_pad_o),
		.scl_pad_oe	(scl_pad_oe),
		.sda_pad_i	(sda_pad_i),
		.sda_pad_o	(sda_pad_o),
		.sda_pad_oe	(sda_pad_oe)
	);

	initial begin
		wishbone_vif.wb_clk_i = 0;
		forever begin
			#5ns;
			wishbone_vif.wb = ~wishbone_vif.wb;
		end
	end

	initial begin
		wishbone_vif.wb_rst_i = 1'b1;
		#10ns;
		wishbone_vif.wb_rst_i = 1'b0;
	end

	initial begin
		uvm_config_db#(virtual wishbone_if)::set(uvm_root::get(), "uvm_test_top", "wishbone_vif", wishbone_vif);
		uvm_config_db#(virtual i2c_if)::set(uvm_root::get(), "uvm_test_top", "i2c_vif", i2c_vif);
		run_test();
	end

endmodule
