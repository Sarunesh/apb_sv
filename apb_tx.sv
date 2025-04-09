class apb_tx;
	rand bit trans_i;							// From bridge
	rand bit [ADDR_WIDTH-1:0] addr_i;			// From bridge
	rand bit [DATA_WIDTH-1:0] wdata_i;			// From bridge
	rand bit wr_rd_i;							// From bridge
	rand bit pready;
		 bit pslverr;
		 bit [DATA_WIDTH-1:0] prdata;
		 bit penable;
		 bit pselx;
		 bit pwrite;
		 bit [ADDR_WIDTH-1:0] paddr;
		 bit [DATA_WIDTH-1:0] pwdata;
		 bit [DATA_WIDTH-1:0] rdata_o;			// To bridge
		 bit trans_err_o;						// To bridge

	function void print(string name="TRANSACTION");
		$display("======================================");
		$display("\tComponent name = %0s", name);
		$display("\ttrans_i=%0b pready=%0b pslverr=%0b", trans_i, pready, pslverr);
		$display("\tpenable=%0b pselx=%0b", penable, pselx);
		$display("\tTransaction type = %0s", wr_rd_i ? ("Write_tx"):("Read_tx"));
		$display("\tAddress: addr_i = 0x%0h paddr = 0x%0h", addr_i, paddr);
		$display("\tWrite data: wdata_i = 0x%0h pwdata = 0x%0h", wdata_i, pwdata);
		$display("\tRead data: rdata_o = 0x%0h prdata = 0x%0h", rdata_o, prdata);
		$display("======================================");
	endfunction
endclass
