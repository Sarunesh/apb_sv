module slave_memory(mem_rdata,mem_ready,mem_slverr,mem_clk,mem_rst_n,mem_wr_rd,mem_valid,mem_selx,mem_addr,mem_wdata);
	parameter DATA_WIDTH=32;
	parameter ADDR_WIDTH=32;
	parameter DEPTH=2**ADDR_WIDTH;

	output reg [DATA_WIDTH-1:0] mem_rdata;	// To prdata
	output reg mem_ready;					// To pready
	output reg mem_slverr;					// To pslverr
	input mem_clk;							// To system clock
	input mem_rst_n;
	input mem_wr_rd;						// To pwrite
	input mem_valid;						// To penable
	input mem_selx;							// To pselx
	input [ADDR_WIDTH-1:0] mem_addr;		// To paddr
	input [DATA_WIDTH-1:0] mem_wdata;		// To pwdata

	reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];	//Memory
	integer i;

	always@(posedge mem_clk)
	begin
		if(!mem_rst_n) begin					//Reset is applied
			mem_rdata=0;
			mem_ready=0;
			mem_slverr=0;
			for(i=0;i<DEPTH;i=i+1) mem[i]=0;
		end
		else begin
			if(mem_selx && mem_valid) begin       		//Valid is issued(Hand-shacking)
				mem_ready=1'b1;        					//Ready to do transaction
				if(mem_wr_rd) mem[mem_addr]=mem_wdata;  //Write operation
				else mem_rdata=mem[mem_addr];           //Read operation
			end
			else begin               					//Valid is not issued
				mem_ready=1'b0;
				mem_rdata=0;
			end
		end
	end
endmodule
