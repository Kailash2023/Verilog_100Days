`timescale 1ns / 1ps

module fifo_rx #(parameter mac_add = 48'h020000000004)(
    input  wire          clk,
    input  wire          reset,
    
    input  wire [31:0]   input_tdata,
    input  wire          input_tvalid,
    input  wire [0:0]    input_tuser,
    input  wire          input_tlast, 
    input  wire [3:0]    input_tkeep,
    
    output wire          input_tready,
    
    output reg           stream_valid,
    output reg [47:0]    dest_add_out,
    output reg [47:0]    src_add_out,
    output reg [15:0]    eth_type_out,
    output reg [15:0]    dest_port,
    output reg [7:0]     protocol,
    output reg [9:0]     word_count_latch,
    
    output reg           ARP_valid,
    output reg           ICMP_valid,
    output reg           UDP_valid,
    output reg [31:0]    request_tdata,
    output reg           request_tlast
    );
    
    wire [7:0] byte0 = input_tdata[7:0];
    wire [7:0] byte1 = input_tdata[15:8];
    wire [7:0] byte2 = input_tdata[23:16];
    wire [7:0] byte3 = input_tdata[31:24];

    reg [31:0] packet_buffer [0:31];    
    
    reg [1:0]  live_proto; 

    localparam IDLE = 2'd0;
    localparam READ = 2'd1;
    localparam SEND = 2'd2; 
    
    reg [1:0] ps;
    reg [9:0] word_count; 
    reg [9:0] send_count; 
    
    
    assign input_tready = 1;

    always @(posedge clk) begin
        if (reset) begin 
            ps               <= IDLE;
            stream_valid     <= 1'b0;
            ARP_valid        <= 1'b0;
            ICMP_valid       <= 1'b0;
            UDP_valid       <= 1'b0;
            request_tdata    <= 32'd0;
            request_tlast    <= 1'b0;
            dest_add_out     <= 48'd0;
            src_add_out      <= 48'd0;
            eth_type_out     <= 16'd0;
            protocol         <= 8'd0;
            word_count       <= 10'd0;
            word_count_latch <= 10'd0;
            send_count       <= 10'd0;
            live_proto       <= 2'd0;
        end 
        else begin
            case (ps)
                IDLE: begin
                    stream_valid  <= 1'b0;
                    ARP_valid     <= 1'b0;
                    ICMP_valid    <= 1'b0;
                    UDP_valid    <= 1'b0;
                    request_tdata <= 32'd0;
                    request_tlast <= 1'b0;
                    live_proto    <= 2'd0;
                    
                    if (input_tvalid) begin
                        ps <= READ;
                        
                        dest_add_out[47:16] <= {byte0, byte1, byte2, byte3};
                        
                        
                        packet_buffer[0] <= input_tdata;
                        
                        if (input_tlast) begin
                            word_count_latch <= 10'd1;
                            ps               <= IDLE;
                        end else begin
                            word_count <= 10'd1; 
                        end
                    end else begin
                        word_count <= 10'd0;
                    end
                end 
                
                READ: begin
                    stream_valid  <= 1'b0;
                    
                    if (input_tvalid) begin
                        
                        
                        if (word_count < 10'd32) begin
                            packet_buffer[word_count[4:0]] <= input_tdata;
                        end
                        
                        
                        if (word_count == 10'd5) begin
                            if (eth_type_out == 16'h0806) begin
                                live_proto <= 2'd1; 
                            end 
                            else if (eth_type_out == 16'h0800 && byte3 == 8'h01 && dest_add_out == mac_add ) begin
                                live_proto <= 2'd2; 
                            end
                            
                             else if (eth_type_out == 16'h0800 && byte3 == 8'h11 && dest_add_out == mac_add ) begin
                                live_proto <= 2'd3; 
                            end
                        end 
                        
                        
                        case (word_count)
                            10'd1: begin
                                dest_add_out[15:0] <= {byte0, byte1};
                                src_add_out[47:32] <= {byte2, byte3};
                            end
                            10'd2: src_add_out[31:0]  <= {byte0, byte1, byte2, byte3};
                            10'd3: eth_type_out[15:0] <= {byte0, byte1};
                            10'd5: protocol[7:0]      <= byte3;
                            10'd9: dest_port      <= {byte1, byte0};
                            default: ; 
                        endcase
                        
                       
                        if (input_tlast) begin
                            word_count_latch <= word_count + 1'b1;
                            
                            
                            if (input_tuser == 1'b0 && (live_proto == 2'd1 || live_proto == 2'd2 || live_proto == 2'd3)) begin
                                ps         <= SEND;
                                send_count <= 10'd0;
                            end else begin
                                live_proto <= 2'd0; 
                                ps         <= IDLE;
                            end
                        end else begin
                            word_count <= word_count + 1'b1;
                        end
                    end
                end
                
                SEND: begin
                    if (send_count < word_count_latch && send_count < 10'd32) begin
                        stream_valid  <= 1'b1;
                        request_tdata <= packet_buffer[send_count[4:0]]; 
                        
                        if (live_proto == 2'd1) ARP_valid  <= 1'b1;
                        if (live_proto == 2'd2) ICMP_valid <= 1'b1;
                        if (live_proto == 2'd3) UDP_valid <= 1'b1;
                        
                        if (send_count == word_count_latch - 1'b1) begin
                            request_tlast <= 1'b1;
                        end else begin
                            request_tlast <= 1'b0;
                        end
                        
                        send_count <= send_count + 1'b1;
                    end 
                    else begin
                        stream_valid  <= 1'b0;
                        ARP_valid     <= 1'b0;
                        ICMP_valid    <= 1'b0;
                        UDP_valid    <= 1'b0;
                        request_tdata <= 32'd0;
                        request_tlast <= 1'b0;
                        live_proto    <= 2'd0;
                        ps            <= IDLE;
                    end
                end
                
                default: ps <= IDLE;
            endcase 
        end
    end
endmodule