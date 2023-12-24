`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 14/09/2022 
// Module Name: top
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module top
#(parameter size_in = `wi*(64*`w),
  parameter size_out = 512
  ) 
(
	input 	wire	clk,
	input 	wire 	reset,
	input 	wire 	button_tx,
	input 	wire 	RxD,
	output  wire	done_M,
	output  wire	done_d,
	output  wire	done_K,
	output  wire	done_L,
	output  wire	done_r,
	output  wire	done_keylen,
	output  wire	done_padding,
	output  wire    done_rx,
	output	wire 	TxD
); 
	wire  transmit_en;	
	wire [size_in-1:0] data;
	wire [size_out-1:0] hash;
	wire  [15:0] d;
	wire  [511:0]K;
	wire  [7:0]  keylen;
	wire  [7:0]  L;
	wire  [15:0] r;
	wire  [15:0] padding_zero_M;
	wire  [7:0] index_padd;

	button_debouncing T1 
	(
		.clk(clk),
		.button_tx(button_tx),
		.transmit_en(transmit_en)
	);
	
	receiver	T2
	(
		.clk(clk),
		.reset(reset),
		.RxD(RxD),
		.d(d),
		.K(K),
		.keylen(keylen),
		.L(L),
		.r(r),
		.Message(data),
		.padding_zero_M(padding_zero_M),
		.index_padd(index_padd),
		.done_M(done_M),
		.done_d(done_d),
		.done_K(done_K),
		.done_L(done_L),
		.done_r(done_r),
		.done_keylen(done_keylen),
		.done_padding(done_padding),
		.done_rx(done_rx)
	);
	
	MD6_Mode 	T3
	(
		.clk(clk),
		.reset(reset),
		.enable(done_rx),
		.d(d[11:0]),
		.K(K),
		.keylen(keylen),
		.L(L),
		.r(r[11:0]),
		.M(data),
		.padding_zero_M(padding_zero_M),
		.index_padd(index_padd),
		.D(hash)
	);
	
	transmiter	T4
	(
		.clk(clk),
		.reset(reset),
		.transmit(transmit_en),
		.d(d),
		.data(hash),
		.TxD(TxD)
	);
	


endmodule
