`timescale 1ns / 1ps



module mux#(payload_width = 8, payload_size_bytes = 128)(
   input clk,reset,
   input arp_valid,
   input icmp_valid,
   input [1023 : 0] arp_data,
   input [1023 : 0] icmp_data,
   output reg [1023 : 0] tx_data,
   output reg data_valid
    );
    
    always@(posedge clk)
      begin
        if(reset) 
          begin 
          tx_data <= 0;
          data_valid <= 0;
          end 
          
          else if(arp_valid) 
          begin
          tx_data <= arp_data;
          data_valid <= 1;
          end
          
          else if(icmp_valid) 
          begin
          tx_data <= icmp_data;
          data_valid <= 1;
          end
          
          else 
          begin 
          tx_data <= 0;
          data_valid <= 0;
          end
          
      end
endmodule
