module demux_1x2(
    input sel,
    input i,
    output y0,y1
);

    assign {y0,y1} = sel ? {1'b0,i} : {i,1'b0} ;
    
endmodule
        
module Special_gates(
    input a,b,
    output y_xor,y_xnor
    );
    
    wire w0,w1,w2,w3,w4,w5,w6,w7;
    
    demux_1x2 d1(b,a,w0,w1);
    demux_1x2 d2(a,b,w2,w3);
    
    demux_1x2 d3(w0,1'b1,w4,w5);
    demux_1x2 d4(w2,w4,y_xnor,w7);
    
    demux_1x2 d5(y_xnor,1'b1,y_xor,w8);
    
endmodule
