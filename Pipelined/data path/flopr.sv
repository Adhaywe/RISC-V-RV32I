//******************************************************************************************
// Design: flopr.sv
// Author: Adam 
// Description: flopr 
// v 0.1
//******************************************************************************************



module flopr #(
   parameter WIDTH = 32
   )
     (
      input  logic             clk, rst, en,
      input  logic [WIDTH-1:0] d,
      output logic [WIDTH-1:0] q
);


always_ff @(posedge clk, posedge rst)
   if (rst)
      q <= 0;
   else if (en)
      q <= d;

endmodule