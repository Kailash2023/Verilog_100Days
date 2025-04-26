module full_adder(
    input A,B,Cin,
    output sum,carry
    );
    
    assign sum=A^B^Cin;
    assign carry=(A&B)|(Cin&(A^B));
    
endmodule


module parallel_substractor(
    input [3:0]a,b,
    input en,
    output [3:0]d,
    output bout
    );
    
    wire [2:0]c;
    
    full_adder f1(a[0],(b[0]^en),en,d[0],c[0]);
    full_adder f2(a[1],(b[1]^en),c[0],d[1],c[1]);
    full_adder f3(a[2],(b[2]^en),c[1],d[2],c[2]);
    full_adder f4(a[3],(b[3]^en),c[2],d[3],bout);
        
endmodule