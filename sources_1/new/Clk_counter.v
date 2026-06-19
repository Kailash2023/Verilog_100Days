`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.05.2026 11:32:05
// Design Name: 
// Module Name: Clk_counter
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Clk_counter(
    input clk,
    input reset,
    
    output reg [31:0]counter1

    );
    
    always@(posedge clk)begin
        if(reset)begin 
            counter1 <= 32'd0;
        end 
        else begin 
            counter1 <= counter1 + 32'd1;
        end
        
    end
    
endmodule
