`timescale 1ns / 1ps

module ICMP_response (
    input  wire          clk,
    input  wire          reset,

    input  wire [31:0]   request_tdata,
    input  wire          stream_valid,
    input  wire          request_tlast,
    input  wire          ICMP_valid,
    input  wire [47:0]   src_add_out,    

    
    output reg [31:0]    icmp_tdata,
    output reg           icmp_tvalid,
    output reg           icmp_tlast
);

    
    wire [47:0] FPGA_mac_add = 48'h0400_0000_0002;
    wire [31:0] FPGA_IP_add  = 32'h0D01_A8C0; 

    
    reg [15:0] pc_ip_lower;
    reg [15:0] pc_ip_upper;

    reg [9:0]  word_count; 

    wire [15:0] orig_checksum = {request_tdata[7:0], request_tdata[15:8]};
    wire [15:0] final_checksum = orig_checksum + 16'h0800;
    wire [15:0] reply_final_checksum = {final_checksum[7:0], final_checksum[15:8]};

    always @(posedge clk) begin
        if (reset) begin
            icmp_tdata    <= 32'd0;
            icmp_tvalid   <= 1'b0;
            icmp_tlast    <= 1'b0;
            word_count  <= 10'd0;
            pc_ip_lower <= 16'd0;
            pc_ip_upper <= 16'd0;
        end else begin
            
           
            icmp_tvalid <= 1'b0;
            icmp_tlast  <= 1'b0;

            
            if (stream_valid && ICMP_valid) begin
                icmp_tvalid <= 1'b1;

                
                if (word_count == 10'd6) pc_ip_lower <= request_tdata[31:16];
                if (word_count == 10'd7) pc_ip_upper <= request_tdata[15:0];

                case (word_count)
                   
                    10'd0:  icmp_tdata <= {src_add_out[23:16],src_add_out[31:24], src_add_out[39:32], src_add_out[47:40]};                                 // Dest MAC [31:0]
                    10'd1:  icmp_tdata <= {FPGA_mac_add[15:0], src_add_out[7:0], src_add_out[15:8]};          // Dest MAC [47:32] | Src MAC [15:0]
                    10'd2:  icmp_tdata <= FPGA_mac_add[47:16];                               // Src MAC [47:16]
                    
               
                    10'd3:  icmp_tdata <= request_tdata;                                     // EthType, Version_IHL, DSCP
                    10'd4:  icmp_tdata <= request_tdata;                                     // Total Length, Identification
                    10'd5:  icmp_tdata <= request_tdata;                                     // Flags or Frag Offset, TTL, Protocol

                    // --- IP ADDRESS SWAP ---
                    // Word 6 original: Src IP [15:0] | Header Checksum 
                    // Word 6 new     : FPGA IP [15:0]| Header Checksum (Unchanged)
                    10'd6:  icmp_tdata <= {FPGA_IP_add[15:0], request_tdata[15:0]};

                    // Word 7 original: Dest IP [15:0] | Src IP [31:16]
                    // Word 7 new     : PC IP [15:0]   | FPGA IP [31:16]
                    10'd7:  icmp_tdata <= {pc_ip_lower, FPGA_IP_add[31:16]};

                    // --- ICMP HEADER SWAP ---
                    // Word 8 original: Code (00) | Type (08) | Dest IP [31:16]
                    // Word 8 new     : Code (00) | Type (00) | PC IP [31:16]
                    10'd8:  icmp_tdata <= {8'h00, 8'h00, pc_ip_upper};

                    // Word 9 original: Identifier | ICMP Checksum
                    // Word 9 new     : Identifier | Adjusted ICMP Checksum
                    10'd9:  icmp_tdata <= {request_tdata[31:16], reply_final_checksum};

                    // --- REST OF PAYLOAD ---
                    // Word 10 to End: Seq number, Timestamps, standard ping payload (abcd...)
                    default: icmp_tdata <= request_tdata; 
                endcase

               
                if (request_tlast) begin
                    icmp_tlast   <= 1'b1;
                    word_count <= 10'd0;
                end else begin
                    word_count <= word_count + 1'b1;
                end
                
            end else begin
               
                word_count <= 10'd0;
            end
        end
    end
    
    

endmodule