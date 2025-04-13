class apb_gen;
	apb_tx tx;

	// Constructor
	function new();
	endfunction

	// Run task
	task run();
		//$display("### Inside run task of generator");
		case(apb_common::testcase)
		// Scenario-1
			"write_no_wait":begin
				apb_common::gen_count=1;
				apb_common::count=1;
				apb_common::testcase_wait=0;
				tx=new();
				if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;})
					$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
				gen2bfm.put(tx);
				//tx.print("GENERATOR");
			end
		// Scenario-2
			"write_wait":begin
				apb_common::gen_count=1;
				apb_common::count=1;
				apb_common::testcase_wait=1;
				tx=new();
				if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==0;})
					$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
				gen2bfm.put(tx);
				//tx.print("GENERATOR");
			end
		// Scenario-3
			"multi_rand_write_no_wait":begin
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=0;
				repeat(apb_common::count)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;})
						$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			end
		// Scenario-4
			"cycle_write_no_wait":begin
				apb_common::count=2**ADDR_WIDTH;
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=0;
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;tx.addr_i==i;})
						$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			end
		// Scenario-5
			"cycle_write_read_no_wait":begin
				apb_common::count=2**ADDR_WIDTH;
				apb_common::gen_count=2*apb_common::count;
				apb_common::testcase_wait=0;
			// Write
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==1;tx.pready==1;tx.addr_i==i;})
						$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			// Read
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==0;tx.pready==1;tx.addr_i==i;tx.wdata_i==0;})
						$display("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			end
		endcase
	endtask
endclass
