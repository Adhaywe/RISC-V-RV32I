//-----------------------------
// SystemVerilog 
// testbench
// 
// Single cycle RISC-V design ad hoc testing
// 25.02.2025
//-----------------------------


module testbenc_riscv();

logic clk;
logic reset;
logic [31:0] WriteData, DataAdr, data_expected, addr_expected;
logic MemWrite;

// instantiate device to be tested
top dut (.*);



// generate clock to sequence tests
initial
begin
	clk = 0; 
	forever #5 clk = ~clk;
end

// initialize test
initial
begin
   reset = 1; 
   #22;
   reset = 0;

   data_expected = 25;
   addr_expected = 100;

end

always @(negedge clk)
 begin
   if (MemWrite) 
    begin
		 if (DataAdr == addr_expected & WriteData == data_expected) begin
			$display("Simulation succeeded");
			$stop;
		 end else if (DataAdr != 96) begin
			$display("Simulation failed");
			$stop;
		end
	end
 end

endmodule

