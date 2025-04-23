module tb_full_substractor( );

reg a,b,b_in;
reg clk;
wire diff,borrow;

always #5 clk=~clk;

full_substractor uut(a,b,b_in,diff,borrow);

initial begin
    clk=0;
    a=0; b=0; b_in=0; #10
    a=0; b=0; b_in=1; #10
    a=0; b=1; b_in=0; #10
    a=0; b=1; b_in=1; #10
    a=1; b=0; b_in=0; #10
    a=1; b=0; b_in=1; #10
    a=1; b=1; b_in=0; #10
    a=1; b=1; b_in=1; #10
    $finish;
   
end

always @(posedge clk)begin
    $display("a=%b, b=%b, b_in=%b, diff=%b, borrow=%b", a, b,b_in, diff,borrow);
end

endmodule