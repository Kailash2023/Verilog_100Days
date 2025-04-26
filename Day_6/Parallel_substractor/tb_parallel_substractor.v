module tb_parallel_substractor();

reg [3:0]a,b;
reg en;
wire [3:0]d;
wire bout;

parallel_substractor dut(a,b,en,d,bout);

always begin
    a=$random;
    b=$random;
    en=$random;
    #10;
end

initial begin
    $monitor("a=%b,b=%b,en=%b,diff=%b,bout=%b",a,b,en,d,bout);
    #60;
    $finish;

end


endmodule