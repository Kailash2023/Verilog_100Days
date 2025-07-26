`timescale 1ns/1ps

module tb_digital_thermometer;
    reg         clk;
    reg         rst_n;
    reg  [7:0]  temp;
    wire [6:0]  seg;
    wire        hot, normal, cold;

    // Instantiate DUT
    digital_thermometer uut (
        .clk    (clk),
        .rst_n  (rst_n),
        .temp   (temp),
        .seg    (seg),
        .hot    (hot),
        .normal (normal),
        .cold   (cold)
    );

    // Clock: 10 ns period
    initial clk = 0;
    always #5 clk = ~clk;

    initial begin
        // Reset
        rst_n = 1'b0;
        #20;
        rst_n = 1'b1;

        // Cold case (<20°C)
        temp = 8'd10; 
        #50;
        $display("Temp=%0d → seg=%b hot=%b normal=%b cold=%b", temp, seg, hot, normal, cold);

        // Normal case (20–40°C)
        temp = 8'd30; 
        #50;
        $display("Temp=%0d → seg=%b hot=%b normal=%b cold=%b", temp, seg, hot, normal, cold);

        // Hot case (>40°C)
        temp = 8'd55; 
        #50;
        $display("Temp=%0d → seg=%b hot=%b normal=%b cold=%b", temp, seg, hot, normal, cold);

        // Edge: exactly 20°C
        temp = 8'd20; 
        #50;
        $display("Temp=%0d → seg=%b hot=%b normal=%b cold=%b", temp, seg, hot, normal, cold);

        // Edge: exactly 40°C
        temp = 8'd40; 
        #50;
        $display("Temp=%0d → seg=%b hot=%b normal=%b cold=%b", temp, seg, hot, normal, cold);

        $finish;
    end
endmodule
