`timescale 1ns / 1ps


module protocol_check#(payload_width = 8, payload_size_bytes = 128)(
  input clk,reset,
  input [47:0] dest_add_in,
  input [47:0] src_add_in,
  input [15:0] eth_type_in,
  input [1023 : 0]frame_out,
  input stream_valid,
  output reg [47:0] dest_add_out,
  output reg [47:0] src_add_out,
  output reg [15:0] eth_type_out,
  output reg [1023 : 0]payload_out,
  output reg ICMP_valid,
  output reg ARP_valid
    );
    
    (*mark_debug = "true" *)wire [7:0] protocol; 
    
    assign protocol = frame_out[191:184];
//    assign protocol = 8'h01;
    
    always@(posedge clk)
    begin
       if(reset)
         begin
             dest_add_out  <= 48'h0;
             src_add_out   <= 48'h0;
             eth_type_out  <= 16'h0;
             payload_out   <= 1024'h0;
             ICMP_valid    <= 0;
             ARP_valid    <= 0;
         end 
         
        else if(eth_type_in == 16'h0800 && stream_valid && protocol == 8'h01)
        begin 
             dest_add_out  <= dest_add_in;
             src_add_out   <= src_add_in;
             eth_type_out  <= eth_type_in;
             payload_out   <= frame_out;
             ICMP_valid    <= 1;
             ARP_valid     <= 0;
        end
        
        else if(eth_type_in == 16'h0806 && stream_valid)
        begin 
             dest_add_out  <= dest_add_in;
             src_add_out   <= src_add_in;
             eth_type_out  <= eth_type_in;
             payload_out   <= frame_out;
             ICMP_valid    <= 0;
             ARP_valid     <= 1;
        end
        
        else 
        begin
             dest_add_out  <= 48'h0;
             src_add_out   <= 48'h0;
             eth_type_out  <= 16'h0;
             payload_out   <= 1024'h0;
             ICMP_valid    <= 0;
             ARP_valid     <= 0;
         end
    end 
    
endmodule
