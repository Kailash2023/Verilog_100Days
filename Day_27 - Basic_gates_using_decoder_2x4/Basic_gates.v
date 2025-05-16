module decoder_2x4(
    input [1:0]i,
    output reg[3:0]y
);
    always@(i)
        begin 
        y=0;
            case(i)
                    2'b00 : y[0] = 1'b1;
					2'b01 : y[1] = 1'b1;
					2'b10 : y[2] = 1'b1;
					2'b11 : y[3] = 1'b1;
			endcase 
                
        end
        
endmodule 


module Basic_gates(
    input a,b,
    output g_and,g_or,g_not
    );
    wire [3:0] w,w1;
    
    decoder_2x4 andgate({a,b}, w);
    assign g_and= w[3];
    
    assign g_or= ~w[0];
    
    
    decoder_2x4 notgate({a,1'b0}, w1);
    assign g_not= w1[0];
    
endmodule