module tb_carry_lookahead();

reg [3:0]a,b;
reg cin;
reg clk;
wire [3:0]s;
wire carry;

always #5 clk=~clk;
carry_lookahead dut(a,b,cin,s,carry);

initial begin 
   clk=0;
   a = 4'b1000; b = 4'b0011; cin = 1'b0;
   #10 a = 4'b0001; b = 4'b1010; cin = 1'b1;
   #10 a = 4'b0110; b = 4'b0110; cin = 1'b0;
   #10 a = 4'b0111; b = 4'b1110; cin = 1'b0;
   #10 a = 4'b1001; b = 4'b0110; cin = 1'b1;
   #10 a = 4'b1001; b = 4'b0100; cin = 1'b0;
   #10 a = 4'b1111; b = 4'b1110; cin = 1'b1;
   #10;
   $finish;
end

always@(posedge clk)begin
    $display("a=%b,b=%b,cin=%b,sum=%b,carry=%b",a,b,cin,s,carry);
end