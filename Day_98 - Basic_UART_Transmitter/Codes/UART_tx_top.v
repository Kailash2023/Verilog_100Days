module uart_tx_top (
    input wire clk,
    input wire rst,
    output wire tx
);

    reg [7:0] tx_data = 8'hA5;
    reg tx_start = 0;
    wire tx_busy;
    reg [23:0] counter = 0;

    uart_tx uart_inst (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            counter <= 0;
            tx_start <= 0;
        end else begin
            if (counter == 1000000) begin
                tx_start <= 1;
                counter <= 0;
            end else begin
                tx_start <= 0;
                counter <= counter + 1;
            end
        end
    end

endmodule
