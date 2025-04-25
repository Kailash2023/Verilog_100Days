module full_substractor(
    input a,b,bin,
    output diff,borrow
    );
    
    wire [8:0]w;
    
    nand n1(w[0],b,bin);
    nand n2(w[1],b,w[0]);
    nand n3(w[2],bin,w[0]);
    nand n4(w[3],w[1],w[2]);
    nand n5 (w[4],w[3],a);
    nand n6(w[5],a,w[4]);
    nand n7(w[6],w[4],w[3]);
    nand n8(diff,w[5],w[6]);
    
    nand n9(w[7], a, a);
    nand n10(w[8],w[3],w[7]);
    nand n11(borrow,w[8],w[0]);
    
endmodule