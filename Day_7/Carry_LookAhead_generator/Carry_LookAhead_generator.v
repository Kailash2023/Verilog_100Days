module carry_lookahead(
    input [3:0]a,b,
    input cin,
    output [3:0]s,
    output carry
    );
    
    wire [4:0]p,g,c;
    
    assign c[0]=cin;
    
    xor x1(p[0],a[0],b[0]);
    xor x2(p[1],a[1],b[1]);
    xor x3(p[2],a[2],b[2]);
    xor x4(p[3],a[3],b[3]);
    
    and a1(g[0],a[0],b[0]);
    and a2(g[1],a[1],b[1]);
    and a3(g[2],a[2],b[2]);
    and a4(g[3],a[3],b[3]);
    
    assign c[1] = g[0]|p[0]&c[0];
    assign c[2] = g[1] | ( (p[1]&g[0]) | (p[0]&p[1]&c[0]) );
    assign c[3] = g[2] | ( (p[2]&g[1]) | (p[1]&p[2]&g[0]) | (p[0]&p[1]&p[2]&c[0]) );
    assign c[4] = g[3] | ((p[3]&g[2]) | (p[2]&p[3]&g[1]) | (p[1]&p[2]&p[3]&g[0]) | (p[0]&p[1]&p[2]&p[3]&c[0]) );
    
    xor x5(s[0],p[0],c[0]);
    xor x6(s[1],p[1],c[1]);
    xor x7(s[2],p[2],c[2]);
    xor x8(s[3],p[3],c[3]);
    
    assign carry=c[4];
    
endmodule