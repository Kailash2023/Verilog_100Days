module uart_rx (
    input wire clk,            
    input wire rst,            
    input wire rx,            
    output reg [7:0] rx_data, 
    output reg rx_done         
);

    parameter CLKS_PER_BIT = 5208;  // 50MHz / 9600 baud ≈ 5208

    localparam STATE_IDLE    = 3'b000;
    localparam STATE_START   = 3'b001;
    localparam STATE_DATA    = 3'b010;
    localparam STATE_STOP    = 3'b011;
    localparam STATE_CLEANUP = 3'b100;

    reg [2:0] state = STATE_IDLE;
    reg [12:0] clk_count = 0;
    reg [2:0] bit_index = 0;
    reg [7:0] rx_shift = 8'b0;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= STATE_IDLE;
            clk_count <= 0;
            bit_index <= 0;
            rx_data <= 8'd0;
            rx_shift <= 8'd0;
            rx_done <= 1'b0;
        end else begin
            case (state)
                STATE_IDLE: begin
                    rx_done <= 1'b0;
                    clk_count <= 0;
                    bit_index <= 0;
                    if (rx == 1'b0) begin // Start bit detected
                        state <= STATE_START;
                    end
                end

                STATE_START: begin
                    if (clk_count == (CLKS_PER_BIT / 2)) begin
                        clk_count <= 0;
                        state <= STATE_DATA;
                    end else begin
                        clk_count <= clk_count + 1;
                    end
                end

                STATE_DATA: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        rx_shift[bit_index] <= rx;
                        if (bit_index < 3'd7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            bit_index <= 0;
                            state <= STATE_STOP;
                        end
                    end
                end

                STATE_STOP: begin
                    if (clk_count < CLKS_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state <= STATE_CLEANUP;
                    end
                end

                STATE_CLEANUP: begin
                    rx_data <= rx_shift;
                    rx_done <= 1'b1;
                    state <= STATE_IDLE;
                end

                default: state <= STATE_IDLE;
            endcase
        end
    end

endmodule
