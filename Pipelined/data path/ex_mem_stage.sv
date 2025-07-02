//******************************************************************************************
// Design: ex_mem_stage.sv
// Author: Adam 
// Description:  pipeline register between execute and memory stages
// v 0.1
//******************************************************************************************


module ex_mem_stage (
       input logic          clk, rst,

       //input 
       input  logic [31:0]  alu_result_e, write_data_e, pc_plus_4_e,
       input  logic [4:0 ]  rd_e,

       //output
       output logic [31:0]  alu_result_m, write_data_m, pc_plus_4_m,
       output logic [4:0 ]  rd_m
);

always_ff @ (posedge clk or posedge rst)
begin
    if (rst) begin 
        alu_result_m <= 0;
        write_data_m <= 0;
        pc_plus_4_m  <= 0;
        rd_m         <= 0;
    end

    else begin
        alu_result_m <= alu_result_e;
        write_data_m <= write_data_e;
        pc_plus_4_m  <= pc_plus_4_e;
        rd_m         <= rd_e;
    end

end


endmodule