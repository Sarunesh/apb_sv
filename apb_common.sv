parameter ADDR_WIDTH = 8;
parameter DATA_WIDTH = 8;
parameter DEPTH = 1<<ADDR_WIDTH;
parameter DATA_VALUES = DEPTH-1;

// Mailbox
mailbox gen2bfm=new();
mailbox mon2cov=new();
mailbox mon2sbd=new();

class apb_common;
	static string testcase;
	static bit testcase_wait;
	static int gen_count, sbd_count;
	static int match_count, mismatch_count;
	static int count;
endclass
