module mux_2x1(
    input [1:0]i,
    input sel,
    output out
);

assign out = sel ? i[1]:i[0] ; 

endmodule

module Full_adder(
    input a,b,cin,
    output sum,carry
    );
    
    wire bbar,w,wbar,y,z;
    
    mux_2x1 m1({1'b0,1'b1},b,bbar);
    
    mux_2x1 m3({bbar,b},a,w);
    mux_2x1 m2({1'b0,1'b1},w,wbar);
    mux_2x1 m4({wbar,w},cin,sum);
    
    mux_2x1 m5({b,1'b0},a,y);
    mux_2x1 m6({cin,1'b0},w,z);
    
    mux_2x1 m7({1'b1,y},z,carry);
    
endmodule