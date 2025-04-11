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
			drive(tx);
		end
	endtask

	// drive task
	task drive(apb_tx tx);
		$display("#### Inside drive task in bfm");
		@(posedge vif.pclk);
	// SETUP Phase
		vif.trans_i	<= tx.trans_i;
		vif.addr_i	<= tx.addr_i;
		vif.wr_rd_i	<= tx.wr_rd_i;
		vif.wdata_i	<= tx.wdata_i;
		vif.pready	<= tx.pready;
		@(posedge vif.pclk);
		if(apb_common::testcase_wait==1)begin
			fork
				begin: PREADY_ASSERT				// Process-1
					repeat(2)@(posedge vif.pclk);	// Maintains pready=0 for 2 clock cycles
					tx.pready = 1'b1;				// To exit from the wait state
				end
				begin: PREADY_WAIT					// Process-2
					wait(tx.pready==1);
					vif.pready	= tx.pready;
				end
			join
		end

		wait(vif.pselx && vif.penable && vif.pready);
		#1;
	// ACCESS Phase
		tx.pselx	= vif.pselx;
		tx.penable	= vif.penable;
		tx.pwrite	= vif.pwrite;
		tx.paddr	= vif.paddr;
		tx.pwdata	= vif.pwdata;
		tx.trans_err_o = vif.trans_err_o;
		tx.rdata_o	= vif.rdata_o;
	// Printing at the end of the ACCESS phase
		tx.print("BFM");

	// Drive outputs as 0
		@(posedge vif.pclk);
		vif.trans_i	<= 0;
		vif.addr_i	<= 0;
		vif.wr_rd_i	<= 0;
		vif.wdata_i	<= 0;
		vif.pready	<= 0;
	endtask
endclass
