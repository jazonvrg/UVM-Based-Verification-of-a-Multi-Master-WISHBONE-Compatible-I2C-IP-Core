interface i2c_if;
	
  	wire scl_pad_i;
  	wire sda_pad_i;
  	wire scl_pad_o;
  	wire scl_padoen_o;
  	wire sda_pad_o;
  	wire sda_padoen_o;
	
  	tri1 scl_line;
  	tri1 sda_line;
	
  	assign scl_line = scl_padoen_o ? 1'bz : scl_pad_o;
  	assign sda_line = sda_padoen_o ? 1'bz : sda_pad_o;
  	assign scl_pad_i = scl_line;
  	assign sda_pad_i = sda_line;
	
endinterface: i2c_if
