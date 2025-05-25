//-----------------------------
// SystemVerilog 
// imem.sv
// 
// instruction memory
// 24.02.2025
//-----------------------------
 


module imem (input logic [31:0] a,
             output logic [31:0] rd
             );

logic [31:0] RAM [63:0];

initial
   $readmemh("C:/Users/Adam/Desktop/ComputerArchitecture/RISC V/riscvtest.hex", RAM);

assign rd = RAM[a[31:2]]; //word aligned

endmodule