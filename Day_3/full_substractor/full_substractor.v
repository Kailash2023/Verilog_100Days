module full_substractor(
    input a,b,b_in,
    output diff,borrow
    );
    
    assign diff=a^b^b_in;
    assign borrow=(~a&(b^b_in))|(b_in&b);
    
endmodule