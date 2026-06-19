module led_blink (
    input  wire clk_50mhz,   // 50 MHz input clock
    input  wire reset,       // active-high reset
    output reg  led          // LED output (1 sec ON / 1 sec OFF)
);

    // 50 MHz ? 1 second = 50,000,000 clock cycles
    localparam integer MAX_COUNT = 50_000_000 - 1;

    reg [25:0] counter;  // 2^26 = 67,108,864 > 50,000,000

    always @(posedge clk_50mhz or posedge reset) begin
        if (reset) begin
            counter <= 26'd0;
            led <= 1'b0;
        end else begin
            if (counter == MAX_COUNT) begin
                counter <= 26'd0;
                led <= ~led;  // toggle LED every second
            end else begin
                counter <= counter + 1'b1;
            end
        end
    end

endmodule
