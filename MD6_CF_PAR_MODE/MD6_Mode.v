`include "parameters.vh"

module MD6_Mode
(
  input  wire 			     		 clk, 	 
  input  wire				 		 reset,
  input  wire 				 		 enable,
  input  wire  [1:0]				 index_padd,
  input	 wire  [11:0] 		 		 d,  // Length of desired hash. 224|256|384|512
  input  wire  [8*`w-1:0]    		 K,  // Key
  input  wire  [7:0]         		 keylen, 
  input  wire  [7:0]   		 		 L,  // Max level
  input	 wire  [11:0] 		 		 r,  // Nnumber of rounds. max default is 168 (40+512/4)
  input  wire  [`wi*(64*`w)-1:0] 	 M,	 // Message 
  input  wire  [11:0]        		 padding_zero_M,
		 
  output reg   [511:0]   	 		 D   // Final hash value
	
);
	
	wire 					 enable_hybrid_SEQ;

	wire  [`c*`w-1:0]   		 D_i;

	wire 	[2:0] 	   		 d_length;
	

	assign d_length =(d==224) ? 1 : (d==256) ? 2 : (d==384) ? 3 : (d==512) ? 4 : -1;

	always@ (*)
		case(d_length)
			1 : D <= {D_i[`c*`w-225:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			2 : D <= {D_i[`c*`w-193:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			3 : D <= {D_i[`c*`w-321:`c*`w-384],D_i[`c*`w-257:`c*`w-320],D_i[`c*`w-193:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			4 : D <= {D_i[`c*`w-449:`c*`w-512],D_i[`c*`w-385:`c*`w-448],D_i[`c*`w-321:`c*`w-384],D_i[`c*`w-257:`c*`w-320],D_i[`c*`w-225:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
		endcase
		
	
	PAR 		T1
	(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.index_padd(index_padd),
		.L(L),
		.r(r),
		.d(d),
		.M_l(M),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.PAR_done(enable_hybrid_SEQ),
		.C(D_i)
	);
	
endmodule
