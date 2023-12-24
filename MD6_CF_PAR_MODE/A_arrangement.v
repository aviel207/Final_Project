`include "parameters.vh"

module A_arrangement
(
	input  wire   				clk,
	input  wire   				N_to_A_en,  
	input  wire   				iterative_en,
	input  wire 				done,
	input  wire	[11:0]			A_steps_i,
	input  wire [`n*`w-1:0]		N,
	input  wire [`c*`w - 1 : 0] A_steps,
	output reg  [`n*`w-1:0] 	A_out

); 

always@(posedge clk)
begin
	if (N_to_A_en)
		A_out <= N;
	if (((0<A_steps_i&&A_steps_i<`r)||iterative_en)&&!done)
		A_out <= {A_steps,A_out[`n*`w -1:`c*`w]};
end

endmodule