class apb_gen;
	apb_tx tx;

	// Constructor
	function new();
	endfunction

	// Run task
	task run();
		$display("### Inside run task of generator");
		case(apb_common::testcase)
		// Scenario-1
			"write_no_wait":begin
				apb_common::gen_count=1;
				tx=new();
				if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;})
					$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
				apb_common::testcase_wait=0;
				gen2bfm.put(tx);
				//tx.print("GENERATOR");
			end
		// Scenario-2
			"write_wait":begin
				apb_common::gen_count=1;
				tx=new();
				if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==0;})
					$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
				apb_common::testcase_wait=1;
				gen2bfm.put(tx);
				//tx.print("GENERATOR");
			end
		endcase
	endtask
endclass
