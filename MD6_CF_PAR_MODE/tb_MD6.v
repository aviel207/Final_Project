`include "parameters.vh"
`timescale	1ns/1ps

module tb_MD6
(
);

reg  			  	tb_clk;
reg  			  	tb_reset; 
reg 			  	tb_enable;
reg  [1:0]          tb_index_padd;
reg  [7:0]   	  	tb_Level;  // Max level 
reg  [11:0]       	tb_d;     // length of desired hash
reg  [`wi*64*`w-1:0]tb_M_in;
reg  [11:0] 		tb_padding;
reg  [7:0]  		tb_keylen;
reg  [8*`w-1:0]   	tb_K; 
reg  [11:0] 	  	tb_r;
wire [511:0]  	  	tb_D;


// Internal signals (XMR)


initial begin
//  $display ("time\t\t  clk reset	 index 		level		Level		z_end		d 		M_in		K 		r		hash   ");
//  $monitor ("%8g\t\t%b   %b    %b	%b	%b		%b   %b    %b	%b	%b     %b", 
//	  $time, tb_clk, tb_reset, tb_index,  tb_level,	tb_Level,	tb_z_end,	tb_d, 	tb_M_in,  tb_K,	tb_r, tb_C);	       	
 
  tb_clk   	<= 0;
  tb_reset 	<= 1;
  tb_Level 	<= 64;
  tb_d	   	<= 224;
  tb_padding<= 3392;//2816;// //4072; //4072-1024;
  tb_keylen <= 10;//10;
  tb_M_in 	<= `M_array_2;//64'h6162630000000000;//`M_array_3;//
  tb_K	   	<= {64'h3435000000000000,"abcde123"}; // abcde12345
  tb_r     	<= 5;
  tb_enable <= 0;
  tb_index_padd <= 1;
  #20   tb_reset <= 0;
  tb_enable <= 1; 
end

always
 begin
   #5  tb_clk = ~tb_clk; 
end

// Connect DUT to test bench
MD6_Mode DUT1 
(
tb_clk,
tb_reset,
tb_enable,
tb_index_padd,
tb_d,
tb_K,
tb_keylen,
tb_Level,
tb_r,
tb_M_in,
tb_padding,
tb_D
);
  
endmodule
