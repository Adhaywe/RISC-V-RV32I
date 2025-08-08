//******************************************************************************************
// Design: dmem.sv
// Author: Adam
// Description: data memory
// v 0.1
//******************************************************************************************



module dmem (input  logic         clk, we,
             input  logic [31:0]  a, wd,
             output logic [31:0]  rd
            );

logic [31:0] RAM [127:0]; // changed from 63 to 127

assign rd = RAM[a[31:2]];

always_ff @(posedge clk)
    if (we)
      RAM[a[31:2]] <= wd;



initial begin
  $readmemh("C:/Users/Adam/Downloads/PortableGit/RISC-V-RV32I/Pipelined/data path/dmem.hex", RAM);
end


endmodule
