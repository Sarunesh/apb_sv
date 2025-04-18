class apb_gen;
	// Properties
	apb_tx tx;
	bit [ADDR_WIDTH-1:0] addr_q[$];

	// Constructor
	function new();
	endfunction

	extern task input_gen(input bit print, input bit wr_rd, input int addr=-1);

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
				input_gen(1,1,-1);
				gen2bfm.put(tx);
			end
		// Scenario-2
			"multi_rand_write_no_wait":begin
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=0;
				repeat(apb_common::count)begin
					tx=new();
					input_gen(1,1,-1);
					gen2bfm.put(tx);
				end
			end
		// Scenario-3
			"cycle_write_no_wait":begin
				apb_common::count=DEPTH;
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=0;
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(1,1,i);
					gen2bfm.put(tx);
				end
			end
		// Scenario-4
			"cycle_write_read_no_wait":begin
				apb_common::count=DEPTH;
				apb_common::gen_count=2*apb_common::count;
				apb_common::testcase_wait=0;
			// Write
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(1,1,i);
					gen2bfm.put(tx);
				end
			// Read
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==0;tx.addr_i==i;tx.wdata_i==0;})
						$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			end
		// Scenario-5
			"multi_rand_write_read_no_wait":begin
				apb_common::gen_count=2*apb_common::count;
				apb_common::testcase_wait=0;
			// Write
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(0,1,-1);
					gen2bfm.put(tx);
					addr_q.push_back(tx.addr_i);
				end
			// Read
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==0;tx.addr_i==addr_q.pop_front();tx.wdata_i==0;})
						$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					void'(addr_q.pop_front());
					//tx.print("GENERATOR");
				end
			end
		// Scenario-6
			"write_wait":begin
				apb_common::gen_count=1;
				apb_common::count=1;
				apb_common::testcase_wait=1;
				tx=new();
				input_gen(1,1,-1);
				gen2bfm.put(tx);
			end
		// Scenario-7
			"multi_rand_write_wait":begin
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=1;
				repeat(apb_common::count)begin
					tx=new();
					input_gen(1,1,-1);
					gen2bfm.put(tx);
				end
			end
		// Scenario-8
			"cycle_write_wait":begin
				apb_common::count=DEPTH;
				apb_common::gen_count=apb_common::count;
				apb_common::testcase_wait=1;
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(1,1,i);
					gen2bfm.put(tx);
				end
			end
		// Scenario-9
			"cycle_write_read_wait":begin
				apb_common::count=DEPTH;
				apb_common::gen_count=2*apb_common::count;
				apb_common::testcase_wait=1;
			// Write
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(1,1,i);
					gen2bfm.put(tx);
				end
			// Read
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==0;tx.addr_i==i;tx.wdata_i==0;})
						$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					//tx.print("GENERATOR");
				end
			end
			// Scenario-10
			"multi_rand_write_read_wait":begin
				apb_common::gen_count=2*apb_common::count;
				apb_common::testcase_wait=1;
			// Write
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					input_gen(0,1,-1);
					gen2bfm.put(tx);
					addr_q.push_back(tx.addr_i);
				end
			// Read
				for(int i=0;i<apb_common::count;i++)begin
					tx=new();
					if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==0;tx.addr_i==addr_q.pop_front();tx.wdata_i==0;})
						$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
					gen2bfm.put(tx);
					void'(addr_q.pop_front());
					//tx.print("GENERATOR");
				end
			end
		endcase
	endtask
endclass

// Write scenario generation task
task apb_gen::input_gen(input bit print, input bit wr_rd, input int addr=-1);
	if(addr==-1)begin
		// Randomized address
		if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==wr_rd;})
			$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
	end
	else begin
		// Cycle address
		if(!tx.randomize() with {tx.trans_i==1;tx.wr_rd_i==wr_rd;tx.addr_i==addr;})
			$error("%0s: Randomization failed at generator at %0t", apb_common::testcase, $time);
	end
	if(print) tx.print("GENERATOR");
endtask
