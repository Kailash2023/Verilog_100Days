`timescale 1ns / 1ps

module ARP_response (
    input  wire          clk,
    input  wire          reset,
    input  wire [31:0]   request_tdata,
    input  wire          stream_valid,
    input  wire          request_tlast,
    input  wire          ARP_valid,
    input  wire [47:0]   src_add_out,    
    output reg [31:0]    arp_tdata,
    output reg           arp_tvalid,
    output reg           arp_tlast
);

    wire [47:0] FPGA_mac_add = 48'h0400_0000_0002;
    wire [31:0] FPGA_IP_add  = 32'h0D01_A8C0;
    wire [15:0] Opcode_reply = 16'h0200;

    reg [31:0] latched_target_ip; 
    reg [4:0]  word_count;

    always @(posedge clk) begin
        if (reset) begin
            arp_tdata          <= 32'd0;
            arp_tvalid         <= 1'b0;
            arp_tlast          <= 1'b0;
            word_count        <= 5'd0;
            latched_target_ip <= 32'd0;
        end else begin
            
            
            arp_tvalid <= 1'b0;
            arp_tlast  <= 1'b0;

           
            if (stream_valid && ARP_valid) begin
                arp_tvalid <= 1'b1;

                
                if (word_count == 5'd7) begin
                    latched_target_ip <= request_tdata;
                end

                
                case (word_count)
                    5'd0:  arp_tdata <= {src_add_out[23:16],src_add_out[31:24], src_add_out[39:32], src_add_out[47:40]};                                 // Dest MAC [31:0]
                    5'd1:  arp_tdata <= {FPGA_mac_add[15:0], src_add_out[7:0], src_add_out[15:8]};          // Dest MAC [47:32] | Src MAC [15:0]
                    5'd2:  arp_tdata <= FPGA_mac_add[47:16];                               // Src MAC [47:16]
                    5'd3:  arp_tdata <= request_tdata;                                     // EthType & HW Type (Unchanged)
                    5'd4:  arp_tdata <= request_tdata;                                     // Prot Type & Sizes (Unchanged)
                    5'd5:  arp_tdata <= {FPGA_mac_add[15:0], Opcode_reply};                // Opcode Reply | Sender MAC [15:0]
                    5'd6:  arp_tdata <= FPGA_mac_add[47:16];                               // Sender MAC [47:16]
                    5'd7:  arp_tdata <= FPGA_IP_add;                                       // Sender IP (Our FPGA IP)
                    5'd8:  arp_tdata <= {src_add_out[23:16],src_add_out[31:24], src_add_out[39:32], src_add_out[47:40]};                                 // Target MAC [31:0]
                    5'd9:  arp_tdata <= {latched_target_ip[15:0], src_add_out[7:0], src_add_out[15:8]};     // Target MAC [47:32] | Target IP [15:0]
                    5'd10: arp_tdata <= {16'h0000, latched_target_ip[31:16]};              // Target IP [31:16] | Padding
                    default: arp_tdata <= request_tdata;                                           // Padding for the rest of the 64-byte frame
                endcase

                
                if (request_tlast) begin
                    arp_tlast   <= 1'b1;
                    word_count <= 5'd0;
                end else begin
                    word_count <= word_count + 1'b1;
                end
                
            end else begin
              
                word_count <= 5'd0;
            end
        end
    end

endmodule