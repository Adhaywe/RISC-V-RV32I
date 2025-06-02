//******************************************************************************************
// Design: imem.sv
// Author: Adam 
// Description: instruction
// v 0.1
//******************************************************************************************



module imem (input logic [31:0]  a,
             output logic [31:0] rd
             );

logic [31:0] RAM [63:0];

initial
   $readmemh("riscvtest.hex", RAM);

assign rd = RAM[a[31:2]]; //word aligned

endmodule