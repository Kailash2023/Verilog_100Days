module decoder_2_4(
    input [1:0] i,
   	output reg[3:0] y);
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

module Universal_gates(
    input a,b,
    output g_nand,g_nor 
    );
    wire [3:0]w;
    decoder_2_4 nandgate({a,b}, w);
    assign g_nand= ~w[3];
    assign g_nor = w[0];
endmodule