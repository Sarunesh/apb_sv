class apb_tx;
	rand bit trans_i;							// By tb to dut
	rand bit [ADDR_WIDTH-1:0] addr_i;			// By tb to dut
	rand bit [DATA_WIDTH-1:0] wdata_i;			// By tb to dut
	rand bit wr_rd_i;							// By tb to dut
	//rand bit pready;							// By peripheral to dut
	//	 bit pslverr;							// By peripheral to dut
	//	 bit [DATA_WIDTH-1:0] prdata;			// By peripheral to dut
	//	 bit penable;							// By dut
	//	 bit pselx;								// By dut
	//	 bit pwrite;							// By dut
	//	 bit [ADDR_WIDTH-1:0] paddr;			// By dut
	//	 bit [DATA_WIDTH-1:0] pwdata;			// By dut
		 bit [DATA_WIDTH-1:0] rdata_o;			// To tb
		 bit trans_err_o;						// To tb

	constraint addr_i_c{
		addr_i inside {[0:(DEPTH-1)]};
	}

	function void print(string name="TRANSACTION");
		$display("==============================================");
		$display("\tComponent name = %0s Time=%0t", name, $time);
		$display("\ttrans_i=%0b", trans_i);
		$display("\tTransaction type = %0s", wr_rd_i ? ("Write_tx"):("Read_tx"));
		$display("\tAddress: addr_i = 0x%0h", addr_i);
		$display("\tWrite data: wdata_i = 0x%0h", wdata_i);
		$display("\tRead data: rdata_o = 0x%0h", rdata_o);
		$display("==============================================");
	endfunction
endclass
