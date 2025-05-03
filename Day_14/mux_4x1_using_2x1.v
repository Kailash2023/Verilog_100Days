module mux_2x1(
    input [1:0]I,
    input Sel,
    output out
);
    assign out=(~Sel&I)|(Sel&I);    
endmodule

module mux_4x1_using_2x1(
    input [3:0]i,
    input [1:0]sel,
    output out
    );
    wire [1:0]w;
    
    mux_2x1 m1( i[1:0],sel[0],w[0]);
    mux_2x1 m2( i[3:2],sel[0],w[1]);
    mux_2x1 m3( w,sel[1],out);
endmodule
