`timescale 1ns / 1ps



module tx_stream#(payload_width = 8, payload_size_bytes = 128)(
    input clk,reset,
    output reg [31:0] tdata,
    output reg tvalid,
    output reg tuser,
    output reg tlast,
    input tready ,
    input [1023 : 0] tx_data,
    input din_valid,
    input [9:0] word_count_latch
//    output reg fifo_rd_en
    );
    
    
    reg [3:0] ps,ns;
    reg data_avail;
    reg [9:0] transfer_count;
    

    wire [47:0] dest_add ;
    wire [47:0] src_add  ;
    wire [15:0] eth_type ;
  
    reg [1023 : 0] tx_data_reg;
    reg din_valid_d;
    
       
    localparam IDLE = 0;
    localparam WRITE1 = 1;
    localparam DONE = 10;
    
    assign dest_add = tx_data_reg[47:0];
    assign src_add  = tx_data_reg[97:48];
    assign eth_type = tx_data_reg[111:96];
    
    
    // one clock cycle delay of din_valid loaded in the din_valid_d
    always@(posedge clk)
     begin
        din_valid_d <= din_valid;  
     end
     
     // load the tx_data in the one of register(tx_data_reg) when we found the valid(din_valid) tx_data 
     // that tx_data_reg is availabel in the next clock cycle 
     // if the valid is not trigger then the tx_data_reg is having its previous loaded value 
    always@(posedge clk)
    begin 
       if(reset)
        begin 
          tx_data_reg<= 1024'h0;
        end
        
       else if(din_valid)
        begin
          tx_data_reg<= tx_data; 
        end
        
       else 
        begin 
         tx_data_reg<= tx_data_reg;
        end
    end
    

    // state transition happen like if reset found then in the IDLW state oresle in the next_state 
    always@(posedge clk)    // state transition logic
      begin
        if(reset)
          ps <= IDLE;
        else
          ps <= ns;
      end
      
      
      //logic of next state is written like 
      // if reset found the next_state is IDLE 
      // in the IDLE if we have din_valid_d found then next_state is to WRITE1 orelse it will stay in the IDLE 
      // in the WRITE1 if the data_avail is found then next_state is to WRITE1 orelse it will stay in the DONE 
      
     always@(*)    //next state logic
       begin
         if(reset)
          begin
          ns = IDLE;
          end
        
         else 
           begin
            case(ps)
            IDLE : begin
//                     fifo_rd_en = 1;
                     if(din_valid_d)
                     ns = WRITE1;
                     else
                     ns = IDLE;
                   end
            WRITE1 : begin
//                       fifo_rd_en = 0;
                     if(data_avail == 0)
                       ns = DONE;
                     else 
                       ns = WRITE1; 
                   end 
                   
            DONE : begin
//                      fifo_rd_en = 0;
                      ns = IDLE;
                   end
           endcase
           end                  
       end
       
       // combinational logic - which means it will check always without any respective to clock cycles
       // when the present_state is WRITE1 then it will look at whats the transfer_counter value is 
       // if the transfer_counter value is wordcount then tdata is loaded with the tx_data_reg and tlast is triggered 1 data_available is 0
       // if the transfer counter is not wordcount then tlast is 0 and data_available is 1 
       
     always @(*)
        begin
            tdata  = 32'd0;
            tvalid = 0;
            tuser  = 0;
            tlast  = 0;
            data_avail = 0;
        
                if(ps == WRITE1)
                begin
                    tvalid = 1;
                    data_avail = 1;
                
    //            if(transfer_count == payload_length + 14)
                if(transfer_count == word_count_latch )
                   begin
                      tdata  = tx_data_reg[(transfer_count)*32  +: 32];
                      tlast = 1;
                      data_avail = 0;
                      
                   end
                else 
                  begin
                      tdata = tx_data_reg[(transfer_count)*32  +: 32];
                      tlast = 0;
                      data_avail = 1;
                  end
                  end
        end
       
       
       //transfer counter when reset found then it is intializes to 0 
       // if we found the tvalid and tready is 1 then then transfer_counter is incremented by 1 
       // note tvalid will only be 1 when present state is WRITE1 orelse it will be in 0 
       // and also if we founf the present_state is WRITE1 then transfer counter will stays as it is 
       
      // in all other cases transfer counter is 0 
       always@(posedge clk)           
       begin
           if(reset)
             begin
                transfer_count <= 0;
             end
           else if(tvalid && tready)
             begin
                transfer_count <= transfer_count + 1;
             end 
           else if(ps == WRITE1)
             begin
                transfer_count <= transfer_count;
             end
           else
             begin
                transfer_count <= 0;
             end
           
       end
       
    
endmodule


