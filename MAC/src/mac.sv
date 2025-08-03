//******************************************************************************************
// Design: mac.sv
// Author: 
// Description: 3X3 matrix addition, subtraction and multiplication module
// v 0.1
//******************************************************************************************

import mac_pkg::*;

module mac
(
    input  logic                  clk_i,
    input  logic                  rst_i,
    input  logic                  enable_i,
    input  logic                  clr_i,
    input  logic [DATA_WIDTH-1:0] matrixA_i,
    input  logic [DATA_WIDTH-1:0] matrixB_i,
    input  logic [           1:0] opcode_i,
    output logic [DATA_WIDTH-1:0] result_o
);

// temp local variables
   logic [VAR_WIDTH-1:0] A1         [MAT_SIZE-1:0][MAT_SIZE-1:0]; // [bit width] A1 [MAT_SIZE X MAT_SIZE] (2D array)
   logic [VAR_WIDTH-1:0] B1         [MAT_SIZE-1:0][MAT_SIZE-1:0];
   logic [VAR_WIDTH-1:0] add_result [MAT_SIZE-1:0][MAT_SIZE-1:0];
   logic [VAR_WIDTH-1:0] sub_result [MAT_SIZE-1:0][MAT_SIZE-1:0];
   logic [VAR_WIDTH-1:0] mul_result [MAT_SIZE-1:0][MAT_SIZE-1:0];

   int i, j, k;

   always_comb begin
    // initialize the variables
    i = 0;
    j = 0;
    k = 0;

    // convert 1D input to 2D arrays
    {A1[0][0], A1[0][1], A1[0][2],
     A1[1][0], A1[1][1], A1[1][2],
     A1[2][0], A1[2][1], A1[2][2]} = matrixA_i;

    {B1[0][0], B1[0][1], B1[0][2],
     B1[1][0], B1[1][1], B1[1][2],
     B1[2][0], B1[2][1], B1[2][2]} = matrixB_i;

    // Initialize tmep registers to zero
    for(i=0; i<MAT_SIZE; i++) begin
       for(j=0; j<MAT_SIZE; j++) begin
        sub_result[i][j] = 8'd0;
        add_result[i][j] = 8'd0;
        mul_result[i][j] = 8'd0;
       end
    end


     unique case(opcode_i)
        2'b00:
            for(i=0; i<MAT_SIZE; i++)
                for(j=0; j<MAT_SIZE; j++)
                    add_result[i][j] = A1[i][j] + B1[i][j];

        2'b01:
            for(i=0; i<MAT_SIZE; i++)
                for(j=0; j<MAT_SIZE; j++)
                    sub_result[i][j] = A1[i][j] - B1[i][j];

        2'b10,
        2'b11:
            for(i=0; i<MAT_SIZE; i++)
                for(j=0; j<MAT_SIZE; j++)
                    for(k=0; k<MAT_SIZE; k++)
                        mul_result[i][j] = mul_result[i][j] + (A1[i][k] * B1[k][j]);

        default: ;
    endcase
    end

    logic [DATA_WIDTH-1:0] accumulator;
    logic [DATA_WIDTH-1:0] temp_mul_result;
    logic [DATA_WIDTH-1:0] temp_add_result;
    logic [DATA_WIDTH-1:0] temp_sub_result;


    // flatten result back to 1 D

    assign temp_mul_result = {mul_result[0][0], mul_result[0][1], mul_result[0][2],
                              mul_result[1][0], mul_result[1][1], mul_result[1][2],
                              mul_result[2][0], mul_result[2][1], mul_result[2][2]};

    assign temp_add_result = {add_result[0][0], add_result[0][1], add_result[0][2],
                              add_result[1][0], add_result[1][1], add_result[1][2],
                              add_result[2][0], add_result[2][1], add_result[2][2]};

    assign temp_sub_result = {sub_result[0][0], sub_result[0][1], sub_result[0][2],
                              sub_result[1][0], sub_result[1][1], sub_result[1][2],
                              sub_result[2][0], sub_result[2][1], sub_result[2][2]};



    always_ff @(posedge clk_i)
        if (rst_i)
           accumulator <= '0;
        else if (clr_i)
           accumulator <= '0;
        else
           accumulator <= temp_mul_result;


   // ------------------------------- result mux ------------------------------------
    always_comb begin
        result_o = '0;

        unique case(opcode_i)

         ADD: result_o = temp_add_result;
         SUB: result_o = temp_sub_result;
         MUL: result_o = enable_i ? accumulator + temp_mul_result : accumulator;

         default: ;
        endcase
    end
endmodule
