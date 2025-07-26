
module status_logic (
    input  wire       clk,
    input  wire       rst_n,    
    input  wire [7:0] temp,
    output reg        hot,
    output reg        normal,
    output reg        cold
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            hot    <= 1'b0;
            normal <= 1'b0;
            cold   <= 1'b0;
        end else begin
            if (temp > 8'd40) begin
                hot    <= 1'b1;
                normal <= 1'b0;
                cold   <= 1'b0;
            end else if (temp < 8'd20) begin
                hot    <= 1'b0;
                normal <= 1'b0;
                cold   <= 1'b1;
            end else begin
                hot    <= 1'b0;
                normal <= 1'b1;
                cold   <= 1'b0;
            end
        end
    end

endmodule
