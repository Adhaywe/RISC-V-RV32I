//******************************************************************************************
// Design: datapath.sv
// Author: Adam 
// Description: data path
// v 0.1
//******************************************************************************************
import types ::*;

module datapath (
       // input
   	   input logic        clk, rst,
	   input logic [31:0] instr_f,    //instruction from memory
       input logic [31:0] read_data_m,

	   // output
	   // fetch stage
	   output logic [31:0] pc_f,
       // decode stage
	   output logic [31:0] instr_d,
       // execute stage
	   output logic        zero_e,
	   output logic        mem_write_mac,
       // memory stage
	   output logic [31:0] mem_data_m, // address of the memo location
	   output logic [31:0] mem_addr_m, // data to be written to mem

	   // control signals
       input logic [2:0]   imm_src_d,
	   input logic         pc_src_e,
	   input logic         alu_src_b_e,
	   input alu_op_t      alu_op_e,
	   input mac_op_t      mac_op_d,
	   input mac_op_t      mac_op_e,
	   input mac_op_t      mac_op_m,
	   input logic         reg_write_w,
	   input logic [1:0]   result_src_w,
	   input logic         mac_write_m,

	   // hazard unit
	   output logic [4:0]  rs1_addr_e, rs2_addr_e,
	   output logic [4:0]  rd_m, rd_w, rd_e,

	   output logic [4:0]  rs1_addr_d, rs2_addr_d,

	   input forward_t     forward_a_e, forward_b_e,
	   input logic         stall_f, stall_d, flush_e, flush_d
);

parameter WIDTH = 32;

//fetch stage signals
logic [31:0] pc_next_f, pc_plus_4_f;


// decode stage signals
logic [31:0] rd1, rd2;
logic [31:0] imm_ext_d, rd1_d, rd2_d, rd4_d, rd5_d, rd6_d, rd7_d;
logic [31:0] pc_d, pc_plus_4_d;
logic [4:0]  rs1_e, rs2_e;
logic [4:0]  rs1_d, rs2_d;
logic [4:0]  ra1_d, ra2_d, wa3_d;


logic [31:0] rd4, rd5, rd6, rd7;


// execute stage signals
logic [31:0] pc_target_e;
logic [31:0] rd1_e, rd2_e, pc_e, imm_ext_e, pc_plus_4_e;
logic [31:0] rd4_e, rd5_e, rd6_e, rd7_e;
logic [31:0] rd1_m, rd2_m, rd4_m, rd5_m, rd6_m, rd7_m;
logic [31:0] alu_src_BE, alu_src_BE_E, alu_src_AE, alu_result_e, write_data_e;
// memory stage signals

logic [31:0] alu_result_m, pc_plus_4_m, write_data_m;

// write back
logic [31:0] alu_result_w, read_data_w, pc_plus_4_w;






logic [31:0] result_w;

mux2 # (
	.WIDTH(WIDTH)
)   
   mux2_pc_src (
    .d0 ( pc_plus_4_f ),
	.d1 ( pc_target_e ),
	.s  ( pc_src_e    ),
	.y  ( pc_next_f   )
);

// next pc logic
flopr #(
	.WIDTH(WIDTH)
) 
   pcreg (
	.clk ( clk       ),
    .rst ( rst       ),
	.en  ( ~stall_f  ),
	.d   ( pc_next_f ),
	.q   ( pc_f      )
);
 
adder pcadd4 (
	.a ( pc_f        ),
    .b ( 32'd4       ),
	.y ( pc_plus_4_f )
);

if_id_stage f_d_stage_instance (
	.clk         ( clk         ),
	.en          ( ~stall_d    ),
	.rst         ( rst         ),
	.clr         ( flush_d     ),
	.pc_f        ( pc_f        ),
	.pc_plus_4_f ( pc_plus_4_f ),
	.instr_f     ( instr_f     ),
	.pc_d        ( pc_d        ),
	.pc_plus_4_d ( pc_plus_4_d ),
	.instr_d     ( instr_d     )
);


// decode stage

// register file logic

assign ra1_d = instr_d[19:15];
assign ra2_d = instr_d[24:20];
assign wa3_d = instr_d[11:7];



assign rs1_d = ra1_d;
assign rs2_d = ra2_d;

assign rs1_addr_d = ra1_d;
assign rs2_addr_d = ra2_d;


logic [31:0] matA_row1;
logic [31:0] matA_row2;
logic [31:0] matA_row3;

logic [31:0] matB_row1;
logic [31:0] matB_row2;
logic [31:0] matB_row3;

logic [31:0] baddr, baddr_d, baddr_e, baddr_m;



regfile rf_instance (
	.clk ( clk         ),
    .we3 ( reg_write_w ),
	.a1  ( ra1_d       ),
	.a2  ( ra2_d       ),
	.a3  ( rd_w        ),
	.a4  ( ra1_d+5'd1  ),
	.a5  ( ra1_d+5'd2  ),
	.a6  ( ra2_d+5'd1  ),
	.a7  ( ra2_d+5'd2  ),
	.wd3 ( result_w    ),
	.rd1 ( rd1         ),
	.rd2 ( rd2         ),
	.rd4 ( rd4         ),
	.rd5 ( rd5         ),
	.rd6 ( rd6         ),
	.rd7 ( rd7         ),
	.rd8 ( baddr       )
);

assign rd1_d   = rd1;
assign rd2_d   = rd2;

assign rd4_d   = rd4;
assign rd5_d   = rd5;
assign rd6_d   = rd6;
assign rd7_d   = rd7;
assign baddr_d = baddr;



extend ext_instance (
	.instr   ( instr_d[31:7] ),
    .imm_src ( imm_src_d     ),
	.imm_ext ( imm_ext_d     )
);

id_ex_stage d_e_stage_instance (
	.clk         ( clk         ), 
	.rst         ( rst         ), 
	.clr         ( flush_e     ),
	.rd1_d       ( rd1_d       ),
	.rd2_d       ( rd2_d       ), 
	.rd4_d       ( rd4_d       ),
	.rd5_d       ( rd5_d       ),
	.rd6_d       ( rd6_d       ),
	.rd7_d       ( rd7_d       ),
	.baddr_d     ( baddr_d     ),
	.pc_d        ( pc_d        ),
	.imm_ext_d   ( imm_ext_d   ),
	.pc_plus_4_d ( pc_plus_4_d ),
	.rs1_d       ( rs1_d       ),
	.rs2_d       ( rs2_d       ),
	.rd_d        ( wa3_d       ),
	.rd1_e       ( rd1_e       ),
	.rd2_e		 ( rd2_e       ),
	.rd4_e       ( rd4_e       ),
	.rd5_e       ( rd5_e       ),
	.rd6_e       ( rd6_e       ),
	.rd7_e       ( rd7_e       ),
	.baddr_e     ( baddr_e     ),
	.pc_e        ( pc_e        ),
	.imm_ext_e   ( imm_ext_e   ),
	.pc_plus_4_e ( pc_plus_4_e ),
	.rs1_e       ( rs1_e       ),            // to hazard unit 
	.rs2_e       ( rs2_e       ),            // to hazard unit 
	.rd_e        ( rd_e        )
);


assign rs1_addr_e = rs1_e;
assign rs2_addr_e = rs2_e;


// execute memory stage
adder pcaddbranch (
	.a ( pc_e        ),
    .b ( imm_ext_e   ),
    .y ( pc_target_e )
);



// --------- forwarding mux -----------------


mux3 # (
	.WIDTH(WIDTH)
) 
    rd1_select_mux (
	.d0 ( rd1_e        ), 
    .d1 ( result_w     ), 
    .d2 ( alu_result_m ), 
	.s  ( forward_a_e  ), 
	.y  ( alu_src_AE   )
);


mux3 # (
	.WIDTH(WIDTH)
) 
    rd2_select_mux (
	.d0 ( rd2_e        ), 
    .d1 ( result_w     ), 
    .d2 ( alu_result_m ), 
	.s  ( forward_b_e  ), 
	.y  ( alu_src_BE   )
);


assign write_data_e = alu_src_BE;

//--------------------------------

// ALU logic

mux2 # (
	.WIDTH(WIDTH)
) 
    alu_src_b_mux (
	.d0 ( alu_src_BE   ), 
    .d1 ( imm_ext_e    ), 
	.s  ( alu_src_b_e  ), 
	.y  ( alu_src_BE_E )
);


alu al (
	.a          ( alu_src_AE   ), 
    .b          ( alu_src_BE_E ), 
    .alu_op     ( alu_op_e     ), 
	.alu_result ( alu_result_e ), 
    .zero       ( zero_e       )       // zero flag - branch/jump
);



ex_mem_stage ex_m_stage_instance
(
	.clk            ( clk            ),
	.rst            ( rst            ),
	.alu_result_e   ( alu_result_e   ),
	.write_data_e   ( write_data_e   ),
	.pc_plus_4_e    ( pc_plus_4_e    ),
	.rd_e           ( rd_e           ),
	.rd1_e          ( rd1_e          ),
	.rd2_e          ( rd2_e          ), 
	.rd4_e          ( rd4_e          ),
	.rd5_e          ( rd5_e          ),
	.rd6_e          ( rd6_e          ),
	.rd7_e          ( rd7_e          ),
	.baddr_e        ( baddr_e        ),
 	.alu_result_m   ( alu_result_m   ),
	.write_data_m   ( write_data_m   ),
	.pc_plus_4_m    ( pc_plus_4_m    ),
	.rd_m           ( rd_m           ),
	.rd1_m          ( rd1_m          ),
	.rd2_m          ( rd2_m          ),
	.rd4_m          ( rd4_m          ),
	.rd5_m          ( rd5_m          ),
	.rd6_m          ( rd6_m          ),
	.rd7_m          ( rd7_m          ),
	.baddr_m        ( baddr_m        )
);


assign matA_row1 =  rd1_m;
assign matA_row2 =  rd4_m;
assign matA_row3 =  rd5_m;
assign matB_row1 =  rd2_m;
assign matB_row2 =  rd6_m;
assign matB_row3 =  rd7_m;

logic [31:0] BaseAddr;
assign BaseAddr = baddr_m;





logic [31:0] mac_result_1_m, mac_result_2_m, mac_result_3_m;


mac_wrapper mac_wrapper_inst
(
    .mac_op      ( mac_op_m       ),
    .mem_data1_i ( matA_row1      ),    // matrix A elements from memory
    .mem_data2_i ( matA_row2      ),
    .mem_data3_i ( matA_row3      ),
    .mem_data4_i ( matB_row1      ),    // matrix B elements from memory
    .mem_data5_i ( matB_row2      ),
    .mem_data6_i ( matB_row3      ),
    .mem_data1_o ( mac_result_1_m ),    // computed output to memory
    .mem_data2_o ( mac_result_2_m ),
    .mem_data3_o ( mac_result_3_m )
);





logic [1:0]  mac_write_cnt;
logic [31:0] mac_result [0:2];
logic        mac_write_active;

always_ff @(posedge clk or posedge rst) begin
	if (rst) begin
		mac_write_cnt    <= 0;
		mac_write_active <= 0;
		mac_result[0]    <= 0;
		mac_result[1]    <= 0;
		mac_result[2]    <= 0;
	end
	else begin
		if (mac_write_m) begin
			mac_write_cnt    <= 0;
			mac_write_active <= 1;
			mac_result[0]    <= mac_result_1_m;
			mac_result[1]    <= mac_result_2_m;
			mac_result[2]    <= mac_result_3_m;
	    end
		else if (mac_write_active) begin
			if (mac_write_cnt == 2) begin
				mac_write_cnt    <= 0;
				mac_write_active <= 0;
			end
			else begin
				mac_write_cnt <= mac_write_cnt + 1;
			end
		end
    end
end

assign mem_addr_m    = mac_write_active ? (BaseAddr + mac_write_cnt*4) : alu_result_m;
assign mem_data_m    = mac_write_active ? mac_result[mac_write_cnt] : write_data_m;
assign mem_write_mac = mac_write_active;

//assign mem_addr_m = alu_result_m;
//assign mem_data_m = write_data_m;




// memory write back stage


imem_wb_stage m_w_stage_instance (
	.clk          ( clk          ),
	.rst          ( rst          ),
	.alu_result_m ( alu_result_m ),
	.read_data_m  ( read_data_m  ),
	.rd_m         ( rd_m         ),
	.pc_plus_4_m  ( pc_plus_4_m  ),
	.alu_result_w ( alu_result_w ),
	.read_data_w  ( read_data_w  ),
	.rd_w         ( rd_w         ),
	.pc_plus_4_w  ( pc_plus_4_w  )
);




mux3 # (
	.WIDTH(WIDTH)
) 
    resultmux (
	.d0 ( alu_result_w ),
    .d1 ( read_data_w  ),
    .d2 ( pc_plus_4_w  ),
	.s  ( result_src_w ),
	.y  ( result_w     )
);






endmodule
