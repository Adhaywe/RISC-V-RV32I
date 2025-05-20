module regfile_tb();
  logic clk, reset, we3;
  logic [5:0] a1, a2, a3;
  logic [31:0] wd3;
  logic [31:0] rd1, rd2, rd1_expected, rd2_expected;
  logic [31:0] vectornum, errors;

  regfile dut (.*);

  initial
  begin
    clk = 0; 
    forever #5; 
        clk = ~clk;
  end

  // Test Procedure
  initial 
  begin
    vectornum = 0;
    errors = 0;
    reset = 1;
    #22; 
    reset = 0;


    repeat(1000) 
    begin
        we3 = $urandom % 2;
        a1 = $urandom % 32;
        a2 = $urandom % 32;
        a3 = ($urandom % 31) + 1;
        wd3 = $urandom;

        if (we3) begin
           dut.rf[a3] <= wd3;
        end

        #10

        rd1_expected = (a1 != 0) ? dut.rf[a1] : 0;
        rd2_expected = (a2 != 0) ? dut.rf[a2] : 0;

        if (rd1 != rd1_expected | rd2!= rd2_expected) begin
            $display("Error at vector %d: Inputs = we3=%b, a1=%d, a2=%d, a3=%d, wd3=%h", 
                  vectornum, we3, a1, a2, a3, wd3);
            $display("Outputs = rd1=%h, rd2=%h (Expected: rd1=%h, rd2=%h)", 
                  rd1, rd2, rd1_expected, rd2_expected);
            errors = errors + 1;
            end
            vectornum++;
    end

   $display("%d tests completed with %d errors", vectornum, errors);
   $stop;

  end

endmodule








