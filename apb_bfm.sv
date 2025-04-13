class apb_bfm;
	apb_tx tx;

	// Interface instantiation
	virtual apb_intf vif;

	// Constructor
	function new();
		vif=top.pif;
		if(vif==null)
			$fatal("@@@@@ Virtual interface is not connected in BFM.");
	endfunction

	// Run task
	task run();
		//$display("### Inside run task of bfm");
		forever begin
			tx=new();
			gen2bfm.get(tx);
			drive(tx);
		end
	endtask

	// drive task
	task drive(apb_tx tx);
		//$display("#### Inside drive task in bfm");
		@(vif.bfm_cb);
	// SETUP Phase
		vif.bfm_cb.trans_i	<= tx.trans_i;
		vif.bfm_cb.addr_i	<= tx.addr_i;
		vif.bfm_cb.wr_rd_i	<= tx.wr_rd_i;
		vif.bfm_cb.wdata_i	<= tx.wdata_i;
		vif.bfm_cb.pready	<= tx.pready;
		@(vif.bfm_cb);
		if(apb_common::testcase_wait==1)begin
			fork
				begin: PREADY_ASSERT				// Process-1
					repeat(2)@(vif.bfm_cb);	// Maintains pready=0 for 2 clock cycles
					tx.pready = 1'b1;				// To exit from the wait state
				end
				begin: PREADY_WAIT					// Process-2
					wait(tx.pready==1);
					vif.bfm_cb.pready	<= tx.pready;
				end
			join
		end

		wait(vif.bfm_cb.pselx && vif.bfm_cb.penable && vif.bfm_cb.pready);
// 		#1;
	// ACCESS Phase
		tx.pselx	= vif.bfm_cb.pselx;
		tx.penable	= vif.bfm_cb.penable;
		tx.pwrite	= vif.bfm_cb.pwrite;
		tx.paddr	= vif.bfm_cb.paddr;
		tx.pwdata	= vif.bfm_cb.pwdata;
		tx.trans_err_o = vif.bfm_cb.trans_err_o;
		tx.rdata_o	= vif.bfm_cb.rdata_o;
	// Printing at the end of the ACCESS phase
		tx.print("BFM");

	// Drive outputs as 0
		@(vif.bfm_cb);
		vif.bfm_cb.trans_i	<= 0;
		vif.bfm_cb.addr_i	<= 0;
		vif.bfm_cb.wr_rd_i	<= 0;
		vif.bfm_cb.wdata_i	<= 0;
		vif.bfm_cb.pready	<= 0;
	endtask
endclass
