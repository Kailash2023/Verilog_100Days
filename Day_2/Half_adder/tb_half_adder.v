module tb_half_adder();

reg a,b;
reg clk;
wire sum,carry;

always #5 clk=~clk;

half_adder uut(a,b,sum,carry);

initial begin 
    clk=0;
    #10 a=0; b=0;
    #10 a=0; b=1;
    #10 a=1; b=0;
    #10 a=1; b=1;
    #10;
    $finish;
end
always@(posedge clk)begin
    $display("a=%b,b=%b,sum=%b,carry=%b",a,b,sum,carry);
end
endmodule
