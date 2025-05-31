//******************************************************************************************
// Design: types.sv
// Author: Adam 
// Description: package
// v 0.1
//******************************************************************************************


package types;

    typedef enum logic [3:0] {
        ADD  = 4'd0,
        SUB  = 4'd1,
        AND  = 4'd2,
        OR   = 4'd3,
        SLT  = 4'd4,
        SLTU = 4'd5,
        SGE  = 4'd6,
        SGEU = 4'd7,
        XOR  = 4'd8,
        SLL  = 4'd9,
        SRL  = 4'd10,
        SRA  = 4'd11
} alu_op_t;

   typedef enum logic [2:0] {
        ALU_CONTROL_ADD   = 3'd0,
        ALU_CONTROL_SUB   = 3'd1,
        ALU_CONTROL_ITYPE = 3'd2,
        ALU_CONTROL_RTYPE = 3'd3,
        ALU_CONTROL_BTYPE = 3'd4
} alu_control_t;


    typedef enum logic [1:0] {
        FORWARD_NONE = 2'd0,
        FORWARD_WB   = 2'd1,
        FORWARD_MEM  = 2'd2 
    } forward_t;



endpackage