
module digital_thermometer (
    input  wire        clk,
    input  wire        rst_n,    
    input  wire [7:0]  temp,     
    output wire [6:0]  seg,      
    output wire        hot,
    output wire        normal,
    output wire        cold
);

    
    status_logic u_status (
        .clk    (clk),
        .rst_n  (rst_n),
        .temp   (temp),
        .hot    (hot),
        .normal (normal),
        .cold   (cold)
    );

    
    seg7_encoder u_seg7 (
        .clk    (clk),
        .rst_n  (rst_n),
        .value  (temp % 10),  
        .seg    (seg)
    );

endmodule
