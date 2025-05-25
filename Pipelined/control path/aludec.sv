//******************************************************************************************
// Design: aludec.sv
// Author: Adam 
// Description: ALU decoder
// v 0.1
//******************************************************************************************
import types::*;

module aludec (
	   input logic [2:0]   funct3,
	   input logic         funct7b5,
	   input alu_control_t alu_control,
	   output alu_op_t     alu_op
);

always_comb
   case(alu_control)
		ALU_CONTROL_ADD:    alu_op = ADD; 					// addition
		ALU_CONTROL_SUB:    alu_op = SUB; 					// subtraction
		
		ALU_CONTROL_RTYPE: begin
			case(funct3) // function bits
				3'b000: begin
					case(funct7b5)
						1'b0:    alu_op = ADD; // ADD 
						1'b1:    alu_op = SUB; // SUB 
						default: alu_op = ADD; // Default to ADD
					endcase
				end
				3'b001: alu_op = SLL; // SLL 
				3'b010: alu_op = SLT; // SLT 
				3'b011: alu_op = SLTU; // SLTU 
				3'b100: alu_op = XOR; // XOR 
				3'b101: begin
					case(funct7b5)
						1'b0:    alu_op = SRL; // SRL 
						1'b1:    alu_op = SRA; // SRA 
						default: alu_op = SRL; // Default to SRL 
					endcase
				end
				3'b110:  alu_op = OR; // OR 
				3'b111:  alu_op = AND; // AND 
				default: alu_op = ADD; // Default to ADD 
			endcase
		end

			ALU_CONTROL_ITYPE:  begin // We look at the function bits
                case(funct3)
                    3'b000: alu_op = ADD;  // ADDI 
                    3'b001: alu_op = SLL;  // SLLI 
                    3'b010: alu_op = SLT;  // SLTI 
                    3'b011: alu_op = SLTU; // SLTIU 
                    3'b100: alu_op = XOR;  // XORI 
                    3'b101: begin
                        case(funct7b5)
                            1'b0:    alu_op = SRL; // SRLI 
                            1'b1:    alu_op = SRA; // SRAI 
                            default: alu_op = SRL; // Default to SRLI 
                        endcase
                    end
                    3'b110:  alu_op = OR;  // ORI 
                    3'b111:  alu_op = AND; // ANDI 
                    default: alu_op = ADD; // Default to ADD 
                endcase
            end

			ALU_CONTROL_BTYPE: begin
                case(funct3)
                    3'b000:  alu_op = SUB;  // BEQ check for zero flag
                    3'b001:  alu_op = SUB;  // BNE check for not zero flag
                    3'b100:  alu_op = SLT;  // BLT check if a < b
                    3'b101:  alu_op = SGE;  // BGE check if a < a (we will invert the alusrca and alusrcb in the multiplexer)
                    3'b110:  alu_op = SLTU; // BLTU check if a < b unsigned
                    3'b111:  alu_op = SGEU; // BGEU operation check if b < a unsigned (we will invert the alusrca and alusrcb in the multiplexer)
                    default: alu_op = ADD;  // Default to ADD 
                endcase
            end
            default :        alu_op = ADD; // Default to ADD 
        
		
   endcase
endmodule