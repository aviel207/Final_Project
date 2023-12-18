`timescale 1ns / 1ps

module tb_top_sim
(
);

  reg  tb_clk;
  reg  tb_reset;
  reg  tb_button_tx;
  reg  tb_RxD;
  wire tb_done_M;
  wire tb_done_d;
  wire tb_done_K;
  wire tb_done_L;
  wire tb_done_r;
  wire tb_done_keylen;
  wire tb_done_padding;
  wire tb_done_rx;
  wire tb_done_MD6;
  wire tb_TxD;
  
  reg [7:0] data [0:584];  // 8-bit data array for 585 bytes
  reg [9:0] count; // Counter to keep track of bits
  
  reg [7:0] hash [0:63];
  reg [511:0] hash_s;
  reg [9:0] temp;
  reg [5:0] count_hash;
	
  reg [7:0] soft_hash [0:63];
  reg [511:0] soft_hash_s;
  reg [5:0] i;
  reg [15:0] d;
  
	initial
	begin
		// Initialize signals
		tb_clk = 0;
		tb_reset = 1;
		tb_button_tx = 0;
		tb_RxD = 1;
		hash_s = 512'h0;
		count = 0;
		count_hash = 0;
		i = 0;
		#700 tb_reset = 0;
		
		// Open the file for reading
		$readmemh("input_data.txt", data);
	
		
		#0	    tb_RxD   = 1;
		
		repeat(585)
		begin
			send_byte();
			count = count + 1;
		end
		
		#500000    tb_button_tx  = 1;  	
		#2035000;	
		repeat(64)
		begin 
			get_byte();
			hash[count_hash] = temp[8:1];
			count_hash = count_hash + 1;
		end
		
		d = {data[513],data[512]};
		$display("d: %h", d);
		repeat(d/8)begin
			hash_s = {hash_s, hash[i]};
			i = i + 1;
		end
		$display("hardware: %h", hash_s);

		i = 0;
		$readmemh("soft_hash.txt", soft_hash);
		repeat(d/8)begin
			soft_hash_s = {soft_hash_s, soft_hash[i]};
			i = i + 1;
		end
		$display("software: %h", soft_hash_s);

	
	end
	
	
		
	always 
	begin
	   #5  tb_clk = ~tb_clk; 
	end

	
	task send_byte();
	begin
	  #104166   tb_RxD   = 0;  
	  
	  #104166   tb_RxD   = data[count][0]; 
	  #104166   tb_RxD   = data[count][1];
	  #104166   tb_RxD   = data[count][2];
	  #104166   tb_RxD   = data[count][3];
	  #104166   tb_RxD   = data[count][4];
	  #104166   tb_RxD   = data[count][5];
	  #104166   tb_RxD   = data[count][6];
	  #104166   tb_RxD   = data[count][7];

	  #104166   tb_RxD   = 1;
	end
  endtask

	task get_byte();
	begin
	  #104166   temp[0]	= tb_TxD;  
	  
	  #104166   temp[1]	= tb_TxD;
	  #104166   temp[2]	= tb_TxD;
	  #104166   temp[3]	= tb_TxD;
	  #104166   temp[4]	= tb_TxD;
	  #104166   temp[5]	= tb_TxD;
	  #104166   temp[6]	= tb_TxD;
	  #104166   temp[7]	= tb_TxD;
	  #104166   temp[8]	= tb_TxD;
	  
	  #104166   temp[9]	= tb_TxD;
	end
  endtask

	

  top DUT 
  (
    tb_clk  ,
    tb_reset,
    tb_button_tx,
    tb_RxD,
    tb_done_M,
    tb_done_d,
    tb_done_K,
    tb_done_L,
    tb_done_r,
    tb_done_keylen,
    tb_done_padding,
    tb_done_rx,
    tb_done_MD6,
    tb_TxD
  );
  
endmodule
