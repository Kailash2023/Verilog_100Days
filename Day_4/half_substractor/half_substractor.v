module half_substractor(
    input a,b,
    output diff,borrow
    );
    
    wire [4:0]w;
    
    nand n1(w[0],a,b);
    nand n2(w[1],w[0],a);
    nand n3(w[2],w[0],b);
    nand n4(diff,w[2],w[1]);
    nand n5(w[3],a,a);
    nand n6(w[4],w[3],b);
    nand n7(borrow,w[4],w[4]);
       
endmodule