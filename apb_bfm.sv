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
		$display("### Inside run task of bfm");
		forever begin
			tx=new();
			gen2bfm.get(tx);
			if(apb_common::testcase_wait==1)
				drive_wait(tx);
			else
				drive_no_wait(tx);
			tx.print("BFM");
			apb_common::bfm_count++;
		end
	endtask

	// drive tasks
	task drive_no_wait(ref apb_tx tx);
		$display("#### Inside drive_no_wait task in bfm");
		@(posedge vif.pclk);
		vif.trans_i	<= tx.trans_i;			// SP
		vif.addr_i	<= tx.addr_i;			// SP
		vif.wr_rd_i	<= tx.wr_rd_i;			// SP
		vif.wdata_i	<= tx.wdata_i;			// SP
		vif.pready	<= tx.pready;
		@(posedge vif.pclk);
		tx.pselx	= vif.pselx;			// AP; towards peripheral
		tx.penable	= vif.penable;			// AP; towards peripheral
		tx.pwrite	= vif.pwrite;			// AP; towards peripheral
		tx.paddr	= vif.paddr;			// AP; towards peripheral
		tx.pwdata	= vif.pwdata;			// AP; towards peripheral
		tx.trans_err_o = vif.trans_err_o;	// AP; towards peripheral
		tx.rdata_o	= vif.rdata_o;
	endtask

	task drive_wait(ref apb_tx tx);
		$display("#### Inside drive_wait task in bfm");
		@(posedge vif.pclk);
		vif.trans_i	<= tx.trans_i;			// SP
		vif.addr_i	<= tx.addr_i;			// SP
		vif.wr_rd_i	<= tx.wr_rd_i;			// SP
		vif.wdata_i	<= tx.wdata_i;			// SP
		vif.pready	<= tx.pready;
		@(posedge vif.pclk);
		fork
			begin: PREADY_ASSERT					// Process-1
				repeat(2)@(posedge vif.pclk);		// Maintains pready=0 for 2 clock cycles
				tx.pready = 1'b1;					// To exit from the wait state
			end
			begin: PREADY_WAIT						// Process-2
				wait(tx.pready==1);
				vif.pready	= tx.pready;
				tx.pselx	= vif.pselx;			// AP; towards peripheral
				tx.penable	= vif.penable;			// AP; towards peripheral
				tx.pwrite	= vif.pwrite;			// AP; towards peripheral
				tx.paddr	= vif.paddr;			// AP; towards peripheral
				tx.pwdata	= vif.pwdata;			// AP; towards peripheral
				tx.trans_err_o = vif.trans_err_o;	// AP; towards peripheral
				tx.rdata_o	= vif.rdata_o;
			end
		join
	endtask
endclass
