module tb_special_gates();

    reg a,b;
    wire y_xor,y_xnor;
    
    Special_gates dut(a,b,y_xor,y_xnor);
    
    always begin
        a=1'b0; b=1'b0; #10
        a=1'b0; b=1'b1; #10
        a=1'b1; b=1'b0; #10
        a=1'b1; b=1'b1; #10;
    end
    
    initial begin
        $monitor("a=%b,b=%b,xor=%b,xnor=%b",a,b,y_xor,y_xnor);
        #40 $finish;
    end

endmodule