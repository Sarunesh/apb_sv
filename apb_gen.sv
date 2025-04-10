class apb_gen;
	apb_tx tx;

	// Constructor
	function new();
	endfunction

	// Run task
	task run();
		$display("### Inside run task of generator");
		case(apb_common::testcase)
			"write_no_wait":begin
				tx=new();
				if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;})
					$display("Randomization failed at generator at %0t", $time);
				apb_common::testcase_wait=0;
				gen2bfm.put(tx);
				tx.print("GENERATOR");
			end
		endcase
	endtask
endclass
