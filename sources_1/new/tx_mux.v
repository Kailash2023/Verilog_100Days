`timescale 1ns / 1ps

module tx_mux (
    input  wire        clk,
    input  wire        reset,

    input  wire [31:0] arp_tdata,
    input  wire        arp_tvalid,
    input  wire        arp_tlast,

    input  wire [31:0] icmp_tdata,
    input  wire        icmp_tvalid,
    input  wire        icmp_tlast,
    
    input  wire [31:0] udp_tdata,
    input  wire        udp_tvalid,
    input  wire        udp_tlast,

    output wire [31:0] tx_axis_tdata,
    output wire        tx_axis_tvalid,
    output wire        tx_axis_tlast,
    output wire [3:0]  tx_axis_tkeep,
    output wire [0:0]  tx_axis_tuser,
    
    input  wire        tx_axis_tready 
);

    assign tx_axis_tkeep = 4'hF; 
    assign tx_axis_tuser = 1'b0; 

    localparam IDLE      = 2'd0;
    localparam SEND_ARP  = 2'd1;
    localparam SEND_ICMP = 2'd2;
    localparam SEND_UDP = 2'd3;

    reg [1:0] state;

    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (arp_tvalid) begin
                        state <= SEND_ARP;
                    end 
                    else if (icmp_tvalid) begin
                        state <= SEND_ICMP;
                    end
                    else if (udp_tvalid) begin
                        state <= SEND_UDP;
                    end
                end

                SEND_ARP: begin
                    if (arp_tvalid && arp_tlast) begin
                        state <= IDLE;
                    end
                end

                SEND_ICMP: begin
                    if (icmp_tvalid && icmp_tlast) begin
                        state <= IDLE;
                    end
                 end
                 SEND_UDP: begin
                    if (udp_tvalid && udp_tlast) begin
                        state <= IDLE;
                    end   
                end

                default: state <= IDLE;
            endcase
        end
    end

    
    assign tx_axis_tdata  = (state == SEND_ARP  || (state == IDLE && arp_tvalid))  ? arp_tdata  :
                            (state == SEND_ICMP || (state == IDLE && icmp_tvalid)) ? icmp_tdata : 
                            (state == SEND_UDP || (state == IDLE && udp_tvalid)) ? udp_tdata : 32'd0;
                            
    assign tx_axis_tvalid = (state == SEND_ARP  || (state == IDLE && arp_tvalid))  ? arp_tvalid :
                            (state == SEND_ICMP || (state == IDLE && icmp_tvalid)) ? icmp_tvalid : 
                            (state == SEND_UDP || (state == IDLE && udp_tvalid)) ? udp_tvalid : 1'b0;
                            
    assign tx_axis_tlast  = (state == SEND_ARP  || (state == IDLE && arp_tvalid))  ? arp_tlast  :
                            (state == SEND_ICMP || (state == IDLE && icmp_tvalid)) ? icmp_tlast : 
                            (state == SEND_UDP || (state == IDLE && udp_tvalid)) ? udp_tlast : 1'b0;

endmodule