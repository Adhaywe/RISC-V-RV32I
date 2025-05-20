//******************************************************************************************
// Design: control_de_ex_stage.sv
// Author: Adam 
// Description: pipeline register for the control signals between decode and execute stages
// Date: 08.05.2025
//******************************************************************************************
import types::*;

module control_de_ex_stage (
       input logic       clk, rst, clr,

       //input 
       input logic       reg_write_d, mem_write_d, jump_d, branch_d,
       input logic [1:0] result_src_d, 
       input logic       alu_src_a_d, alu_src_b_d,
       input alu_op_t alu_op_d,

       //output
       output logic       reg_write_e, mem_write_e, jump_e, branch_e,
       output logic [1:0] result_src_e, 
       output logic        alu_src_a_e, alu_src_b_e,
       output alu_op_t alu_op_e
);

always_ff @ (posedge clk or posedge rst) 
begin
       if (rst || clr) begin
              reg_write_e <= 0;
              mem_write_e <= 0;
              jump_e <= 0;
              branch_e <= 0;
              result_src_e <= 0;
              alu_src_a_e <= 0;
              alu_src_b_e <= 0;
              alu_op_e <= alu_op_t'(4'd0);
       end

       else begin
              reg_write_e <= reg_write_d;
              mem_write_e <= mem_write_d;
              jump_e <= jump_d;
              branch_e <= branch_d;
              result_src_e <= result_src_d;
              alu_src_a_e <= alu_src_a_d;
              alu_src_b_e <= alu_src_b_d;
              alu_op_e <= alu_op_d;
       end

end


endmodule