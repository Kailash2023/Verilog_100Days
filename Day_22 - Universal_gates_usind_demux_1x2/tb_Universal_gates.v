module tb_universal_gates();

reg a,b;
wire y_nand,y_nor;

universal_gates dut(a,b,y_nand,y_nor);

always begin
    a=1'b0; b=1'b0; #10
    a=1'b0; b=1'b1; #10
    a=1'b1; b=1'b0; #10
    a=1'b1; b=1'b1; #10;
end

initial begin 
    $monitor("a=%b,b=%b,nand=%b,nor=%b",a,b,y_nand,y_nor);
    #40 $finish;
end

endmodule