module tb_carry_skip_adder();

reg [3:0]a,b;
reg cin;
wire [3:0]s;
wire cout;

carry_skip_adder dut(a,b,cin,s,cout);

initial begin 
     a = 4'b1000; b = 4'b0011; cin = 1'b0;
     #10 a = 4'b0001; b = 4'b1010; cin = 1'b1;
     #10 a = 4'b0110; b = 4'b0110; cin = 1'b0;
     #10 a = 4'b0111; b = 4'b1110; cin = 1'b0;
     #10 a = 4'b1001; b = 4'b0110; cin = 1'b1;
     #10 a = 4'b1001; b = 4'b0100; cin = 1'b0;
     #10 a = 4'b1111; b = 4'b1110; cin = 1'b1;
end

initial
    begin $monitor("a=%b b=%b cin=%b Sum=%b Carry=%b",a,b,cin,s,cout);
    #70 $finish;
end

endmodule