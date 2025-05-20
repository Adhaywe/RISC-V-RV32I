//******************************************************************************************
// Design: top.sv
// Author: Adam 
// Description: Pipelined RISC-V design
// v 0.1
//******************************************************************************************



module top (
       input logic         clk, rst,
       output logic [31:0] write_data_m, data_addr_m,
       output logic        mem_write
);

logic [31:0] pc_f, instr_f, read_data_m;

//instantiate processor and memories    

riscvpipelined rvpipe_instance (
            .clk(clk), 
            .rst(rst), 
            .pc_f(pc_f), 
            .instr_f(instr_f),
            .mem_write(mem_write),
            .data_addr_m(data_addr_m),
            .write_data_m(write_data_m),
            .read_data_m(read_data_m)
);
                    
imem imem (
           .a(pc_f), 
           .rd(instr_f)
);

dmem dmem (
           .clk(clk), 
           .we(mem_write),
           .a(data_addr_m), 
           .wd(write_data_m), 
           .rd(read_data_m)
);

endmodule