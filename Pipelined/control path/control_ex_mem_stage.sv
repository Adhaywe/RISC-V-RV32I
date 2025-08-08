//******************************************************************************************
// Design: control_ex_mem_stage.sv
// Author: Adam 
// Description: pipeline register for the control signals between execute and memory stages
// v 0.1
//******************************************************************************************
import types::*;

module control_ex_mem_stage (
       input logic        clk, rst,

       //input 
       input logic        reg_write_e, mem_write_e,
       input logic [1:0]  result_src_e,
       input mac_op_t     mac_op_e,
       input logic        mac_write_e,

       //output
       output logic       reg_write_m, mem_write_m,
       output logic [1:0] result_src_m,
       output logic       mac_write_m,
       output mac_op_t    mac_op_m
);

always_ff @ (posedge clk or posedge rst)
begin
       if (rst) begin
              reg_write_m  <= 0;
              mem_write_m  <= 0;
              result_src_m <= 0;
              mac_write_m  <= 0;
              mac_op_m     <=  mac_op_t'(2'd0);
       end

       else begin
              reg_write_m  <= reg_write_e;
              mem_write_m  <= mem_write_e;
              result_src_m <= result_src_e;
              mac_write_m  <= mac_write_e;
              mac_op_m     <= mac_op_e;
       end

end


endmodule