//******************************************************************************************
// Design: mac_wrapper.sv
// Author:
// Description: wrapper module that connects the mmu unit with the memory
// v 0.1
//******************************************************************************************

import mac_pkg::*;

module mac_wrapper
(
    input  logic        clk_i,
    input  logic  [1:0] opcode_i,
    input  logic [31:0] rs1_i,
    input  logic [31:0] rs2_i,
    input  logic [31:0] rd_i,

    input  logic [31:0] mem_data1_i,    // matrix A elements from memory
    input  logic [31:0] mem_data2_i,
    input  logic [31:0] mem_data3_i,

    input  logic [31:0] mem_data4_i,    // matrix B elements from memory
    input  logic [31:0] mem_data5_i,
    input  logic [31:0] mem_data6_i,

    output logic [31:0] mem_data1_o,    // computed output to memory
    output logic [31:0] mem_data2_o,
    output logic [31:0] mem_data3_o
);

    logic [71:0] matA_i, matB_i;
    logic [71:0] res_o;


    assign matA_i = {mem_data1_i[23:16], mem_data1_i[15:8], mem_data1_i[7:0],
                     mem_data2_i[23:16], mem_data2_i[15:8], mem_data2_i[7:0],
                     mem_data3_i[23:16], mem_data3_i[15:8], mem_data3_i[7:0]};

    assign matB_i = {mem_data4_i[23:16], mem_data4_i[15:8], mem_data4_i[7:0],
                     mem_data5_i[23:16], mem_data5_i[15:8], mem_data5_i[7:0],
                     mem_data6_i[23:16], mem_data6_i[15:8], mem_data6_i[7:0]};


    mmu mmu_instance
    (
        .matrixA_i ( matA_i   ),
        .matrixB_i ( matB_i   ),
        .opcode_i  ( opcode_i ),
        .result_o  ( res_o    )
    );

    assign mem_data1_o = {8'b0, res_o[71:64], res_o[63:56], res_o[55:48]};
    assign mem_data2_o = {8'b0, res_o[47:40], res_o[39:32], res_o[31:24]};
    assign mem_data3_o = {8'b0, res_o[23:16], res_o[15:8],  res_o[7:0]};

endmodule
