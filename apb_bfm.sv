class apb_bfm;
	apb_tx tx;

	// Interface instantiation
	virtual apb_intf vif;

	// Constructor
	function new();
		vif=top.pif;
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
		end
	endtask

	// drive tasks
	task drive_no_wait(ref apb_tx tx);
		$display("Inside drive_no_wait task in bfm");
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
		$display("Inside drive_wait task in bfm");
	endtask
endclass
