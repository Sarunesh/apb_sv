class apb_mon;
	apb_tx tx;

	// Interface instantiation
	virtual apb_intf vif;

	// Constructor
	function new();
		vif=top.pif;
	endfunction

	// Run task
	task run();
		$display("### Inside run task of monitor");
	endtask
endclass
