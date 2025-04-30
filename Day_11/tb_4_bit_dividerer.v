module tb_divide();

reg [3:0]divisor,dividend;
wire [3:0]quotient,remainder;

Divider dut(divisor,dividend,quotient,remainder);

always begin
    divisor=$random;
    dividend=$random;
    #10;
end

 initial
    begin $monitor("%b / %b = %b with remainder %b ",dividend,divisor,quotient,remainder);
    #100 $finish;
 end 

endmodule
