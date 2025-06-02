//******************************************************************************************
// Design: if_id_stage.sv
// Author: Adam 
// Description: pipeline register between instruction fetch and decode stages
// v 0.1
//******************************************************************************************


module if_id_stage (
       input logic         clk, en, clr, rst,

       //input
       input logic [31:0]  pc_f, pc_plus_4_f, instr_f,

       //output
       output logic [31:0] pc_d, pc_plus_4_d, instr_d
);


always_ff @ (posedge clk or posedge rst)
begin
    if (rst) begin
        pc_d        <= 0;
        pc_plus_4_d <= 0;
        instr_d     <= 0;
    end
    else if (en) begin
        if (clr) begin
            pc_d        <= 0;
            pc_plus_4_d <= 0;
            instr_d     <= 0;
        end
        else begin
            pc_d        <= pc_f;
            pc_plus_4_d <= pc_plus_4_f;
            instr_d     <= instr_f;
        end
    end 
end

endmodule