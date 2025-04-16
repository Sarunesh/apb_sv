class apb_mon;
	apb_tx tx;
	bit sampled;

	// Interface instantiation
	virtual apb_intf vif;

	// Constructor
	function new();
		vif=top.pif;
		if(vif==null)
			$fatal("@@@@@ Virtual interface is not connected in Monitor.");
	endfunction

	// Run task
	task run();
		//$display("### Inside run task of monitor");
		forever begin
          @(vif.mon_cb);
			if(vif.mon_cb.trans_i && vif.mon_cb.pselx && vif.mon_cb.penable && vif.pready && !sampled)begin
				sample_sig();
				//$display("=========After checking============= t=%0t pselx=%b penable=%b pready=%b", $time, vif.pselx, vif.penable, vif.pready);
 				//tx.print("MONITOR");
				//mon2cov.put(tx);
				mon2sbd.put(tx);
				$display("@@@@ Monitor sampled at %0t", $time);
				sampled=1'b1;
			end
			else if(!vif.mon_cb.trans_i || !vif.mon_cb.pselx || !vif.mon_cb.penable || !vif.pready || sampled)
				sampled=1'b0;
		end
	endtask

	// Sampling task
	task sample_sig();
		tx=new();
		tx.trans_i	= vif.mon_cb.trans_i;
		tx.addr_i	= vif.mon_cb.addr_i;
		tx.wr_rd_i	= vif.mon_cb.wr_rd_i;
		if(vif.mon_cb.wr_rd_i)begin
			tx.wdata_i	= vif.mon_cb.wdata_i;
		end
		else begin
			wait(vif.mon_cb.pselx && vif.mon_cb.penable && vif.mon_cb.pready);
			#1;
			tx.rdata_o	= vif.mon_cb.rdata_o;
		end
		//tx.penable	= vif.penable;
		//tx.pready	= vif.pready;
		//tx.pslverr	= vif.pslverr;
		//tx.pselx	= vif.pselx;
		//tx.pwrite	= vif.pwrite;
		//tx.paddr	= vif.paddr;
		tx.trans_err_o	= vif.mon_cb.trans_err_o;
				mon2cov.put(tx);
		// Monitor was printing a clock cycle prior to bfm. So, made it print in the next  
		// clock cycle in sync with the bfm.
		@(vif.mon_cb);
      	tx.print("MONITOR");
	endtask
endclass
