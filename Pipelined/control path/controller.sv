//******************************************************************************************
// Design: controller.sv
// Author: Adam 
// Description: controller - wrapper module
// v 0.1
//******************************************************************************************
import types ::*;


module controller (
    input               clk, rst, flush_e,
    input logic [31:0] 	instr_d,
    input logic 		zero_e,

    //output
    output logic [2:0]  imm_src_d,
    output logic 		pc_src_e,
    output logic     	alu_src_b_e,
    output logic    	alu_src_a_e,        //check bit width for a and b
    output alu_op_t 	alu_op_e,
    output mac_op_t     mac_op_e,
    output mac_op_t     mac_op_m,
    output logic        mac_write_m,
    output logic 		mem_write_m,
    output logic 		reg_write_w,
    output logic        reg_write_m,
    output logic [1:0]  result_src_e,
    output logic [1:0]  result_src_w

    //to be extended for hazard handling processes
);

//internal signals
logic [6:0] op_d;           // opcode
logic [2:0] funct3_d;       // function 3
logic       funct7b5_d;     // function 7

assign op_d       = instr_d[6:0];
assign funct3_d   = instr_d[14:12];
assign funct7b5_d = instr_d[30];


// decode stage signals
logic 		  reg_write_d;
logic [1:0]   result_src_d;
logic 		  mem_write_d;
logic 		  jump_d;
logic         branch_d;
alu_control_t alu_control_d;
mac_control_t mac_control_d;
logic         mac_write_d;

logic         alu_src_a_d;
logic         alu_src_b_d;

alu_op_t      alu_op_d;
mac_op_t      mac_op_d;

// execute stage
logic 		  reg_write_e;
logic 		  mem_write_e;
logic 		  jump_e;
logic         branch_e;



maindec md_instance
(
    .op          ( op_d          ),
    .result_src  ( result_src_d  ),
    .mem_write   ( mem_write_d   ),
    .branch      ( branch_d      ),
    .alu_src_a   ( alu_src_a_d   ),
    .alu_src_b   ( alu_src_b_d   ),
    .reg_write   ( reg_write_d   ),
    .jump        ( jump_d        ),
    .imm_src     ( imm_src_d     ),
    .alu_control ( alu_control_d ),
    .mac_control ( mac_control_d ),
    .mac_write   ( mac_write_d   )
);

aludec ad_instance (
    .funct3      ( funct3_d      ),
    .funct7b5    ( funct7b5_d    ),
    .alu_control ( alu_control_d ),
    .alu_op      ( alu_op_d      )
);


macdec macdec_inst
(
    .mac_control (mac_control_d),
    .mac_op      (mac_op_d)
);


control_de_ex_stage c_d_e_reg_instance
(
    .clk          ( clk          ),
    .rst          ( rst          ),
    .clr          ( flush_e      ),
    .reg_write_d  ( reg_write_d  ),
    .mem_write_d  ( mem_write_d  ),
    .jump_d       ( jump_d       ),
    .branch_d     ( branch_d     ),
    .result_src_d ( result_src_d ),
    .alu_src_a_d  ( alu_src_a_d  ),
    .alu_src_b_d  ( alu_src_b_d  ),
    .alu_op_d     ( alu_op_d     ),
    .mac_op_d     ( mac_op_d     ),
    .mac_write_d  ( mac_write_d  ),
    .reg_write_e  ( reg_write_e  ),
    .mem_write_e  ( mem_write_e  ),
    .jump_e       ( jump_e       ),
    .branch_e     ( branch_e     ),
    .result_src_e ( result_src_e ),
    .alu_src_a_e  ( alu_src_a_e  ),
    .alu_src_b_e  ( alu_src_b_e  ),
    .alu_op_e     ( alu_op_e     ),
    .mac_op_e     ( mac_op_e     ),
    .mac_write_e  ( mac_write_e  )
);


// execute stage

logic [1:0] result_src_m;

assign pc_src_e = (branch_e & zero_e) | jump_e;

control_ex_mem_stage c_e_m_reg_instance (
    .clk          ( clk          ),
    .rst          ( rst          ),
    .reg_write_e  ( reg_write_e  ),
    .mem_write_e  ( mem_write_e  ),
    .mac_op_e     ( mac_op_e     ),
    .result_src_e ( result_src_e ),
    .mac_write_e  ( mac_write_e  ),
    .reg_write_m  ( reg_write_m  ),
    .mem_write_m  ( mem_write_m  ),
    .result_src_m ( result_src_m ),
    .mac_write_m  ( mac_write_m  ),
    .mac_op_m     ( mac_op_m     )
);


//memory stage

control_mem_wb_stage c_m_w_reg_instance (
    .clk          ( clk          ),
    .rst          ( rst          ),
    .reg_write_m  ( reg_write_m  ),
    .result_src_m ( result_src_m ),
    .reg_write_w  ( reg_write_w  ),
    .result_src_w ( result_src_w )
);


endmodule
