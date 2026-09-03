interface i2c_if();

	logic scl_pad_i;
	logic scl_pad_o;
	logic scl_padoen_o;
	logic sda_pad_i;
	logic sda_pad_o;
	logic sda_padoen_o;

	triand scl;
	triand sda;

	logic drv_scl = 1'b1;
	logic drv_sda = 1'b1;

	assign scl = (scl_padoen_o === 1'b0) ? scl_pad_o : 1'bz
	assign sda = (sda_padoen_o === 1'b0) ? sda_pad_o : 1'bz;

	assign scl = (drv_scl === 1'b0) ? 1'b0 : 1'bz;
	assign sda = (drv_sda === 1'b0) ? 1'b0 : 1'bz;

	assign scl_pad_i = scl;
	assign sda_pad_i = sda;

	pull(scl);
	pull(sda); 	

endinterface: i2c_if
