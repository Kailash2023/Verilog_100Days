module tb_n_bit_square();
    parameter n=16;
    reg [n-1:0]num;
    wire [2*n-1:0]result;
    
    N_bit_square dut(num,result);
    
    always 
    begin
        num=$random;
        #10;
    end
    
    initial begin
        $monitor("num=%b,num^2=%b",num,result);
        #80 $finish;
    end
endmodule
