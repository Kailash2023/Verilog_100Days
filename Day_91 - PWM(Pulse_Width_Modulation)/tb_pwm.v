`timescale 1ns / 1ps

module test_bench;

  // Testbench signals
  reg clk;
  reg rst;
  wire dout;

  // Instantiate the module under test
  PWM uut (
    .clk(clk),
    .rst(rst),
    .dout(dout)
  );

  // Clock generation: 10ns period
  always #5 clk = ~clk;

  initial begin
    // Initialize signals
    clk = 0;
    rst = 1;

    // Apply reset
    #20 rst = 0;

    // Run simulation
    #200 $finish;
  end

  // Monitor output
  initial begin
    $monitor("Time: %0t | rst: %b | dout: %b", $time, rst, dout);
  end

endmodule