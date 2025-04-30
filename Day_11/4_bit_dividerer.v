module Divider(
    input [3:0]divisor,dividend,
    output reg [3:0]quotient,remainder
    );
    
    always@(divisor,dividend)begin
        quotient=0;
        remainder=dividend;
        while (remainder>=divisor)
        begin
            remainder=remainder-divisor;
            quotient=quotient+1;
        end
    end
    
endmodule