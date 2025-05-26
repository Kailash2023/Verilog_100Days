module tb_bin_ex3();
 reg [3:0]bin_in;
 wire [3:0]ex3_out;
 
 Bin_Ex3 dut(bin_in, ex3_out);
 
 always 
 begin
    bin_in = $random;
    #10;
 end
 
 initial begin
    $monitor("binary_input = %b, Excess3_output = %b",bin_in,ex3_out);
    #80 $finish; 
 end 
endmodule
