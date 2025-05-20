//******************************************************************************************
// Design: alu.sv
// Author: Adam 
// Description: ALU
// v 0.1
//******************************************************************************************

import types ::*;

module alu (
	   input logic [31:0]  a, 
       input logic [31:0]  b,
	   input alu_op_t      alu_op,
	   output logic [31:0] alu_result,
	   output logic        zero
);



always_comb
   case(alu_op)
     ADD  : 	alu_result = a + b;   							 // add
	 SUB  : 	alu_result = a - b;   							 // sub
	 AND  : 	alu_result = a & b;   							 // and
	 OR   : 	alu_result = a | b;   							 // or
	 SLT  : 	alu_result = ($signed(a) < $signed(b)) ? 1: 0;   // slt 
	 SLTU : 	alu_result = (a < b) ? 1: 0;                     // sltu
	 SGE  : 	alu_result = ($signed(a) >= $signed(b)) ? 1 : 0; // sge
	 SGEU : 	alu_result = (a >= b) ? 1: 0;                    // sgeu
	 XOR  : 	alu_result = a ^ b ; 							 // xor
	 SLL  : 	alu_result = a << b[4:0]; 				         //shift left logical sll
	 SRL  : 	alu_result = a >> b[4:0]; 						 //shift right logical srl
	 default : 		alu_result = 32'bx;
   endcase

assign zero = (alu_result == 0) ? 1 : 0;
endmodule

// logic or and bitwise or differences