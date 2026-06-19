`timescale 1ns / 1ps

module data_delay(
    input  clk,
    input  resetn,
    output reg rst_out
);

    (* mark_debug = "false" *) reg [31:0] counter;
//    parameter HIGH_COUNT = 32'd1562500000;
//    parameter LOW_COUNT  = 32'd156250000;
    
//    parameter HIGH_COUNT = 32'd156250;
//    parameter LOW_COUNT  = 32'd15625;
    
    parameter HIGH_COUNT = 32'd15625;
    parameter LOW_COUNT  = 32'd15625;

    reg state;

    // state = 1 --> rst_out HIGH
    // state = 0 --> rst_out LOW

    always @(posedge clk) begin

        if (!resetn) begin
            counter <= 32'd0;
            rst_out <= 1'b1;
            state   <= 1'b1;
        end

        else begin

            counter <= counter + 1;

            // HIGH PERIOD
            if (state == 1'b1) begin

                rst_out <= 1'b1;

                if (counter >= HIGH_COUNT-1) begin
                    counter <= 32'd0;
                    state   <= 1'b0;
                end
            end

            // LOW PERIOD
            else begin

                rst_out <= 1'b0;

                if (counter >= LOW_COUNT-1) begin
                    counter <= 32'd0;
                    state   <= 1'b1;
                end
            end
        end
    end

endmodule