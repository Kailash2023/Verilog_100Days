module tb_full_adder();

reg a,b,c_in;
reg clk;
wire sum,carry;

always #10 clk=~clk;

full_adder uut(a,b,c_in,sum,carry);

initial begin 
    clk=0;
    #10 a=0; b=0; c_in=0; 
    #10 a=0; b=1; c_in=0; 
    #10 a=1; b=0; c_in=0; 
    #10 a=1; b=1; c_in=0; 
    #10 a=0; b=0; c_in=1; 
    #10 a=0; b=1; c_in=1; 
    #10 a=1; b=0; c_in=1; 
    #10 a=1; b=1; c_in=1;
    #10;
    $finish;
end

always@(posedge clk)begin
    $display(" a=%b, b=%b, c_in=%b, sum=%b, carry=%b",a,b,c_in,sum,carry);
end

endmodule