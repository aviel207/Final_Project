`include "parameters.vh"

module PAR
#( 	// constants
	parameter index0 = 56'd0,
	parameter index1 = 56'd1
 )
(
  input  wire 			     		clk, 
  input  wire				 		reset,
  input  wire 				 		enable,
  input  wire  [1:0]				index_padd,
  input  wire  [7:0]   		 		L,  				// Max level 
  input	 wire  [11:0] 		 		r,  				// Nnumber of rounds. max default is 168 (40+512/4)  | need to add min 80 value
  input	 wire  [11:0] 		 		d,  				// Length of desired hash. 224|256|384|512
  input  wire  [`wi*(64*`w)-1:0]    M_l,				// Current message 
  input  wire  [11:0]        		padding_zero_M,
  input  wire  [8*`w-1:0]    		K,  				// Key
  input  wire  [7:0]         		keylen, 
  output reg                		PAR_done,
  output reg   [`c*`w-1:0] 	 		C  					// Current hash
	
);


	reg 				  start;
	reg   	[3:0]  		  z_end;   				// End indicator
	reg   	[3:0]  		  z_end_i;
	reg 	[2:0]		  state;

	reg    [64*`w-1:0]    M_i;	
	reg    [7:0]		  l;
	wire 			  	  done0;
	wire 			  	  done1;
	
	wire   [`c*`w-1:0]    C0;
	wire   [`c*`w-1:0]    C1;

	
	always@ (posedge clk)
		begin 
			if (reset)
			begin
				start <= 0;
				z_end <= 0;
				state <= 0;
				l     <= 1;
				PAR_done <= 0;
			end
			else 
			begin
				case (state)
					0:
					begin
						if (enable)
						begin
							M_i <= {M_l[0+:64*`w]};
							if (index_padd == 0)
								z_end_i <= 1;
							else
								z_end_i <= 2;
							state <= 1;
						end
					end
					1:
					begin 
						if (L == L - z_end_i + 1)
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
						if (done0&&done1&&(z_end_i==2))
							begin
								start <= 0;
								z_end_i <= z_end_i - 1;
								state <= 1;
								M_i <= {C1,C0};
								l <= l + 1;
							end
					end
					3:
					begin 
						if (done0)
						begin
							start <= 0;
							PAR_done <= 1;
							C <= C0;
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
		.index(index0),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_i[(1)*(64*`w)-1:0*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done0),
		.C(C0)
	);
	
		cf			    T2
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index1),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(2)*(64*`w)-1:1*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done1),
		.C(C1)
	);
	
	
endmodule

