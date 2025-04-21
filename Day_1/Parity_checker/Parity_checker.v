module Parity_checker(
    input [7:0] data_in,
    input parity,
    output error    
    );
    
    assign error=^({parity,data_in});
    
endmodule
