//******************************************************************************************
// Design: hazard_unit.sv
// Author: Adam 
// Description: hazard detection unit
//              - solving hazards with forwarding, stalls and flushing
// v 0.1
//******************************************************************************************
import types ::*;

module hazard_unit(
    // source registers
    input logic [4:0]  rs1_addr_e, rs2_addr_e, 

    // destination register from mem stage
    input logic [4:0]  rd_m,
    
    // destination register from writeback stage
    input logic [4:0]  rd_w,

    // register write signals from mem and write back stages
    input logic        reg_write_w, reg_write_m,

    // stall
    input logic  [1:0] result_src_e,  
    input logic  [4:0] rs1_d, rs2_d, rd_e,

    // control hazard
    input logic        pc_src_e,

    // forwarding control signal for src a and b
    output forward_t   forward_a_e, forward_b_e,

    output logic       stall_f, stall_d, flush_e, flush_d
);


logic lwstall;
// solving RAW data hazards with forwarding

always_comb begin
    forward_a_e = FORWARD_NONE;
    forward_b_e = FORWARD_NONE;

    // forwarding logic for rs1
    if (((rs1_addr_e == rd_m) & reg_write_m) & (rs1_addr_e != 0)) 
       forward_a_e = FORWARD_MEM;
    else if (((rs1_addr_e == rd_w) & reg_write_w) & (rs1_addr_e != 0)) 
       forward_a_e = FORWARD_WB;
    else
       forward_a_e = FORWARD_NONE; 


     // forwarding logic for rs2
    if (((rs2_addr_e == rd_m) & reg_write_m) & (rs2_addr_e != 0)) 
       forward_b_e = FORWARD_MEM;
    else if (((rs2_addr_e == rd_w) & reg_write_w) & (rs2_addr_e != 0)) 
       forward_b_e = FORWARD_WB;
    else
       forward_b_e = FORWARD_NONE;
end



// solving data hazards with stalls

assign lwstall = (result_src_e[0] & ((rs1_d == rd_e) | (rs2_d == rd_e)));

assign {stall_f, stall_d} = lwstall ? 2'b11 : 2'b00;


// sovling control hazards

assign flush_d = pc_src_e;
assign flush_e = lwstall | pc_src_e;


endmodule