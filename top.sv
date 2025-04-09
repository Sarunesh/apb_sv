module top;
	// Signals
	logic pclk;
	logic preset_n;

	// Interface instantiation
	apb_intf pif(.pclk(pclk), .preset_n(preset_n));

	// DUT instantiation
	apb dut(.pclk		(pif.pclk),
			.preset_n	(pif.preset_n),
			.pready		(pif.pready),
			.pslverr	(pif.pslverr),
			.prdata		(pif.prdata),
			.trans_i	(pif.trans_i),
			.addr_i		(pif.addr_i),
			.wdata_i	(pif.wdata_i),
			.wr_rd_i	(pif.wr_rd_i),
			.penable	(pif.penable),
			.pselx		(pif.pselx),
			.pwrite		(pif.pwrite),
			.pwdata		(pif.pwdata),
			.paddr		(pif.paddr),
			.rdata_o	(pif.rdata_o),
			.trans_err_o(pif.trans_err_o));

	// Environment instantiation
	apb_env env;

	// Clock
	always #5 pclk = ~pclk;
	
	initial begin
		pclk=0; preset_n=0;
		repeat(2)@(posedge pclk);
		preset_n=1;
		env=new();
		env.run();
		#2000 $finish;
	end

	// Reports
endmodule
