module tb_universal_gates();

reg a,b;
wire gate_nand,gate_nor;

universal_gates dut(a,b,gate_nand,gate_nor);

always begin 
    a=1'b0; b=1'b0; #10
    a=1'b0; b=1'b1; #10
    a=1'b1; b=1'b0; #10
    a=1'b1; b=1'b1; #10;
    
end

initial begin 
    $monitor("a=%b,b=%b,nand=%b,nor=%b",a,b,gate_nand,gate_nor);
    #40 $finish;
end

endmodule