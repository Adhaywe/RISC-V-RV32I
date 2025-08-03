
import mac_pkg::*;

module tb;

    logic                  clk_i;
    logic                  rst_i;
    logic                  enable_i;
    logic                  clr_i;
    logic [DATA_WIDTH-1:0] matrixA_i;
    logic [DATA_WIDTH-1:0] matrixB_i;
    logic [           1:0] opcode_i;
    logic [DATA_WIDTH-1:0] result_o;

    // Instantiate the mac module
    mac mac_inst (
        .clk_i    (clk_i),
        .rst_i    (rst_i),
        .enable_i (enable_i),
        .clr_i    (clr_i),
        .matrixA_i(matrixA_i),
        .matrixB_i(matrixB_i),
        .opcode_i (opcode_i),
        .result_o (result_o)
    );

    logic [VAR_WIDTH-1:0] acc_result [MAT_SIZE-1:0][MAT_SIZE-1:0];

   
    always #5 clk_i = ~clk_i; 

   
    initial begin
        clk_i = 0;
        rst_i = 0;
        enable_i = 0;
        clr_i = 0;
        opcode_i = 2'b00;

       
        matrixA_i = {
            8'd1, 8'd2, 8'd3,
            8'd5, 8'd4, 8'd3,
            8'd1, 8'd0, 8'd1
        };

        matrixB_i = {
            8'd1, 8'd2, 8'd3,
            8'd5, 8'd4, 8'd3,
            8'd1, 8'd0, 8'd1
        };

      
        rst_i = 1;
        #10;
        rst_i = 0;

        // ADD operation (opcode_i: 2'b00)
        opcode_i = 2'b00; 
        clr_i = 0;
        #10000;

        $display("ADD Operation Passed!");
        for(int i=0; i<MAT_SIZE; i++)begin
            for(int j=0; j<MAT_SIZE; j++)begin
                $display("add result[%0d][%0d] = %d", i, j, mac_inst.add_result[i][j]);
            end
        end

        // SUB operation (opcode_i: 2'b01)
        opcode_i = 2'b01;
        #10000;

        $display("SUB Operation Passed!");
        for(int i=0; i<MAT_SIZE; i++)begin
            for(int j=0; j<MAT_SIZE; j++)begin
                $display("sub result[%0d][%0d] = %d", i, j, mac_inst.sub_result[i][j]);
            end
        end

        //MUL operation (opcode_i: 2'b10)
        opcode_i = 2'b10;
        #10000;

        $display("MUL Operation Result:");
        for(int i=0; i<MAT_SIZE; i++)begin
            for(int j=0; j<MAT_SIZE; j++)begin
                $display("mul result[%0d][%0d] = %d", i, j, mac_inst.mul_result[i][j]);
            end
        end

        $stop;
    end
endmodule
