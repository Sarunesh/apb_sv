class apb_agent;
	apb_gen gen;
	apb_bfm bfm;
	apb_mon mon;
	apb_cov cov;

	// Constructor
	function new();
		gen=new();
		bfm=new();
		mon=new();
		cov=new();
	endfunction

	// Run task
	task run();
		//$display("### Inside run task of agent");
		fork
			gen.run();
			bfm.run();
			mon.run();
			cov.run();
		join
	endtask
endclass

