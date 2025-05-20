//******************************************************************************************
// Design: control_mem_w_stage.sv
// Author: Adam 
// Description: pipeline register for the control signals between memory and wirte back stages
// v 0.1
//******************************************************************************************


module control_mem_wb_stage (
       input logic clk, rst, //clr,

       //input 
       input logic reg_write_m,
       input logic [1:0] result_src_m, 

       //output
       output logic reg_write_w,
       output logic [1:0] result_src_w 
);

always_ff @ (posedge clk or posedge rst) 
begin
       if (rst) begin
              reg_write_w <= 0;
              result_src_w <= 0;
       end

       else begin
              reg_write_w <= reg_write_m;
              result_src_w <= result_src_m;
       end

end


endmodule