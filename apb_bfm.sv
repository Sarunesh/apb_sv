class apb_bfm;
	apb_tx tx;

	// Interface instantiation
	virtual apb_intf vif;

	// Properties
	int delay;

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
		fork
		begin
			if(apb_common::testcase_wait==1)begin
				delay=$urandom_range(5,10);
				vif.pready = 0;
				$display("@@@@@@@@@@ Delay=%0d", delay);
				repeat(delay)begin //Should be greater than 4
					vif.pready=0;
					@(vif.bfm_cb);
				end
				vif.pready = 1;
			end
		end
		begin
			vif.bfm_cb.trans_i	<= tx.trans_i;
			vif.bfm_cb.addr_i	<= tx.addr_i;
			vif.bfm_cb.wr_rd_i	<= tx.wr_rd_i;
			vif.bfm_cb.wdata_i	<= tx.wdata_i;
			@(vif.bfm_cb);

//			$display("=========Before wait============= t=%0t pselx=%b penable=%b pready=%b", $time, vif.pselx, vif.penable, vif.pready);
			wait(vif.bfm_cb.pselx && vif.bfm_cb.penable && vif.bfm_cb.pready);
//      	$display("=======After wait=============== t=%0t pselx=%b penable=%b pready=%b", $time, vif.pselx, vif.penable, vif.pready);
 			//#1;
	// ACCESS Phase
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
			//vif.pready	<= 0;
			end
		join
	endtask
endclass
