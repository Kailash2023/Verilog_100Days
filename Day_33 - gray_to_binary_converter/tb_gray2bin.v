module tb_gray2bin();

 reg [3:0]gray_in;
 wire [3:0]bin_out;
 
 Gray2bin dut(gray_in,bin_out);
 
 initial begin
        gray_in= 4'd0;
        #10;
        gray_in= 4'd1;
        #10;
        gray_in= 4'd2;
        #10;
        gray_in= 4'd3;
        #10;
        gray_in= 4'd4;
        #10;
        gray_in= 4'd5;
        #10;
        gray_in= 4'd6;
        #10;
        gray_in= 4'd7;
        #10;
        gray_in= 4'd8;
        #10;
        gray_in= 4'd9;
        #10;
        gray_in= 4'd10;
        #10;
        gray_in= 4'd11;
        #10;
        gray_in= 4'd12;
        #10;
        gray_in= 4'd13;
        #10;
        gray_in= 4'd14;
        #10;
        gray_in= 4'd15;
    end

initial
    begin $monitor("gray: %b -> binary: %b", gray_in, bin_out);
    #160 $finish;
    end

endmodule