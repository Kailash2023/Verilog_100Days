module tb_multiplier();

reg [3:0]a,b;
wire [7:0]out;

Multiplier dut(a,b,out);

always begin 
    a=$random;
    b=$random;
    #10;
end

initial begin
    $monitor("a=%b,b=%b,multiplyed_value=%b",a,b,out);
    #100 $finish;
end

endmodule