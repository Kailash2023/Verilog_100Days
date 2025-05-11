module demux_1x2(
    input sel,
    input i,
    output y0,y1
);

    assign {y0,y1} = sel ? {1'b0,i} : {i,1'b0} ;

endmodule

module universal_gates(
    input a,b,
    output y_nand,y_nor
    );
    
    wire w0,w1,w2,w3,abar;
    
    demux_1x2 d_nand_1(b,a,w0,w1);
    demux_1x2 d_nand_2(w1,1'b1,y_nand,w2);
    
    demux_1x2 d_nor_1(a,1'b1,abar,w2);
    demux_1x2 d_nor_2(b,abar,y_nor,w3);
    
endmodule