//******************************************************************************************
// Design: extend.sv
// Author: Adam 
// Description: extension unit
// v 0.1
//******************************************************************************************


module extend (
    input  logic [31:7] instr,
    input  logic [ 2:0] imm_src,
    output logic [31:0] imm_ext
);

always_comb
   case(imm_src)
     //I-type
     3'b000: imm_ext = {{20{instr[31]}}, instr[31:20]};
     //S-type
     3'b001: imm_ext = {{20{instr[31]}}, instr[31:25], instr[11:7]};
     //B-type
     3'b010: imm_ext = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};
     //J-type
     3'b011: imm_ext = {{12{instr[31]}}, instr[19:12], instr[20], instr[30:21], 1'b0};
     //U-type
     3'b100: imm_ext = {instr[31:12], 12'b0};
     
     default: imm_ext = 32'bx;
   endcase
endmodule