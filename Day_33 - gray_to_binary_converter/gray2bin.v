module Gray2bin(
    input [3:0]gray_in,
    output [3:0]bin_out
    );
    
    assign bin_out[3] = gray_in[3];
    
    assign bin_out[2] = gray_in[3] ^ gray_in[2];
    assign bin_out[1] = gray_in[2] ^ gray_in[1];
    assign bin_out[0] = gray_in[1] ^ gray_in[0];
    
endmodule