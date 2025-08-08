//******************************************************************************************
// Design: regfile.sv
// Author: Adam 
// Description: register file
// v 0.1
//******************************************************************************************



module regfile (input  logic         clk,
                input  logic         we3,
                input  logic [ 4:0]  a1, a2, a3, a4, a5, a6, a7,
                input  logic [31:0]  wd3,
                output logic [31:0]  rd1, rd2, rd4, rd5, rd6, rd7, rd8
);

logic [31:0] rf [31:0];

// we can write into the registers on the rising edge of the clock <-- sequential logic
// and reading from 2 addresses at anytime is possible <-- combinational logic

always_ff @(posedge clk)
begin
 if (we3)
    rf[a3] <= wd3;
end

//assign rd1 = (a1 != 0) ? rf[a1] : 0;
//assign rd2 = (a2 != 0) ? rf[a2] : 0;

//bypass logic - writing on posedge and reading before the value is committed
assign rd1 = (a1 == a3 && we3) ? wd3 : ((a1 != 0) ? rf[a1] : 0);
assign rd2 = (a2 == a3 && we3) ? wd3 : ((a2 != 0) ? rf[a2] : 0);

// multiport reg
assign rd4 = (a4 == a3 && we3) ? wd3 : ((a4 != 0) ? rf[a4] : 0);
assign rd5 = (a5 == a3 && we3) ? wd3 : ((a5 != 0) ? rf[a5] : 0);
assign rd6 = (a6 == a3 && we3) ? wd3 : ((a6 != 0) ? rf[a6] : 0);
assign rd7 = (a7 == a3 && we3) ? wd3 : ((a7 != 0) ? rf[a7] : 0);
assign rd8 = (a3 == a3 && we3) ? wd3 : ((a3 != 0) ? rf[a3] : 0);


endmodule