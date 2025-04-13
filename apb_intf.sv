interface apb_intf(input logic pclk, input logic preset_n);
	logic pready;
	logic pslverr;
	logic [DATA_WIDTH-1:0] prdata;
	logic trans_i;								// From bridge
	logic [ADDR_WIDTH-1:0] addr_i;				// From bridge
	logic [DATA_WIDTH-1:0] wdata_i;				// From bridge
	logic wr_rd_i;								// From bridge

	logic penable;
	logic pselx;
	logic pwrite;
	logic [ADDR_WIDTH-1:0] paddr;
	logic [DATA_WIDTH-1:0] pwdata;
	logic [DATA_WIDTH-1:0] rdata_o;				// To bridge
	logic trans_err_o;							// To bridge

	clocking bfm_cb@(posedge pclk);
		default input #0 output #1;
		output trans_i;
		output addr_i;
		output wdata_i;
		output wr_rd_i;
		output pready;
		input penable;
		input pselx;
		input pwrite;
		input paddr;
		input pwdata;
		input rdata_o;
		input trans_err_o;
	endclocking

	clocking mon_cb@(posedge pclk);
		default input #0;
		input trans_i;
		input addr_i;
		input wdata_i;
		input wr_rd_i;
		input penable;
		input pselx;
		input pwrite;
		input paddr;
		input pwdata;
		input rdata_o;
		input trans_err_o;
// 		input prdata;
		input pready;
// 		input pslverr;
	endclocking
endinterface
