//******************************************************************************************
// Design: datapath.sv
// Author: Adam 
// Description: main decoder - produces mux select, register enable and memory write enable
//                             signals for the datapath
// v 0.1
//******************************************************************************************
import types ::*;

module maindec (
	//input 
	input logic [6:0]    op,

	//output
	output logic         reg_write, mem_write,
	output logic         alu_src_b,
	output logic         alu_src_a,			
	output logic [1:0]   result_src, 
	output logic         branch, jump,
	output logic [2:0]   imm_src,
    output alu_control_t alu_control 
);


always_comb begin 
	reg_write   = 1'b0;
	mem_write   = 1'b0;
	imm_src     = 3'b000;
	alu_src_a   = 1'b1;
	alu_src_b   = 1'b0;
	result_src  = 2'b00;
	branch      = 1'b0;
	jump        = 1'b0;
	alu_control = ALU_CONTROL_ADD;

	case (op)
        7'b0000011: begin          // load instruction 
			reg_write   = 1'b1;
			mem_write   = 1'b0;
			imm_src     = 3'b000;
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b1;
			result_src  = 2'b01;
			branch      = 1'b0;
			jump        = 1'b0;
			alu_control = ALU_CONTROL_ADD;
		end

		7'b0110011: begin         // R type
			reg_write   = 1'b1;
			mem_write   = 1'b0;
			imm_src     = 3'b000;
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b0;
			result_src  = 2'b00;
			branch      = 1'b0;
			jump        = 1'b0;
			alu_control = ALU_CONTROL_RTYPE;
		end

		
		7'b0010011: begin         // I type
			reg_write   = 1'b1;
			mem_write   = 1'b0;
			imm_src     = 3'b000;
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b1;
			result_src  = 2'b00;
			branch      = 1'b0;
			jump        = 1'b0;
			alu_control = ALU_CONTROL_ITYPE;
		end
		


		7'b0100011: begin        // store
			reg_write   = 1'b0;
			mem_write   = 1'b1;
			imm_src     = 3'b001;  
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b1;
			result_src  = 2'b00;
			branch      = 1'b0;
			jump        = 1'b0;
			alu_control = ALU_CONTROL_ADD;
		end


		7'b1101111: begin       // jal
			reg_write   = 1'b1;
			mem_write   = 1'b0;
			imm_src     = 3'b011;  
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b0;
			result_src  = 2'b10;
			branch      = 1'b0;
			jump        = 1'b1;
			alu_control = ALU_CONTROL_ADD;
		end
		
		7'b1100011: begin         // beq for now but can be extended for other branch operators
			reg_write   = 1'b0;
			mem_write   = 1'b0;
			imm_src     = 3'b010;  
			alu_src_a   = 1'b0;
			alu_src_b   = 1'b0;
			result_src  = 2'b00;
			branch      = 1'b1;
			jump        = 1'b0;
			alu_control = ALU_CONTROL_SUB;

			//to be extended use a mux to choose the correct result
			//case(funct3)
				//3'b000:  branch_src  = ; // BEQ
				//3'b001:  branch_src  = ; // BNQ choose  ~zero flag
				//default: branch_src  = ; // for the rest check ALU result (BLT, BGE...)
			//endcase
		end


		default: ;   //default value
	endcase

end

//always_comb
  // case(op)
		// reg_write | imm_src | alu_src_a | alu_src_b | mem_write | result_src | branch | alu_op | jump
	//	7'b0000011: controls = 14'b1_00_10_01_0_01_0_00_0; // lw
	//	7'b0100011: controls = 14'b0_01_10_01_1_00_0_00_0; // sw
	//	7'b0110011: controls = 14'b1_xx_10_00_0_00_0_10_0; // R type
	//	7'b1100011: controls = 14'b0_10_10_00_0_00_1_01_0; // beq
	//	7'b0010011: controls = 14'b1_00_10_01_0_00_0_10_0; // I type ALU
	//	7'b1101111: controls = 14'b1_11_01_10_0_00_0_00_1; // jal
	//	default:    controls = 14'bx_xx_xx_xx_x_xx_x_xx_x; // default value
   //endcase

endmodule