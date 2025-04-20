module Behaviour_modelling(
    input a,b,
    output reg y0,y1,y2
    );
    
    always@(*)
    begin
        y0=~a;
        y1=~(a&b);
        y2=~(a|b);
    end
    
endmodule
