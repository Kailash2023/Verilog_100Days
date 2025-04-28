module tb_carry_select_adder();

reg [3:0]a,b;
reg carry;
wire cout;
wire [3:0]s;

carry_select_adder dut(a,b,carry,s,cout);

initial begin
         carry=1'b0;a=4'b1011;b=4'b1010;
     #10 carry=1'b1;a=4'b1001;b=4'b1110;
     #10 carry=1'b0;a=4'b0001;b=4'b1010;
     #10 carry=1'b1;a=4'b1100;b=4'b0011;
end

initial begin 
    $monitor("a=%b b=%b carry=%b sum=%b cout=%b",a,b,carry,s,cout);
    #50 $finish;
end

endmodule