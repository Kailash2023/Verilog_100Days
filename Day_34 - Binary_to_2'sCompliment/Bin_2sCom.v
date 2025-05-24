module Bin_2sCom(
    input [3:0]in,
    output signed[3:0]out
    );
    wire [3:0]temp;
    
    assign temp = 4'b1111 - in ;
    assign out = temp + 4'b0001 ;
    
endmodule