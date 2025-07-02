//******************************************************************************************
// Design: id_ex_stage.sv
// Author: Adam 
// Description: id ex stage - pipeline register between decode and execute stages
// v 0.1
//******************************************************************************************



module id_ex_stage (
       input  logic        clk, rst, clr,

       //input 
       input  logic [31:0] rd1_d, rd2_d, pc_d, imm_ext_d, pc_plus_4_d,
       input  logic [ 4:0] rs1_d, rs2_d, rd_d,

       //output
       output logic [31:0] rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e,
       output logic [ 4:0] rs1_e, rs2_e, rd_e
);

always_ff @ (posedge clk or posedge rst) 
begin
    if (rst || clr) begin
        rd1_e       <= 0;
        rd2_e       <= 0;
        pc_e        <= 0;
        imm_ext_e   <= 0;
        pc_plus_4_e <= 0;
        rs1_e       <= 0;
        rs2_e       <= 0;
        rd_e        <= 0;
    end
    else begin
        rd1_e       <= rd1_d;
        rd2_e       <= rd2_d;
        pc_e        <= pc_d;
        imm_ext_e   <= imm_ext_d;
        pc_plus_4_e <= pc_plus_4_d;
        rs1_e       <= rs1_d;
        rs2_e       <= rs2_d;
        rd_e        <= rd_d;
    end
end


endmodule