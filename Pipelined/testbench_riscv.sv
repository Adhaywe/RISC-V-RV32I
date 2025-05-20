//******************************************************************************************
// Design: testbench.sv
// Author: Adam 
// Description: testbench for ad hoc testing
// v 0.1
//******************************************************************************************


module testbench_riscv();
	
	logic clk, rst;
	logic [31:0] write_data_m, data_addr_m;
	logic mem_write;
  
	top dut (
	  .clk(clk),
	  .rst(rst),
	  .write_data_m(write_data_m),
	  .data_addr_m(data_addr_m),
	  .mem_write(mem_write)
	);
  
	// Clock generator
	always #5 clk = ~clk;
  
	initial begin
	  // Init signals
	  clk = 0;
	  rst = 1;
	  #20;
	  rst = 0;
  
	  // Run simulation
	  #200; // Adjust based on instruction count
	  $display("Test start");
	end
  
	// Optional: monitor memory writes
	always @(posedge clk) begin
	  if (mem_write) begin
		$display("Time: %0t | MEM WRITE to %h = %h", $time, data_addr_m, write_data_m);
	  end
	end
  
  endmodule
  

