//******************************************************************************************
// Design: mux3.sv
// Author: Adam 
// Description: mux3
// v 0.1
//******************************************************************************************
 
 
module mux3 #(
    parameter WIDTH = 32
)
(
    input  logic [WIDTH-1:0]  d0, d1, d2,
    input  logic [      1:0]  s,
    output logic [WIDTH-1:0]  y
);


assign y = s[1] ? d2 : (s[0] ? d1 : d0);

endmodule