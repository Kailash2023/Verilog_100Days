module tb_bin2gray();

 reg [3:0]bin_in;
 wire [3:0]gray_out;
 
 binary2gray dut(bin_in,gray_out);
 
 initial begin
        bin_in= 4'd0;
        #10;
        bin_in= 4'd1;
        #10;
        bin_in= 4'd2;
        #10;
        bin_in= 4'd3;
        #10;
        bin_in= 4'd4;
        #10;
        bin_in= 4'd5;
        #10;
        bin_in= 4'd6;
        #10;
        bin_in= 4'd7;
        #10;
        bin_in= 4'd8;
        #10;
        bin_in= 4'd9;
        #10;
        bin_in= 4'd10;
        #10;
        bin_in= 4'd11;
        #10;
        bin_in= 4'd12;
        #10;
        bin_in= 4'd13;
        #10;
        bin_in= 4'd14;
        #10;
        bin_in= 4'd15;
    end

initial
    begin $monitor("binary: %b -> gray: %b", bin_in, gray_out);
    #160 $finish;
    end

endmodule