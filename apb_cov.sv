class apb_cov;
	apb_tx tx;

	covergroup apb_br_cg;
		TRANS_CP:coverpoint tx.trans_i{
			bins TRANS_HIGH={1'b1};
			bins TRANS_LOW={1'b0};
		}
		WR_RD_CP:coverpoint tx.wr_rd_i{
			bins WR_RD_HIGH={1'b1};
			bins WR_RD_LOW={1'b0};
		}
		ADDR_CP:coverpoint tx.addr_i{
			option.auto_bin_max=ADDR_WIDTH;
		}
		WDATA_CP:coverpoint tx.wdata_i{
			option.auto_bin_max=DATA_WIDTH;
		}
		RDATA_CP:coverpoint tx.rdata_o{
			option.auto_bin_max=DATA_WIDTH;
		}
		TRANS_ERR_CP:coverpoint tx.trans_err_o{
			bins TRANS_ERR_HIGH={1'b1};
			bins TRANS_ERR_LOW={1'b0};
		}
		WR_RD_X_WDATA:cross WR_RD_CP, WDATA_CP;
		WR_RD_X_RDATA:cross WR_RD_CP, RDATA_CP;
		ADDR_X_WDATA:cross ADDR_CP, WDATA_CP;
		ADDR_X_RDATA:cross ADDR_CP, RDATA_CP;
	endgroup

	covergroup apb_sl_cg;
		PSELX_CP:coverpoint tx.pselx{
			bins PSELX_HIGH={1'b1};
			bins PSELX_LOW={1'b0};
		}
		PENABLE_CP:coverpoint tx.penable{
			bins PENABLE_HIGH={1'b1};
			bins PENABLE_LOW={1'b0};
		}
		PREADY_CP:coverpoint tx.pready{
			bins PREADY_HIGH={1'b1};
			bins PREADY_LOW={1'b0};
		}
		PADDR_CP:coverpoint tx.paddr{
			option.auto_bin_max=ADDR_WIDTH;
		}
		PWRITE_CP:coverpoint tx.pwrite{
			bins PWRITE_HIGH={1'b1};
			bins PWRITE_LOW={1'b0};
		}
		PWDATA_CP:coverpoint tx.pwdata{
			option.auto_bin_max=DATA_WIDTH;
		}
		PRDATA_CP:coverpoint tx.prdata{
			option.auto_bin_max=DATA_WIDTH;
		}
		PSLVERR_CP:coverpoint tx.pslverr{
			bins PSLVERR_HIGH={1'b1};
			bins PSLVERR_LOW={1'b0};
		}
		//ILLEGAL_CP:coverpoint {tx.pselx,tx.penable}{
		//	illegal_bins ILLEGAL={2'b10};
		//}
		PWRITE_X_PWDATA:cross PWRITE_CP, PWDATA_CP;
		PWRITE_X_PRDATA:cross PWRITE_CP, PRDATA_CP;
		PADDR_X_PWDATA:cross PADDR_CP, PWDATA_CP;
		PADDR_X_PRDATA:cross PADDR_CP, PRDATA_CP;
		PSLVERR_X_PENABLE_X_PREADY:cross PSLVERR_CP, PENABLE_CP, PREADY_CP;
	endgroup

	// Constructor
	function new();
		tx=new();
		apb_br_cg=new();
		apb_sl_cg=new();
	endfunction

	// Run task
	task run();
		$display("### Inside run task of coverage");
		forever begin
			mon2cov.get(tx);
			fork
				apb_br_cg.sample();
				apb_sl_cg.sample();
			join
		end
	endtask
endclass
