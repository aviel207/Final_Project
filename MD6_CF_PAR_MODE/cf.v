`include "parameters.vh"

module cf
(
  input  wire 				 clk,
  input  wire 				 reset,
  input  wire 				 enable,
  input  wire  [55:0]   	 index, 
  input  wire  [1:0]         index_padd,  
  input  wire  [7:0]   		 level,  
  input  wire  [7:0]   		 Level,  // Max level
  input  wire  [3:0]   		 z_end,  
  input	 wire  [11:0] 		 r,	     // rounds
  input	 wire  [11:0] 		 d,      // length of desired hash
  input  wire  [64*`w-1:0]   M_in,
  input  wire  [11:0]        padding_zero_M,
  input  wire  [8*`w-1:0]    K,
  input  wire  [7:0]         keylen, 
  output wire  				 done,
  output wire  [`c*`w-1:0]	 C	
);
	
	wire [11:0] 					A_steps_i; // batch of 16 words index
	wire 						N_to_A_en;
	wire 						iterative_en;
	wire 						A_shift_stop;
    wire [`n*`w-1:0]			A;
	wire [`c*`w-1:0] 			A_steps;

	wire [`n*`w-1:0] 			N;		
	wire [168*`w-1:0]			s_to_cf;
    wire [16*`b-1 : 0]		 	rshift_to_cf;
	wire [16*`b-1 : 0] 			lshift_to_cf;
	
	assign C = (index<=index_padd) ? A[(`n*`w-`c*`w) +:`c*`w] : 0;

	N				T1 
	(
		.index(index),
		.index_padd(index_padd),
		.level(level),
		.Level(Level),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_in),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.N(N)
	);

	S					T4 
	(

		.S_out(s_to_cf)
	);
	
	rom_rshift_lshift	T5
	(

		.rshift_to_cf(rshift_to_cf),
		.lshift_to_cf(lshift_to_cf)
	);
	
	
	A_steps				T6 
	(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.r(r),      
		.S_in(s_to_cf),
		.R_shift(rshift_to_cf),
		.L_shift(lshift_to_cf),
		.A(A),
		.N_to_A_en(N_to_A_en),
		.iterative_en(iterative_en),
		.A_steps_i(A_steps_i),
		.A_steps(A_steps),
		.done(done),
		.A_shift_stop(A_shift_stop)
	);
	
	A_arrangement			T7 
	(
		.clk(clk),
		.N_to_A_en(N_to_A_en),
		.iterative_en(iterative_en),
		.done(A_shift_stop),
		.A_steps_i(A_steps_i),
		.N(N),
		.A_steps(A_steps),
		.A_out(A)
	);
	
endmodule