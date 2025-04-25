module tb_half_substractor();

reg a,b;
reg clk;
wire diff,borrow;

always #5 clk=~clk;

half_substractor uut(a,b,diff,borrow);

initial begin 
    clk=0;
    a=0; b=0; #10
    a=0; b=1; #10
    a=1; b=0; #10
    a=1; b=1; #10
    $finish;
end

always@(posedge clk)begin
    $display("a=%b,b=%b,diff=%b,borrow=%b",a,b,diff,borrow);
end

endmodule