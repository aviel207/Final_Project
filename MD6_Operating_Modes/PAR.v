`include "parameters.vh"

module PAR
#( 	// constants
	parameter index0 = 56'd0,
	parameter index1 = 56'd1,
	parameter index2 = 56'd2,
	parameter index3 = 56'd3,
	parameter index4 = 56'd4,
	parameter index5 = 56'd5,
	parameter index6 = 56'd6,
	parameter index7 = 56'd7,
	parameter index8 = 56'd8,
	parameter index9 = 56'd9,
	parameter index10 = 56'd10,
	parameter index11 = 56'd11,
	parameter index12 = 56'd12,
	parameter index13 = 56'd13,
	parameter index14 = 56'd14,
	parameter index15 = 56'd15
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
  input  wire  						hybrid,				//indicate hybrid mode  
  output reg                		PAR_done,
  output reg   [`wi*`c*`w-1:0] 	 		C  					// Current hash
	
);


	reg 				  start;
	reg   	[3:0]  		  z_end;   				// End indicator
	reg   	[3:0]  		  z_end_i;
	reg 	[2:0]		  state;

	reg    [4*64*`w-1:0]    M_i;	
	reg    [7:0]		  l;
	wire 			  	  done0;
	wire 			  	  done1;
	wire 			  	  done2;
	wire 			  	  done3;
	wire 			  	  done4;
	wire 			  	  done5;
	wire 			  	  done6;
	wire 			  	  done7;
	wire 			  	  done8;
	wire 			  	  done9;
	wire 			  	  done10;
	wire 			  	  done11;
	wire 			  	  done12;
	wire 			  	  done13;
	wire 			  	  done14;
	wire 			  	  done15;
	
	wire   [`c*`w-1:0]    C0;
	wire   [`c*`w-1:0]    C1;
	wire   [`c*`w-1:0]    C2;
	wire   [`c*`w-1:0]    C3;
	wire   [`c*`w-1:0]    C4;
	wire   [`c*`w-1:0]    C5;
	wire   [`c*`w-1:0]    C6;
	wire   [`c*`w-1:0]    C7;
	wire   [`c*`w-1:0]    C8;
	wire   [`c*`w-1:0]    C9;
	wire   [`c*`w-1:0]    C10;
	wire   [`c*`w-1:0]    C11;
	wire   [`c*`w-1:0]    C12;
	wire   [`c*`w-1:0]    C13;
	wire   [`c*`w-1:0]    C14;
	wire   [`c*`w-1:0]    C15;
	
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
							M_i <= {M_l[0+:4*64*`w]};
							if (M_l<2**(64*`w-1))
								z_end_i <= 1;
							else if (2**(1*64*`w-1)<=M_l&&M_l<2**(4*64*`w-1))
								z_end_i <= 2;
							else if (2**(4*64*`w-1)<=M_l&&M_l<2**(16*64*`w-1))
								z_end_i <= 3;
							state <= 1;
						end
					end
					1:
					begin 
						if (L == L - z_end_i + 1)
							begin
							if (!hybrid)
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
						if ((done0&&done1&&done2&&done3&&(z_end_i==2))||(done0&&done1&&done2&&done3&&done4&&done5&&done6&&done7&&done8&&done9&&done10&&done11&&done12&&done13&&done14&&done15&&(z_end_i==3)))
							begin
								start <= 0;
								z_end_i <= z_end_i - 1;
								state <= 1;
								M_i <= {C15,C14,C13,C12,C11,C10,C9,C8,C7,C6,C5,C4,C3,C2,C1,C0};
								l <= l + 1;
							end
					end
					3:
					begin 
						if (done0)
						begin
							start <= 0;
							PAR_done <= 1;
							C <= {C15,C14,C13,C12,C11,C10,C9,C8,C7,C6,C5,C4,C3,C2,C1,C0};
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
		.M_in(M_i[(2)*(64*`w)-1:1*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done1),
		.C(C1)
	);
	
		cf			    T3 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index2),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_i[(3)*(64*`w)-1:2*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done2),
		.C(C2)
	);
	
		cf			    T4 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index3),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_i[(4)*(64*`w)-1:3*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done3),
		.C(C3)
	);

		cf			    T5 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index4),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(5)*(64*`w)-1:4*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done4),
		.C(C4)
	);
	
		cf			    T6 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index5),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(6)*(64*`w)-1:5*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done5),
		.C(C5)
	);
	
		cf			    T7
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index6),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(7)*(64*`w)-1:6*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done6),
		.C(C6)
	);
	
		cf			    T8 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index7),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(8)*(64*`w)-1:7*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done7),
		.C(C7)
	);
	
		cf			    T9
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index8),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(9)*(64*`w)-1:8*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done8),
		.C(C8)
	);
	
		cf			    T10 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index9),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(10)*(64*`w)-1:9*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done9),
		.C(C9)
	);
	
		cf			    T11 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index10),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(11)*(64*`w)-1:10*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done10),
		.C(C10)
	);
	
		cf			    T12 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index11),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(12)*(64*`w)-1:11*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done11),
		.C(C11)
	);
	
		cf			    T13 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index12),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(13)*(64*`w)-1:12*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done12),
		.C(C12)
	);
	
		cf			    T14 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index13),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(14)*(64*`w)-1:13*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done13),
		.C(C13)
	);

		cf			    T15
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index14),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(15)*(64*`w)-1:14*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done14),
		.C(C14)
	);
	
		cf			    T16 
	(
		.clk(clk),
		.reset(reset),
		.enable(start),
		.index(index15),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.r(r),
		.d(d),
		.M_in(M_l[(16)*(64*`w)-1:15*(64*`w)]),
		.padding_zero_M(padding_zero_M),
		.K(K),
		.keylen(keylen),
		.done(done15),
		.C(C15)
	);
	
endmodule

