module decoder_2x4(
    input [1:0]i,
    output reg [3:0]y
);
    always@(i)
    begin 
        y=0;
        case(i)
            2'b00 : y[0] = 1'b1 ;
            2'b01 : y[1] = 1'b1 ;
            2'b10 : y[2] = 1'b1 ;
            2'b11 : y[3] = 1'b1 ;
            
        endcase
    end
endmodule 

module Special_gates(
    input a,b,
    output g_xor,g_xnor
    );
    
    wire [3:0]w;
    
    decoder_2x4 c1({a,b},w);
    
    assign g_xor = w[1] | w[2];
    assign g_xnor = w[0] | w[3];
    
endmodule
