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
			if(vif.mon_cb.trans_i && vif.mon_cb.pselx && vif.mon_cb.penable && vif.mon_cb.pready && !sampled)begin
				sample_sig();
				mon2cov.put(tx);
				mon2sbd.put(tx);
// 				tx.print("MONITOR");
				$display("@@@@ Monitor sampled at %0t", $time);
				sampled=1'b1;
			end
			else if(!vif.mon_cb.trans_i || !vif.mon_cb.pselx || !vif.mon_cb.penable || !vif.mon_cb.pready || sampled)
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
			tx.pwdata	= vif.mon_cb.pwdata;
		end
		else begin
			tx.prdata	= vif.prdata;
			tx.rdata_o	= vif.mon_cb.rdata_o;
		end
		tx.penable	= vif.mon_cb.penable;
		tx.pready	= vif.mon_cb.pready;
		tx.pslverr	= vif.pslverr;
		tx.pselx	= vif.mon_cb.pselx;
		tx.pwrite	= vif.mon_cb.pwrite;
		tx.paddr	= vif.mon_cb.paddr;
		tx.trans_err_o	= vif.mon_cb.trans_err_o;
      	tx.print("MONITOR");
	endtask
endclass
