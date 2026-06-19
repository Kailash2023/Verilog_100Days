`timescale 1ns / 1ps

module capture(

    input  wire         clk,
    input  wire         reset,

    input  wire [31:0]  rx_tdata,
    input  wire         rx_tvalid,
    input  wire [0:0]   rx_tuser,
    input  wire         rx_tlast,
    input  wire [3:0]   rx_tkeep,
    
    input wire input_tready_l,
    
    output wire rx_tready,

    output reg [31:0]   input_tdata_l,
    output reg input_tvalid_l,
    output reg input_tlast_l,
    output reg [3:0]input_tkeep_l,
    output reg input_tuser_l
);

    assign rx_tready =1;

always @(posedge clk) begin
    if (reset) begin
        input_tdata_l  <= 32'd0;
        input_tvalid_l <= 1'b0;
        input_tlast_l  <= 1'b0;
        input_tuser_l  <= 1'b0;
        input_tkeep_l <= 4'd0;
    end
    else begin
        input_tvalid_l <= rx_tvalid;
        input_tlast_l  <= rx_tlast;
        input_tuser_l <= rx_tuser;
        input_tkeep_l <= rx_tkeep;

        // Capture every valid data word
        if (rx_tvalid) begin
            input_tdata_l <= rx_tdata;
        end
    end
end

endmodule