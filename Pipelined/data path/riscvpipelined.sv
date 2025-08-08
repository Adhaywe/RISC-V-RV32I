//******************************************************************************************
// Design: riscvpipelined.sv
// Author: Adam 
// Description: Pipelined RISC-V design
// v 0.1
//******************************************************************************************
import types ::*;

module riscvpipelined (
	    input logic		    clk, rst,
		input logic [31:0]  read_data_m,
		input logic [31:0]  instr_f,

		//output
		output logic [31:0] pc_f,
	    output logic 		mem_write,
		output logic [31:0] data_addr_m,
		output logic [31:0] write_data_m
		
);

logic [31:0] instr_d;

logic [2:0]	 imm_src_d;
logic		 pc_src_e;
logic 		 zero_e;
logic        alu_src_b_e;
logic        alu_src_a_e;      
logic 		 reg_write_w;
logic        reg_write_m;
logic [1:0]  result_src_e;
logic [1:0]  result_src_w;
alu_op_t     alu_op_e;
mac_op_t     mac_op_e, mac_op_d;
mac_op_t     mac_op_m;
logic        mac_write_m;
logic        mem_write_ctrl;
logic        mem_write_mac;


// hazard unit

logic [4:0]  rs1_addr_e, rs2_addr_e;
logic [4:0]  rs1_addr_d, rs2_addr_d;
logic [4:0]  rd_e;
logic [4:0]  rd_m;
logic [4:0]  rd_w;
forward_t    forward_a_e, forward_b_e;
logic        stall_f, stall_d, flush_e, flush_d;


			  
controller control_unit_instance (
	   .clk			 ( clk			 ),
	   .rst			 ( rst		     ),
	   .flush_e		 ( flush_e       ),
	   .instr_d      ( instr_d       ),
	   .zero_e		 ( zero_e        ),
	   .imm_src_d	 ( imm_src_d     ),
	   .pc_src_e	 ( pc_src_e      ),
	   .alu_src_b_e	 ( alu_src_b_e   ),
	   .alu_src_a_e	 ( alu_src_a_e   ),
	   .alu_op_e  	 ( alu_op_e      ),
	   .mem_write_m  ( mem_write_ctrl),
	   .reg_write_w  ( reg_write_w   ),
	   .reg_write_m  ( reg_write_m   ),
	   .result_src_e ( result_src_e  ),
	   .result_src_w ( result_src_w  ),
	   .mac_op_e     ( mac_op_e      ),
	   .mac_op_m     ( mac_op_m      ),
       .mac_write_m  ( mac_write_m   )
);			  

datapath dp_instance (
	    .clk          ( clk          ), 
        .rst          ( rst          ),
		.instr_f      ( instr_f      ),
		.read_data_m  ( read_data_m  ),
		.pc_f         ( pc_f         ),
		.instr_d      ( instr_d      ),
		.zero_e       ( zero_e       ),
		.mem_data_m   ( write_data_m ),
		.mem_addr_m   ( data_addr_m  ),
		.imm_src_d    ( imm_src_d    ),
		.pc_src_e     ( pc_src_e     ),
		.alu_src_b_e  ( alu_src_b_e  ),		
		.alu_op_e     ( alu_op_e     ),
		.reg_write_w  ( reg_write_w  ),
		.result_src_w ( result_src_w ),
		.rs1_addr_e   ( rs1_addr_e   ), 
		.rs2_addr_e   ( rs2_addr_e   ),
		.rd_m		  ( rd_m         ),
		.rd_w         ( rd_w         ), 
		.rd_e         ( rd_e         ),
		.rs1_addr_d   ( rs1_addr_d   ), 
		.rs2_addr_d   ( rs2_addr_d   ), 
		.forward_a_e  ( forward_a_e  ), 
		.forward_b_e  ( forward_b_e  ),
		.stall_d      ( stall_d      ),
		.stall_f      ( stall_f      ), 
		.flush_e      ( flush_e      ), 
		.flush_d      ( flush_d      ),
		.mac_op_d     ( mac_op_d     ),
		.mac_op_e     ( mac_op_e     ),
		.mac_op_m     ( mac_op_m     ),
		.mac_write_m  ( mac_write_m  ),
		.mem_write_mac( mem_write_mac)
);

assign mem_write = mem_write_ctrl | mem_write_mac;

hazard_unit hazard_unit_instance (
	  .rs1_addr_e   ( rs1_addr_e   ),
	  .rs2_addr_e   ( rs2_addr_e   ),
	  .instr_d      ( instr_d      ),
	  .rd_m         ( rd_m         ),
	  .rd_w         ( rd_w         ),
	  .reg_write_m  ( reg_write_m  ),
	  .reg_write_w  ( reg_write_w  ),
	  .result_src_e ( result_src_e ),
	  .rs1_d		( rs1_addr_d   ),
	  .rs2_d		( rs2_addr_d   ),
	  .rd_e		    ( rd_e         ),
	  .pc_src_e     ( pc_src_e     ),
	  .forward_a_e  ( forward_a_e  ),
	  .forward_b_e  ( forward_b_e  ),
	  .stall_f      ( stall_f      ),
	  .stall_d      ( stall_d      ),
	  .flush_e      ( flush_e      ),
	  .flush_d      ( flush_d      )
);



endmodule