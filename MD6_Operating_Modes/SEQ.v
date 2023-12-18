`include "parameters.vh"

module SEQ
#(
	parameter 	l 	 = 8'h01
 )
(
  input  wire 			     		clk, 
  input  wire				 		reset,
  input  wire 				 		enable,
  input  wire  [1:0]				index_padd,
  input  wire  [7:0]   		 		L,  			// Max level 
  input	 wire  [11:0] 		 		r,  			// Nnumber of rounds. max default is 168 (40+512/4)  | need to add min 80 value
  input	 wire  [11:0] 		 		d,  			// Length of desired hash. 224|256|384|512
  input  wire  [`wi*(64*`w)-1:0]    M_l,			// Current message 
  input  wire  [11:0]        		padding_zero_M,
  input  wire  [8*`w-1:0]    		K,  			// Key
  input  wire  [7:0]         		keylen,
  output reg   [`c*`w-1:0]   		C  				// Current hash
	
);
	reg 				  start;
	reg    	[55:0]		  index;
	reg   	[3:0]  		  z_end;   				// End indicator
	reg   	[3:0]  		  z_end_i;
	reg 	[1:0]		  state;	
	
	reg    [64*`w-1:0]    M_i;
	wire   [`c*`w-1:0]    C_i;
	wire 			  	  done;

		
	always@ (posedge clk)
		begin 
			if (reset)
			begin
				start <= 0;
				z_end <= 0;
				state <= 0;
				index <= 0;
			end
			else 
			begin
				case (state)
					0:
					begin
						if (enable)
						begin
							M_i <= {M_l[index*(48*`w)+:48*`w],`IV};
							if (M_l<2**(48*`w-1))
								z_end_i <= 1;
							else if (2**(1*48*`w-1)<=M_l&&M_l<2**(2*48*`w-1))
								z_end_i <= 2;
							else if (2**(2*48*`w-1)<=M_l&&M_l<2**(3*48*`w-1))
								z_end_i <= 3;
							else if (2**(3*48*`w-1)<=M_l&&M_l<2**(4*48*`w-1))
								z_end_i <= 4;
							else if (2**(4*48*`w-1)<=M_l&&M_l<2**(5*48*`w-1))
								z_end_i <= 5;
							state <= 1;
						end
					end
					1:
					begin 
						if (z_end_i == 1)
							begin
								z_end <= 1;
								state <= 3;
							end
						else
							begin
							state <= 2;
							end
					start <= 1;
					end
					2:
					begin
						if (done)
							begin
								start <= 0;
								z_end_i <= z_end_i - 1;
								state <= 1;
								M_i <= {M_l[(index+1)*(48*`w)+:48*`w],C_i};
								index <= index + 1;
							end
					end
					3:
					begin 
						if (done)
						begin
							start <= 0;
							C <= C_i;
						end
					end
				endcase
			end
		end
	cf			    T1 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_i),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done),
		.C(C_i)
	);
	
endmodule

