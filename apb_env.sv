class apb_env;
	// Agent and SBD instantiation
	apb_agent agent;
	apb_sbd sbd;

	// Constructor
	function new();
		agent=new();
		sbd=new();
	endfunction

	// Run task
	task run();
		$display("### Inside run task of environment");
		fork
			agent.run();
			sbd.run();
		join
	endtask
endclass
