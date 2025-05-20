//******************************************************************************************
// Design: mux2.sv
// Author: Adam 
// Description: mux2
// v 0.1
//******************************************************************************************



module mux2 #(
    parameter WIDTH = 32
)
            (
    input logic [WIDTH-1:0]  d0, d1,
    input logic              s,
    output logic [WIDTH-1:0] y
);


assign y = s ? d1 : d0;

endmodule