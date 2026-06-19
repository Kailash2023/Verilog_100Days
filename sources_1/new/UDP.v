`timescale 1ns / 1ps

module UDP_response (
    input  wire          clk,
    input  wire          reset,

    input  wire [31:0]   request_tdata,
    input  wire          stream_valid,
    input  wire          request_tlast,
    input  wire          UDP_valid,
    input  wire [47:0]   src_add_out,    
    input  wire [15:0]   dest_port,

    
     (* dont_touch="true" *)output reg [31:0]    udp_tdata,
     (* dont_touch="true" *)output reg           udp_tvalid,
     (* dont_touch="true" *)output reg           udp_tlast
);

    
    wire [47:0] FPGA_mac_add = 48'h0400_0000_0002;
    wire [31:0] FPGA_IP_add  = 32'h0D01_A8C0; 

    
    reg [15:0] PC_port;
    reg [15:0] pc_ip_lower;
    reg [15:0] pc_ip_upper;
    reg [9:0]  word_count; 


    always @(posedge clk) begin
        if (reset) begin
            udp_tdata    <= 32'd0;
            udp_tvalid   <= 1'b0;
            udp_tlast    <= 1'b0;
            word_count  <= 10'd0;
            PC_port <= 16'd0;
        end else begin
            
           
            udp_tvalid <= 1'b0;
            udp_tlast  <= 1'b0;

            
            if (stream_valid && UDP_valid) begin
                udp_tvalid <= 1'b1;

                if (word_count == 10'd6) pc_ip_lower <= request_tdata[31:16];
                if (word_count == 10'd7) pc_ip_upper <= request_tdata[15:0];
                if (word_count == 10'd8) PC_port <= request_tdata[31:16];

                case (word_count)
                   
                    10'd0:  udp_tdata <= {src_add_out[23:16],src_add_out[31:24], src_add_out[39:32], src_add_out[47:40]};                                 // Dest MAC [31:0]
                    10'd1:  udp_tdata <= {FPGA_mac_add[15:0], src_add_out[7:0], src_add_out[15:8]};          // Dest MAC [47:32] | Src MAC [15:0]
                    10'd2:  udp_tdata <= FPGA_mac_add[47:16];                               // Src MAC [47:16]
                    
               
                    10'd3:  udp_tdata <= request_tdata;                                     // EthType, Version_IHL, DSCP
                    10'd4:  udp_tdata <= request_tdata;                                     // Total Length, Identification
                    10'd5:  udp_tdata <= request_tdata;                                     // Flags or Frag Offset, TTL, Protocol

                    10'd6:  udp_tdata <= {FPGA_IP_add[15:0], request_tdata[15:0]};

                    10'd7:  udp_tdata <= {pc_ip_lower, FPGA_IP_add[31:16]};
                    
                    10'd8:  udp_tdata <= {dest_port, pc_ip_upper};

                    10'd9:  udp_tdata <= {request_tdata[31:16], PC_port};

                    // --- REST OF PAYLOAD ---
                    // Word 10 to End: Seq number, Timestamps, standard ping payload (abcd...)
                    default: udp_tdata <= request_tdata; 
                endcase

               
                if (request_tlast) begin
                    udp_tlast   <= 1'b1;
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