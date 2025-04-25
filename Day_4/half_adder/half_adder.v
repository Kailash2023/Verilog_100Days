module half_adder(
    input a,b,
    output sum,carry
    );
    
    wire [2:0]w;
        
    nand n1(w[0], a, b);
    nand n2(w[1], a, w[0]);
    nand n3(w[2], b, w[0]);
    nand n4(sum, w[2], w[1]);
    
    nand n5(carry, w[0], w[0]);
    

endmodule