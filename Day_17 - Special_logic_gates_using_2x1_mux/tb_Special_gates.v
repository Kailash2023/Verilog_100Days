module tb_special_gates();

reg a,b;
wire gxor,gxnor;

special_gates dut(a,b,gxor,gxnor);

always begin 
    a=0; b=0; #10
    a=0; b=1; #10
    a=1; b=0; #10
    a=1; b=1; #10
    $finish;
end

initial begin 
    $monitor("a=%b,b=%b,xor=%b,Xnor=%b",a,b,gxor,gxnor);
end

endmodule