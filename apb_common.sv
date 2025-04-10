parameter ADDR_WIDTH = 32;
parameter DATA_WIDTH = 32;

// Mailbox
mailbox gen2bfm=new();
mailbox mon2cov=new();
mailbox mon2sbd=new();

class apb_common;
	static string testcase;
	static bit testcase_wait;
	static int gen_count, bfm_count;
endclass
