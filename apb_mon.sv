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
		$display("### Inside run task of monitor");
		forever begin
			@(posedge vif.pclk);
			if(vif.trans_i && vif.pselx && vif.penable && vif.pready && !sampled)begin
				sample_sig();
				mon2cov.put(tx);
				mon2sbd.put(tx);
				tx.print("MONITOR");
				$display("@@@@ Monitor sampled at %0t", $time);
				sampled=1'b1;
			end
			else if(!vif.trans_i || !vif.pselx || !vif.penable || !vif.pready || sampled)
				sampled=1'b0;
		end
	endtask

	// Sampling task
	task sample_sig();
		tx=new();
		tx.trans_i	<= vif.trans_i;
		tx.addr_i	<= vif.addr_i;
		tx.wr_rd_i	<= vif.wr_rd_i;
		if(vif.wr_rd_i)begin
			tx.wdata_i	<= vif.wdata_i;
			tx.pwdata	<= vif.pwdata;
		end
		else begin
			tx.prdata	<= vif.prdata;
			tx.rdata_o	<= vif.rdata_o;
		end
		tx.penable	<= vif.penable;
		tx.pready	<= vif.pready;
		tx.pslverr	<= vif.pslverr;
		tx.pselx	<= vif.pselx;
		tx.pwrite	<= vif.pwrite;
		tx.paddr	<= vif.paddr;
		tx.trans_err_o	<= vif.trans_err_o;
	endtask
endclass
