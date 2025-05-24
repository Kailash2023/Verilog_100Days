module tb_bin_2sCom();

 reg [3:0]in;
 wire signed [3:0]out;
 
 Bin_2sCom dut(in,out);
 
 initial begin
        in= 4'd0;
        #10;
        in= 4'd1;
        #10;
        in= 4'd2;
        #10;
        in= 4'd3;
        #10;
        in= 4'd4;
        #10;
        in= 4'd5;
        #10;
        in= 4'd6;
        #10;
        in= 4'd7;
        #10;
        in= 4'd8;
        #10;
        in= 4'd9;
        #10;
        in= 4'd10;
        #10;
        in= 4'd11;
        #10;
        in= 4'd12;
        #10;
        in= 4'd13;
        #10;
        in= 4'd14;
        #10;
        in= 4'd15;
    end

initial
    begin $monitor("input number: %d  2's Complement: %d", in, out);
    #160 $finish;
    end

endmodule