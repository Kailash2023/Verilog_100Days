module tb_basic_gates();

    reg a, b;
    wire g_and, g_or, g_not;
         
    Basic_gates dut(a, b, g_or, g_and, g_not);
    initial begin
        #0  a= 1'b0; b= 1'b0;
        #10 a= 1'b0; b= 1'b1;
        #10 a= 1'b1; b= 1'b0;
        #10 a= 1'b1; b= 1'b1;
    end
    initial 
     begin $monitor("a: %b  b: %b  and: %b, or: %b not: %b ",a, b, g_or, g_and, g_not);
     #40 $finish;
     end

endmodule
