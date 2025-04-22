module full_adder(
    input a,b,c_in,
    output sum,carry
    );
    
    assign sum=a^b^c_in;
    assign carry=(a&b)|c_in&(a^b);
    
endmodule
