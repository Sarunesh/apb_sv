// #### APB master ####
// Input signals
// 		pclk, preset_n, pready, pslverr, prdata
// Output signals
// 		penable, pselx, pwrite, paddr, pwdata
// #### Signals from/to bridge ####
// Input signals
// 		trans_i, addr_i, wdata_i, wr_rd_i
// Output signals
// 		rdata_o, trans_err_o
/***********************************************************************/
module apb(pclk, preset_n, pready, pslverr, prdata, trans_i, addr_i, wdata_i, wr_rd_i, penable, pselx, pwrite, pwdata, paddr, rdata_o, trans_err_o);
	parameter ADDR_WIDTH = 32;
	parameter DATA_WIDTH = 32;

	// Port directions
	input pclk;
	input preset_n;
	input pready;								// From peripheral
	input pslverr;								// From peripheral
	input [DATA_WIDTH-1:0] prdata;				// From peripheral
	input trans_i;								// From bridge
	input [ADDR_WIDTH-1:0] addr_i;				// From bridge
	input [DATA_WIDTH-1:0] wdata_i;				// From bridge
	input wr_rd_i;								// From bridge
	output reg penable;
	output reg pselx;
	output reg pwrite;
	output reg [ADDR_WIDTH-1:0] paddr;
	output reg [DATA_WIDTH-1:0] pwdata;
	output reg [DATA_WIDTH-1:0] rdata_o;		// To bridge
	output reg trans_err_o;						// To bridge

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
		if(!preset_n)begin								// Active low reset
			penable	<= 1'b0;
			pselx	<= 1'b0;
			paddr	<= 32'b0;
			pwdata	<= 32'b0;
			rdata_o <= 32'b0;
			trans_err_o <= 1'b0;
			cur_state <= IDLE;
		end
		else begin
			cur_state <= next_state;
		end
	end

	// Next state logic
	always@(*)begin
		case(cur_state)
			IDLE:begin
				if(trans_i) next_state <= SETUP;
				else next_state <= IDLE;
			end
			SETUP:begin
				next_state	<= ACCESS;
			end
			ACCESS:begin
				if(pready)begin							// Transfer happens
					if(trans_i) next_state <= SETUP;		// Subsequent transfers
					else next_state <= IDLE;			// No more transfers
				end
				else begin
					next_state <= ACCESS;
				end
			end
			default:begin
				next_state <= IDLE;
			end
		endcase
	end

	// Output logic
	always@(posedge pclk)begin
		if(preset_n)begin
			case(cur_state)
				IDLE:begin
					pselx	<= 1'b0;
					penable	<= 1'b0;
				end
				SETUP:begin
					pselx	<= 1'b1;
					penable	<= 1'b0;
					pwrite	<= wr_rd_i;
					paddr	<= addr_i;
					if(wr_rd_i) pwdata <= wdata_i;		// Write to peripheral
				end
				ACCESS:begin
					penable = 1'b1;
					if(pready && penable)begin			// pready & penable are HIGH
						rdata_o <= prdata;				// Read from peripheral
						trans_err_o <= pslverr;			// Driving the output error signal
														// with pslverr
					end
				end
				default:begin
					pselx	<= 1'b0;
					penable	<= 1'b0;
				end
			endcase
		end
	end
endmodule
