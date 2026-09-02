interface i2c_if();

	logic scl_pad_i;
	logic scl_pad_o;
	logic scl_padoen_o;
	logic sda_pad_i;
	logic sda_pad_o;
	logic sda_padoen_o;

	triand scl;
	triand sda;

	logic drv_scl;
	logic drv_sda;

	assign scl = drv_scl ? 1'bz : scl_pad_o;
	assign sda = drv_sda ? 1'bz : sda_pad_o;

	assign scl = scl_padoen_o ? 1'bz : scl_pad_o;
	assign sda = sda_padoen_o ? 1'bz : sda_pad_o;

	pull(scl, 1'b1);
	pull(sda, 1'b1); 	

endinterface: i2c_if
