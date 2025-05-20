//-----------------------------
// SystemVerilog 
// alu.sv
// 
// alu
// 25.02.2025
//-----------------------------


module alu (input logic [31:0] a, 
            input logic [31:0] b,
		    input logic [2:0] ALUControl,
			output logic [31:0] ALUResult,
			output logic Zero);

always_comb
   case(ALUControl)
     3'b000 : ALUResult = a + b;
	 3'b001 : ALUResult = a - b;
	 3'b010 : ALUResult = a & b;
	 3'b011 : ALUResult = a | b;
	 3'b101 : ALUResult = a < b;
	 default : ALUResult = 32'bx;
   endcase

assign Zero = (ALUResult == 0) ? 1 : 0;
endmodule

// logic or and bitwise or differences