

`timescale 1ns / 1ps

    module fifo_tx(
    input  wire        clk,
    input  wire        reset,
    
    output reg         tuser,
    output reg [31:0]  tdata,
    output reg         tvalid,
    output reg         tlast,
    output reg [3:0]   tkeep,
    input  wire        tready,
    
    output wire [55:0] preamble_out
   
    );
    
    assign preamble_out = 56'h5555_5555_5555_55;

    localparam IDLE                 = 3'd0;
    localparam PREPARE_ARP_req        = 3'd1;
    localparam PREPARE_ICMP_req = 3'd2; 
    localparam PREPARE_RANDOM       = 3'd3; 
    localparam TRANSMIT             = 3'd4;
    localparam WAIT_IPG             = 3'd5;
    
    reg [2:0] ps;
    reg [7:0] word_count;
    reg [3:0] ipg_counter;
    reg [15:0] startup_timer; 
    reg [31:0] tx_buffer [0:31];
    integer i;


    always @(posedge clk) begin
        if (reset) begin
            ps                <= IDLE;
            tvalid            <= 1'b0;
            tlast             <= 1'b0;
            tdata             <= 32'd0;
            tkeep             <= 4'h0;
            tuser             <= 1'b0;
            word_count        <= 8'd0;
            ipg_counter       <= 4'd0;
            startup_timer     <= 16'd0;
            
            for (i = 0; i < 32; i = i + 1) begin
                tx_buffer[i] <= 32'd0;
            end
            
        end else begin
            case (ps)
                IDLE: begin
                    tvalid <= 1'b0;
                    tlast  <= 1'b0;
                    tkeep  <= 4'h0;
                    word_count <= 8'd0;

                    if (startup_timer == 16'd2000) begin
                        ps <= PREPARE_ARP_req;
                        startup_timer <= startup_timer + 1'b1;
                    end 
                    
                    else if (startup_timer == 16'd6000) begin
                        ps <= PREPARE_ICMP_req;
                        startup_timer <= startup_timer + 1'b1;
                    end
                    
                    else if (startup_timer == 16'd50 || startup_timer == 16'd4000 || startup_timer == 16'd8000) begin
                        ps <= PREPARE_RANDOM;
                        startup_timer <= startup_timer + 1'b1;
                    end
                    else begin
                        if (startup_timer < 16'hFFFF) begin
                            startup_timer <= startup_timer + 1'b1;
                        end
                    end
                end
                
                PREPARE_RANDOM: begin
                    tx_buffer[0] <= 32'h00000002; 
                    tx_buffer[1] <= 32'hBE000400; 
                    tx_buffer[2] <= 32'hB535BD43; 
                    tx_buffer[3] <= 32'h00450008; 
                    tx_buffer[4] <= 32'h34122000;
                    tx_buffer[5] <= 32'h11400000; 
                    tx_buffer[6] <= 32'hA8C00000; 
                    tx_buffer[7] <= 32'hA8C01401; 
                    tx_buffer[8] <= 32'h00080D01; 
                    tx_buffer[9] <= 32'h34120004; 
                    tx_buffer[10] <= 32'h00000D01;
                    tx_buffer[11] <= 32'h00000000;
                    tx_buffer[12] <= 32'h00000000;
                    tx_buffer[13] <= 32'h00000000;
                    tx_buffer[14] <= 32'h00000000;
                    tx_buffer[15] <= 32'h00000000;
                                         
                    tx_buffer[16] <= 32'h00000000; 
                    tx_buffer[17] <= 32'h00000000; 
                    tx_buffer[18] <= 32'h00000000; 
                    tx_buffer[19] <= 32'h00000000; 
                    tx_buffer[20] <= 32'h00000000;
                    tx_buffer[21] <= 32'h00000000; 
                    tx_buffer[22] <= 32'h00000000; 
                    tx_buffer[23] <= 32'h00000000; 
                    tx_buffer[24] <= 32'h00000000; 
                    tx_buffer[25] <= 32'h00000000; 
                    tx_buffer[26] <= 32'h00000000;
                    tx_buffer[27] <= 32'h00000000;
                    tx_buffer[28] <= 32'h00000000;
                    tx_buffer[29] <= 32'h00000000;
                    tx_buffer[30] <= 32'h00000000;
                    tx_buffer[31] <= 32'h00000000;
                    
                    ps <= TRANSMIT;
                end
                
                
                PREPARE_ARP_req: begin
                    tx_buffer[0] <= 32'hFFFFFFFF; 
                    tx_buffer[1] <= 32'hBE00FFFF; 
                    tx_buffer[2] <= 32'hB535BD43; 
                    tx_buffer[3] <= 32'h01000608; 
                    tx_buffer[4] <= 32'h04060008;
                    tx_buffer[5] <= 32'hBE000100; 
                    tx_buffer[6] <= 32'hB535BD43; 
                    tx_buffer[7] <= 32'h1401A8C0; 
                    tx_buffer[8] <= 32'h00000000; 
                    tx_buffer[9] <= 32'hA8C00000; 
                    tx_buffer[10] <= 32'h00000D01;
                    tx_buffer[11] <= 32'h00000000;
                    tx_buffer[12] <= 32'h00000000;
                    tx_buffer[13] <= 32'h00000000;
                    tx_buffer[14] <= 32'h00000000;
                    tx_buffer[15] <= 32'h00000000;
                                         
                    tx_buffer[16] <= 32'h00000000; 
                    tx_buffer[17] <= 32'h00000000; 
                    tx_buffer[18] <= 32'h00000000; 
                    tx_buffer[19] <= 32'h00000000; 
                    tx_buffer[20] <= 32'h00000000;
                    tx_buffer[21] <= 32'h00000000; 
                    tx_buffer[22] <= 32'h00000000; 
                    tx_buffer[23] <= 32'h00000000; 
                    tx_buffer[24] <= 32'h00000000; 
                    tx_buffer[25] <= 32'h00000000; 
                    tx_buffer[26] <= 32'h00000000;
                    tx_buffer[27] <= 32'h00000000;
                    tx_buffer[28] <= 32'h00000000;
                    tx_buffer[29] <= 32'h00000000;
                    tx_buffer[30] <= 32'h00000000;
                    tx_buffer[31] <= 32'h00000000;
                    
                    ps <= TRANSMIT;
                end
                

                
                PREPARE_ICMP_req: begin
                    tx_buffer[0] <= 32'h00000002; 
                    tx_buffer[1] <= 32'hBE000400; 
                    tx_buffer[2] <= 32'hB535BD43; 
                    tx_buffer[3] <= 32'h00450008; 
                    tx_buffer[4] <= 32'h34122000;
                    tx_buffer[5] <= 32'h01400000; 
                    tx_buffer[6] <= 32'hA8C00000; 
                    tx_buffer[7] <= 32'hA8C01401; 
                    tx_buffer[8] <= 32'h00080D01; 
                    tx_buffer[9] <= 32'h34120000; 
                    tx_buffer[10] <= 32'h00000100;
                    tx_buffer[11] <= 32'h00000000;
                    tx_buffer[12] <= 32'h00000000;
                    tx_buffer[13] <= 32'h00000000;
                    tx_buffer[14] <= 32'h00000000;
                    tx_buffer[15] <= 32'h00000000;
                                         
                    tx_buffer[16] <= 32'h00000000; 
                    tx_buffer[17] <= 32'h00000000; 
                    tx_buffer[18] <= 32'h00000000; 
                    tx_buffer[19] <= 32'h00000000; 
                    tx_buffer[20] <= 32'h00000000;
                    tx_buffer[21] <= 32'h00000000; 
                    tx_buffer[22] <= 32'h00000000; 
                    tx_buffer[23] <= 32'h00000000; 
                    tx_buffer[24] <= 32'h00000000; 
                    tx_buffer[25] <= 32'h00000000; 
                    tx_buffer[26] <= 32'h00000000;
                    tx_buffer[27] <= 32'h00000000;
                    tx_buffer[28] <= 32'h00000000;
                    tx_buffer[29] <= 32'h00000000;
                    tx_buffer[30] <= 32'h00000000;
                    tx_buffer[31] <= 32'h00000000;
                    
                    ps <= TRANSMIT;
                end
                
                TRANSMIT: begin
                    tvalid <= 1'b1;
                    tkeep  <= 4'hF; 
                    
                    if (tvalid == 1'b1 && tready == 1'b1) begin
                        // THE LOOK-AHEAD FIX: Prevents duplicated words in synthesis
                        if (word_count == 8'd30) begin
                            word_count <= word_count + 1'b1;
                            tlast      <= 1'b1; 
                            tdata      <= tx_buffer[31]; 
                            
                        end else if (word_count == 8'd31) begin
                            word_count  <= 8'd0;
                            tvalid      <= 1'b0;
                            tlast       <= 1'b0; 
                            ipg_counter <= 4'd0;
                            ps          <= WAIT_IPG; 
                            
                        end else begin
                            word_count <= word_count + 1'b1;
                            tlast      <= 1'b0;
                            tdata      <= tx_buffer[word_count + 1]; 
                        end
                        
                    end else begin
                        tdata <= tx_buffer[word_count];
                    end
                end
                
                WAIT_IPG: begin
                    tvalid <= 1'b0;
                    tlast  <= 1'b0;
                    tkeep  <= 4'h0;
                    
                    if (ipg_counter == 4'd11) begin 
                        ps <= IDLE;
                    end else begin
                        ipg_counter <= ipg_counter + 1'b1;
                    end
                end
                
                default: ps <= IDLE;
            endcase
        end
    end
endmodule