module top;
	// Signals
	logic pclk;
	logic preset_n;

	/*logic penable;
	logic pselx;
	logic pwrite;
	logic paddr;
	logic pwdata;
	logic pready;
	logic pslverr;
	logic prdata;*/

	// Interface instantiation
	apb_intf pif(.pclk(pclk), .preset_n(preset_n));

	// DUT instantiation
	apb #(.ADDR_WIDTH(ADDR_WIDTH), .DATA_WIDTH(DATA_WIDTH)) dut(.pclk		(pif.pclk),
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

	slave_memory #(.ADDR_WIDTH(ADDR_WIDTH),
				.DATA_WIDTH(DATA_WIDTH)) memory(.mem_rdata	(pif.prdata),
												.mem_ready	(pif.pready),
												.mem_slverr	(pif.pslverr),
												.mem_clk	(pif.pclk),
												.mem_rst_n	(pif.preset_n),
												.mem_wr_rd	(pif.pwrite),
												.mem_valid	(pif.penable),
												.mem_selx	(pif.pselx),
												.mem_addr	(pif.paddr),
												.mem_wdata	(pif.pwdata));
	// Environment instantiation
	apb_env env;

	// Clock
	always #5 pclk = ~pclk;
	
	initial begin
		pclk=0; preset_n=0;
		repeat(2)@(posedge pclk);
		preset_n=1;
		$value$plusargs("testcase=%s",apb_common::testcase);
		$value$plusargs("count=%d",apb_common::count);
		env=new();
		env.run();
	end

	// Reports
	initial begin
		#30;
		wait(apb_common::sbd_count == apb_common::gen_count);
		#10;
		if(apb_common::match_count!=apb_common::count && apb_common::mismatch_count!=0)
			$display("***** TEST FAILED: Match count:%0d Mismatch count:%0d", apb_common::match_count, apb_common::mismatch_count);
		else
			$display("***** TEST PASSED: Match count:%0d Mismatch count:%0d", apb_common::match_count, apb_common::mismatch_count);
		#10 $finish;
	end
endmodule
