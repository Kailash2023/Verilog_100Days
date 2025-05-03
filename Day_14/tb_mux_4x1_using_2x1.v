module tb_mux_4x1();

reg [3:0]i;
reg [1:0]sel;
wire out;

mux_4x1_using_2x1 dut(i,sel,out);

always begin 
    i=$random; sel=$random;
    #10;
end

initial begin 
    $monitor("i=%0d,sel=%0d,out=%0d",i,sel,out);
    #100 $finish;
end 

endmodule