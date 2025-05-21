module majority_input(
    input [6:0]in,
    output out
    );
    
    wire test1,test2,test3;
    
    assign test1 = in[0]&in[1] | in[0]&in[2] | in[1]&in[2];
    assign test2 = in[3]&in[4] | in[3]&in[5] | in[4]&in[5];
    assign test3 = in[6];
    
    assign out = test1 & test2 | test1 & test3 | test2 & test3;
    
endmodule
