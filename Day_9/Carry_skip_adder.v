module full_adder (
    input a,b,cin,
    output sum,carry
);

    assign sum = a^b^cin;
    assign carry = (a&b)|cin&(a^b);
    
endmodule 

module parallel_adder(
    input [3:0]A,B,
    input Cin,
    output [3:0]S,
    output Cout
);
    wire [3:0]C;
    full_adder f1(A[0],B[0],Cin,S[0],C[0]);
    full_adder f2(A[1],B[1],C[0],S[1],C[1]);
    full_adder f3(A[2],B[2],C[1],S[2],C[2]);
    full_adder f4(A[3],B[3],C[2],S[3],Cout);
    
endmodule    

module carry_skip_adder(
    input [3:0]a,b,
    input cin,
    output [3:0]s,
    output cout
    );
    
    wire [3:0]p;
    wire sel;
    
    parallel_adder p1(a,b,cin,s,c);
    
    xor (p[0],a[0],b[0]),
        (p[1],a[1],b[1]),
        (p[2],a[2],b[2]),
        (p[3],a[3],b[3]);
        
    assign sel=p[0]&p[1]&p[2]&p[3];
    
    assign cout=sel ? cin : c;    
    
endmodule