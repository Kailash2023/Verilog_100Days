module tb_full_substractor();

reg a, b, bin;
reg clk;
wire diff,borrow;

always #5 clk=~clk;

full_substractor uut(a,b,bin,diff,borrow);

initial begin 
    clk=0;
    a=0; b=0; bin=0; #10
    a=0; b=1; bin=0; #10
    a=1; b=0; bin=0; #10
    a=1; b=1; bin=0; #10
    a=0; b=0; bin=1; #10
    a=0; b=1; bin=1; #10
    a=1; b=0; bin=1; #10
    a=1; b=1; bin=1; #10
    $finish;
end

always@(posedge clk)begin
    $display("a=%b,b=%b,bin=%b, diff=%b,borrow=%b",a,b,bin,diff,borrow);
end
endmodule