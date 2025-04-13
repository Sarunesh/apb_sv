class apb_sbd;
	apb_tx tx;

	// Constructor
	function new();
	endfunction

	// Run task
	task run();
		//$display("### Inside run task of scoreboard");
		forever begin
			tx=new();
			mon2sbd.get(tx);
			tx.print("SCOREBOARD");
			if(tx.pwrite==tx.wr_rd_i && tx.paddr==tx.addr_i && tx.pwdata==tx.wdata_i)
				apb_common::match_count++;
			else
				apb_common::mismatch_count++;
			apb_common::sbd_count++;
		end
	endtask
endclass
