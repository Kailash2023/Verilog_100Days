module mux_2x1(
input [1:0]i,
input sel,
output out
);

assign out = sel ? i[1]:i[0] ;

endmodule

module special_gates(
    input a,b,
    output gxor,gxnor
    );
    
    wire bbar;
    
    mux_2x1 m1({1'b0,1'b1}, b, bbar);
    
    mux_2x1 m2({bbar,b}, a, gxor);    
    mux_2x1 m3({b,bbar}, a, gxnor);
    
endmodule