`ifndef GUARD_WIS_DEFINE__SV
`define GUARD_WIS_DEFINE__SV

	`ifndef FORK_GUARD_BEGIN
		`define FORK_GUARD_BEGIN fork begin
  	`endif

  	`ifndef FORK_GUARD_END
    		`define FORK_GUARD_END   fork end
  	`endif
  	`ifndef WIS_ADDR_WIDTH
  		`define WIS_ADDR_WIDTH   3 
  	`endif
  	`ifndef AHB_DATA_WIDTH
     		`define WIS_DATA_WIDTH   8 
  	`endif

`endif


