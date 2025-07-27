`timescale 1ns/1ps

module tb_uart_tx;

    reg clk = 0;
    reg rst = 0;
    reg tx_start = 0;
    reg [7:0] tx_data = 8'h00;
    wire tx;
    wire tx_busy;

    uart_tx uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .tx(tx),
        .tx_busy(tx_busy)
    );

    // Generate 50 MHz clock
    always #10 clk = ~clk;

    initial begin
        $dumpfile("uart_tx.vcd");
        $dumpvars(0, tb_uart_tx);

        // Initial reset
        rst = 1;
        #100;
        rst = 0;

        // Send byte 0xA5
        @(posedge clk);
        tx_data = 8'hA5;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        // Wait until busy is cleared
        wait (!tx_busy);
        #10000;

        // Send byte 0x3C
        @(posedge clk);
        tx_data = 8'h3C;
        tx_start = 1;
        @(posedge clk);
        tx_start = 0;

        wait (!tx_busy);
        #10000;

        $finish;
    end

endmodule
