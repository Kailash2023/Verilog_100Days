module mux_2x1(
input [1:0]i,
input sel,
output out
);

assign out = sel ? i[1]:i[0] ;

endmodule

module universal_gates(
    input a,b,
    output gate_nand,gate_nor
    );
    
    wire bbar;
    
    mux_2x1 m1({1'b0, 1'b1},b,bbar);
    
    mux_2x1 m2({bbar, 1'b1},a,gate_nand);
    mux_2x1 m3({1'b0, bbar},a,gate_nor);
    
endmodule