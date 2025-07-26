
module seg7_encoder (
    input  wire        clk,
    input  wire        rst_n,
    input  wire [3:0]  value,  // 0–9
    output reg  [6:0]  seg     // {a,b,c,d,e,f,g}
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            seg <= 7'b0000000;
        end else begin
            case (value)
                4'd0: seg <= 7'b0111111;
                4'd1: seg <= 7'b0000110;
                4'd2: seg <= 7'b1011011;
                4'd3: seg <= 7'b1001111;
                4'd4: seg <= 7'b1100110;
                4'd5: seg <= 7'b1101101;
                4'd6: seg <= 7'b1111101;
                4'd7: seg <= 7'b0000111;
                4'd8: seg <= 7'b1111111;
                4'd9: seg <= 7'b1101111;
                default: seg <= 7'b0000000;
            endcase
        end
    end

endmodule
