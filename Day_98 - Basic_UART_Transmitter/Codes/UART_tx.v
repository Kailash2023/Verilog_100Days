module uart_tx (
    input wire clk,             // System clock
    input wire rst,             // Reset signal (active high)
    input wire tx_start,        // Start signal
    input wire [7:0] tx_data,   // 8-bit data to transmit
    output reg tx,              // Serial output
    output reg tx_busy          // Transmission flag
);

    parameter CLKS_PER_BIT = 5208; // 50MHz / 9600 baud = ~5208

    reg [12:0] clk_count = 0;
    reg [3:0] bit_index = 0;
    reg [9:0] tx_shift = 10'b1111111111; // Frame: start + data + stop

    typedef enum reg [1:0] {
        IDLE = 2'b00,
        LOAD = 2'b01,
        SEND = 2'b10
    } state_t;

    state_t state = IDLE;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            tx <= 1'b1;
            tx_busy <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    tx <= 1'b1;
                    tx_busy <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;

                    if (tx_start) begin
                        tx_shift <= {1'b1, tx_data, 1'b0}; // stop + data + start
                        tx_busy <= 1'b1;
                        state <= SEND;
                    end
                end

                SEND: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        tx <= tx_shift[0];
                        tx_shift <= {1'b1, tx_shift[9:1]}; // Shift right
                        bit_index <= bit_index + 1;

                        if (bit_index == 9) begin
                            state <= IDLE;
                        end
                    end
                end
            endcase
        end
    end

endmodule
