module mux_2x1(
    input [1:0]i,
    input sel,
    output out
);

    assign out= sel ? i[1] : i[0] ;

endmodule 

module gates_using_2x1_mux(
    input a,b,
    output gate_and, gate_or, gate_not
    );
    
    mux_2x1 mand({b, 1'b0}, a, gate_and);
    mux_2x1 mor({1'b1, b}, a, gate_or);
    mux_2x1 mnot({1'b0, 1'b1}, a, gate_not);
    
endmodule
