module tb_special_gates();

 reg a,b;
 wire g_xor,g_xnor;
 
 Special_gates dut(a,b,g_xor,g_xnor);
 
 always 
 begin
    #0 a=1'b0; b=1'b0; 
    #10 a=1'b0; b=1'b1; 
    #10 a=1'b1; b=1'b0; 
    #10 a=1'b1; b=1'b1; 
    #10;
 end
 
 initial 
 begin
    $monitor("a=%b, b=%b, xor=%b, xnor=%b",a,b,g_xor,g_xnor);
    #50 $finish;
 end

endmodule