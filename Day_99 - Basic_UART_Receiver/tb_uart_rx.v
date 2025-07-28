`timescale 1ns/1ps

module tb_uart_rx;

    reg clk = 0;
    reg rst = 0;
    reg rx = 1; // idle line is high
    wire [7:0] rx_data;
    wire rx_done;

    uart_rx uut (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );

    // 50MHz clock => 20ns period
    always #10 clk = ~clk;

    parameter CLKS_PER_BIT = 5208;  // For 9600 baud

    task send_uart_byte(input [7:0] data);
        integer i;
        begin
            // Send Start bit (0)
            rx <= 0;
            #(CLKS_PER_BIT * 20);

            // Send 8 data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx <= data[i];
                #(CLKS_PER_BIT * 20);
            end

            // Send Stop bit (1)
            rx <= 1;
            #(CLKS_PER_BIT * 20);
        end
    endtask

    initial begin
        $dumpfile("uart_rx.vcd");
        $dumpvars(0, tb_uart_rx);

        rst = 1;
        #100;
        rst = 0;

        #200;

        send_uart_byte(8'h3C); // ASCII '<'

        #100000; // Wait for reception to complete

        if (rx_data == 8'h3C && rx_done == 1)
            $display("✅ UART RX passed: Received 0x%h", rx_data);
        else
            $display("❌ UART RX failed: Received 0x%h", rx_data);

        #5000;
        $finish;
    end

endmodule
