module tb_mux_2_1();

reg [1:0]i;
reg sel;
wire out;

mux_2_1 dut(i,sel,out);

always begin
    i=$random;
    sel=$random;
    #10;
end

initial begin 
    $monitor("i=%0d,sel=%0d,out=%0d",i,sel,out);
    #100 $finish;
end 

endmodule