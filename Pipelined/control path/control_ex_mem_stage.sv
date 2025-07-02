//******************************************************************************************
// Design: control_ex_mem_stage.sv
// Author: Adam 
// Description: pipeline register for the control signals between execute and memory stages
// v 0.1
//******************************************************************************************


module control_ex_mem_stage (
       input logic        clk, rst,

       //input 
       input logic        reg_write_e, mem_write_e,
       input logic [1:0]  result_src_e, 

       //output
       output logic       reg_write_m, mem_write_m,
       output logic [1:0] result_src_m
);

always_ff @ (posedge clk or posedge rst) 
begin
       if (rst) begin
              reg_write_m  <= 0;
              mem_write_m  <= 0;
              result_src_m <= 0;
       end

       else begin
              reg_write_m  <= reg_write_e;
              mem_write_m  <= mem_write_e;
              result_src_m <= result_src_e;
       end

end


endmodule