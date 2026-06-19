`timescale 1ns / 1ps

module Eth_AXI(
    input axi_clk,
    input axi_rstn,
    
    output reg [31 :0] awaddr,
    output reg awvalid,
    input awready,
     
    output reg [31:0] wdata,
    output reg wvalid,
    input wready,
    
    input [1:0] bresp,
    input bvalid,
    output reg bready,
     
    output reg [31 :0] araddr,
    output reg arvalid,
    input arready,
    
    input [31 :0] rdata,
    input  rvalid,
    output reg rready,
     
    input [1:0] rresp,
    
    output reg device_lock
    
   

    );
    
    
    localparam IP_ADD     = 32'h44A00000;
    
    localparam IDLE   = 5'h0;
    localparam READ1  = 5'h1;
    localparam READ2  = 5'h2;
    localparam WRITE1 = 5'h4;
    localparam TRANSFER_DONE = 5'hE;
    localparam HOLD = 5'hF;
    
    reg[3:0] hold_count;
    reg exit = 0;
    reg [31:0] IP_read;
    
    (* keep = "true" , mark_debug = "false" *)reg[4:0] present_state,next_state;   
    (* keep = "true" , mark_debug = "false" *)reg[7:0] transfer_count;
    (* keep = "true" , mark_debug = "false" *)reg [31:0] address;
    (* keep = "true" , mark_debug = "false" *)reg [31:0] data_in;
    (* keep = "true" , mark_debug = "false" *)reg [31:0] data_out;    
    (* mark_debug = "false" *) reg read_en,write_en;
    (* mark_debug = "false" *) reg wait_500us;
    reg [15:0] wait_counter = 0;
    reg wait_end;
    
    
    always@(posedge axi_clk)               //next state transition
    begin
      if(!axi_rstn)
        begin
          present_state <= IDLE;
        end
        
       else 
        begin
         present_state <= next_state;
        end
    end
    
    
    
    always@(*)             // next state logic
    begin
        if(!axi_rstn) 
        begin
        next_state = IDLE;
        end
        
        else
        begin
        case(present_state)
        
        IDLE : 
          begin
            if(read_en == 1)        next_state = READ1;
            else if(write_en == 1)  next_state = WRITE1;
            else next_state = IDLE;
          end 
          
        READ1:
          begin
             if(arready == 1)
                next_state = READ2;
                
             else 
                next_state = READ1;
          end 
          
        READ2:
          begin
             if(rvalid == 1)
             begin
                next_state = TRANSFER_DONE;
                data_in = rdata;
             end   
             else 
                next_state = READ2;
          end   
          
        WRITE1:
        begin
            if(awready == 1 && wready == 1)
                next_state = TRANSFER_DONE;
                
             else 
                next_state = WRITE1;
        end    
        
        
        TRANSFER_DONE :
        begin           
           next_state = HOLD;
                   
        end 
        
        HOLD:
        begin
            if(hold_count == 10 && wait_500us == 0)
                next_state = IDLE;
                
             else 
                next_state = HOLD;
        end
    
         default:
           begin 
                
           end
        endcase
        end
    end
    
    
    
    always@(posedge axi_clk)             // output logic
    begin
     
        case(present_state)
           IDLE : 
          begin
           awaddr     <= 0;
           awvalid    <= 0;
           wdata      <= 0;
           wvalid     <= 0;
           araddr     <= 0;
           arvalid    <= 0;
           rready     <= 0;
           bready     <= 0;
          end 
          
        READ1:
          begin
           araddr     <= address;
           arvalid    <= 1;
          end 
          
        READ2:
          begin
           araddr     <= 0;
           arvalid    <= 0;
           rready     <= 1;
          end   
          
         WRITE1:
          begin
           awaddr <= address;
           awvalid <= 1; 
           wdata  <= data_out;
           wvalid <= 1;  
           bready <= 1;    
          end
          
    
         default:
           begin
           awaddr     <= 0;
           awvalid    <= 0;
           wdata      <= 0;
           wvalid     <= 0;
           araddr     <= 0;
           arvalid    <= 0;
           rready     <= 0;
           end
          
          endcase
      end
   
    always @(posedge axi_clk) 
    begin
    if(!axi_rstn)
     begin
        transfer_count <= 0;
    end
     else begin
        if(wait_500us && !wait_end) 
        begin   
            transfer_count <= transfer_count;
        end 
        else 
        if(present_state == TRANSFER_DONE && !exit) begin
            transfer_count <= transfer_count + 1;
        end
    end
end


    
    always@(posedge axi_clk)             // Transfer count logic
    begin
      if(!axi_rstn)
         begin
          hold_count <= 0;
         end
         
         
      else 
        begin
          if(present_state == HOLD)
            begin
            hold_count <= hold_count + 1;
            end 
            
          else 
            begin
            hold_count <= 0;
            end
        end
    end
    
    always@(posedge axi_clk)
     begin
       if(!axi_rstn)
         begin
             address <= 0;
             read_en <= 0;
             write_en <= 0;
             exit <= 0;
             wait_500us <= 0;
             device_lock <= 0;
         end
         
      else 
        begin
        case(transfer_count)
            8'h00: begin address <= IP_ADD + 32'h00000024; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h01: begin address <= IP_ADD + 32'h00000008; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h40000000; end
            8'h02: begin address <= IP_ADD + 32'h00000008; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h03: begin address <= IP_ADD + 32'h00000014; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h00000033; end
            8'h04: begin address <= IP_ADD + 32'h0000000C; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h05: begin address <= IP_ADD + 32'h0000000C; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h00003083; end 
            8'h06: begin address <= IP_ADD + 32'h00000000; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h00000001; end 
            8'h07: begin address <= IP_ADD + 32'h00000000; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h00000000; end 
            8'h08: begin address <= IP_ADD + 32'h00000020; read_en <= 0; write_en <= 1; wait_500us <= 0; data_out <= 32'h00000001; end 
            8'h09: begin address <= IP_ADD + 32'h00000020; read_en <= 0; write_en <= 1; wait_500us <= 1; data_out <= 32'h00000001; end 
            8'h0A: begin address <= IP_ADD + 32'h00000700; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h0B: begin address <= IP_ADD + 32'h00000704; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h0C: begin address <= IP_ADD + 32'h00000708; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h0D: begin address <= IP_ADD + 32'h0000070C; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h0E: begin address <= IP_ADD + 32'h00000710; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h0F: begin address <= IP_ADD + 32'h00000714; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h10: begin address <= IP_ADD + 32'h00000718; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h11: begin address <= IP_ADD + 32'h0000071C; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h12: begin address <= IP_ADD + 32'h00000808; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h13: begin address <= IP_ADD + 32'h0000080C; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h14: begin address <= IP_ADD + 32'h00000810; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h15: begin address <= IP_ADD + 32'h00000814; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h16: begin address <= IP_ADD + 32'h00000818; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h17: begin address <= IP_ADD + 32'h0000081C; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h18: begin address <= IP_ADD + 32'h00000820; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            8'h19: begin address <= IP_ADD + 32'h00000824; read_en <= 1; write_en <= 0; wait_500us <= 0; IP_read <= data_in; end
            
            
            
            
            
            
           default:
           begin
             read_en <= 0;
             write_en <= 0;
             exit <= 1;
             wait_500us <= 0;
           end
           endcase
        end
     end
     
    always @(posedge axi_clk) begin
    if(!axi_rstn) 
    begin
        wait_counter <= 0;
        wait_end <= 0;
    end
     else
      begin
        if(wait_500us)
         begin
            if(wait_counter < 16'd25000)
             begin
                wait_counter <= wait_counter + 1;
                wait_end <= 0;
            end
             else
              begin
                wait_end <= 1;  
              end
        end 
        else
         begin
            wait_counter <= 0;
            wait_end <= 0;
         end
    end
end


endmodule



   