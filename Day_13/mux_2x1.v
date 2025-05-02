module mux_2_1(
    input [1:0]i,
    input sel,
    output out
    );
    
    assign out=(~sel&i)|(sel&i);
    
endmodule
