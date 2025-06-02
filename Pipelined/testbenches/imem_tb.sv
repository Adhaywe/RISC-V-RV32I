module imem_tb();

    logic [31:0] addr;
    logic [31:0] rd;
    logic [31:0] a;

    logic [31:0] x [3:0];     //unpacked 4 arrays each a 32 bit width 
  
    int errors = 0;
    // i;
    // Instantiate the imem
    imem dut (.*);
  
    // Reference values expected from riscvtest.hex
    logic [31:0] expected_mem [31:0];
  
    initial begin
      // Load expected contents
      $readmemh("riscvtest.hex", expected_mem);
  
      // Wait for memory to initialize
      #10;

      x[0] = 32'h00000093;    //check the index
      x[1] = 32'h00100113;
      x[2] = 32'h002081b3;
      x[3] = 32'h0001a103;

  
      // Loop through a few locations
      for (int i = 0; i <= 4; i++) begin
      
        #1;           // wait for read to settle (combinational)
        
        if (x[i] !== expected_mem[i]) begin
          $display("ERROR at addr %0d: got %p, expected %h", addr, x[i], expected_mem[i]);
          errors++;
        end else begin
          $display("PASS at addr %0d: %p", addr, x);
        end
      end
  
      if (errors == 0)
        $display( "All tests passed!");
      else
        $display(" %0d test(s) failed.", errors);
  
      $finish;
    end
  
endmodule
  