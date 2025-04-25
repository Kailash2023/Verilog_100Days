module full_adder(
    input a,b,cin,
    output sum,carry
    );
    
    wire [6:0]w;
    
    nand n1(w[0],a,b);
    nand n2(w[1],a,w[0]);
    nand n3(w[2],b,w[0]);
    nand n4(w[3],w[1],w[2]);
    nand n5(w[4],w[3],cin);
    nand n6(w[5],w[4],w[3]);
    nand n7(w[6],w[4],cin);
    nand n8(sum,w[5],w[6]);
    
    nand n9(carry,w[4],w[0]);
    
endmodule