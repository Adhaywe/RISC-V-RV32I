//-----------------------------
// SystemVerilog 
// adder.sv
// 
// adder
// 24.02.2025
//-----------------------------
 

module adder (input [31:0] a, b,
			  output [31:0] y);

assign y = a + b;

endmodule