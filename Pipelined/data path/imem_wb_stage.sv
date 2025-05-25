//******************************************************************************************
// Design: mem_wb_stage.sv
// Author: Adam 
// Description: pipeline register between memory access and write back stages
// v 0.1
//******************************************************************************************


module imem_wb_stage (
       input logic         clk, rst,

       //input 
       input logic [31:0]  alu_result_m, read_data_m, pc_plus_4_m,
       input logic [4:0]   rd_m,

       //output
       output logic [31:0] alu_result_w, read_data_w, pc_plus_4_w,
       output logic [4:0]  rd_w
);

always_ff @ (posedge clk or posedge rst)
begin
    if (rst) begin 
        alu_result_w <= 0;
        read_data_w  <= 0;
        pc_plus_4_w  <= 0;
        rd_w         <= 0;
    end

    else begin
        alu_result_w <= alu_result_m;
        read_data_w  <= read_data_m;
        pc_plus_4_w  <= pc_plus_4_m;
        rd_w         <= rd_m;
    end

end


endmodule