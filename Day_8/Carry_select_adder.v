module full_adder(
    input A,B,Cin,
    output Sum,Cout
);

    assign Sum=A^B^Cin;
    assign Cout= (A&B) | Cin&(A^B);
    
endmodule
    
module mux(
    input a,b,sel,
    output y
);

    assign y = (~sel&a) | (sel&b);
    
endmodule

module carry_select_adder(
    input [3:0]a,b,
    input carry,
    output [3:0]s,
    output cout
    );
    
    wire [16:0]w;
    
    full_adder f1(a[0], b[0] , 1'b0 , w[0], w[4]);
    full_adder f2(a[1], b[1] , w[4] , w[1], w[5]);
    full_adder f3(a[2], b[2] , w[5] , w[2], w[6]);
    full_adder f4(a[3], b[3] , w[6] , w[3], w[7]);
    
     
    full_adder f5(a[0], b[0] , 1'b1 , w[8], w[12]);
    full_adder f6(a[1], b[1] , w[12] , w[9], w[13]);
    full_adder f7(a[2], b[2] , w[13] , w[10], w[14]);
    full_adder f8(a[3], b[3] , w[14] , w[11], w[15]);
    
    mux m1(w[0],w[8],carry,s[0]);
    mux m2(w[1],w[9],carry,s[1]);
    mux m3(w[2],w[10],carry,s[2]);
    mux m4(w[3],w[11],carry,s[3]);
    
    mux m5(w[7],w[15],carry,cout);
    
endmodule