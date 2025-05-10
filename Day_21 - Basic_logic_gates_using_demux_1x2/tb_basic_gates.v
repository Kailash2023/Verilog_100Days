module demux_1x2(
    input sel,
    input i,
    output y0,y1
);

assign {y0,y1} = sel ? {1'b0,i} : {i,1'b0} ;

endmodule

module basic_gates(
    input a,b,
    output y_not,y_and,y_or
    );
    
    wire w0,w1,w2,w3;
    
    demux_1x2 d_not(b,1'b1,y_not,w0);    
    
    demux_1x2 d_and(y_not,a,y_and,w1);
    
    demux_1x2 d_or_1(~b,~a,w2,w3);
    demux_1x2 d_or_2(w3,1'b1,y_or,w4);
    
endmodule