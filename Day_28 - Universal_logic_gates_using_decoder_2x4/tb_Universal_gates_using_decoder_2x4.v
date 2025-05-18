module tb_universal_gates();
 reg a,b;
 wire g_nand,g_nor;
 
 Universal_gates dut(a,b,g_nand,g_nor);
 
 always
 begin 
        #0  a= 1'b0; b= 1'b0;
        #10 a= 1'b0; b= 1'b1;
        #10 a= 1'b1; b= 1'b0;
        #10 a= 1'b1; b= 1'b1;
        #10;
 end
 initial 
     begin $monitor("a: %b  b: %b  nand: %b, nor: %b ",a, b, g_nand, g_nor,);
     #50 $finish;
     end

endmodule
