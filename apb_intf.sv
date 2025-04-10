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
endinterface
