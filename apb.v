// APB master
// Input signals
// 		pclk, presetn, pready, pslverr, prdata
// Output signals
// 		penable, pselx, pwrite, paddr, pwdata
/***********************************************************************/
module apb(pclk, presetn, pready, pslverr, prdata, penable, pselx, pwrite, pwdata, paddr);
	parameter ADDR_WIDTH = 32;
	parameter DATA_WIDTH = 32;

	// Port directions
	input pclk;
	input presetn;
	input pready;
	input pslverr;
	input [DATA_WIDTH-1:0] prdata;
	output reg penable;
	output reg pselx;
	output reg pwrite;
	output reg [ADDR_WIDTH-1:0] paddr;
	output reg [DATA_WIDTH-1:0] pwdata;

	// States
	typedef enum bit[1:0]{
		IDLE,
		SETUP,
		ACCESS,
		RESERVED
	}state_t;

	// Enum types
	state_t cur_state, next_state;

	// Reset logic
	always@(posedge pclk)begin							// Synchronous
		if(!presetn)begin								// Active low reset
			penable	<= 0;
			pselx	<= 0;
			paddr	<= 32'b0;
			pwdata	<= 32'b0;
			cur_state <= IDLE;
		end
		else begin
			cur_state <= next_state;
		end
	end

	// Next state logic
	always@(posedge clk)begin
		if(presetn)begin
			case(cur_state)
				IDLE:begin
					pselx <= 1'b0;
					penable <= 1'b0;
					if(trans) next_state <= SETUP;
					else next_state <= IDLE;
				end
				SETUP:begin
					pselx		<= 1'b1;
					penable		<= 1'b0;
					next_state	<= ACCESS;
				end
				ACCESS:begin
					penable<=1'b1;
				end
				default:begin
				end
			endcase
		end
	end
endmodule
