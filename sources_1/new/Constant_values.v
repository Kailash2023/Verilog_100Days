`timescale 1ns / 1ps


module constant_values#(mac_address = 48'h020000000001, IP_address = 32'hc0a8010a)(
   input tx_reset,rx_reset,
   output [15:0] pause_val,
   output pause_req,
   output [4:0] config_vec_pcs_pma,
   output [15:0] an_adv_config_vec_pcs_pms,
   output  an_restart_config,
   output [79:0] rx_config_vector,
   output [79:0] tx_config_vector,
   output [7:0] tx_if_delay,
//   output signal_detect,
   output [47:0] mac_add,
   output [31:0] IP_add
    );
    
    

    wire [47:0] mac_add = 48'h020000000001;
    wire [15:0] max_frame_size = 16'h0000;
    wire max_frame_enable = 0;
    wire [1:0] speed = 2'b10;
    wire igp_enable = 0;
    wire half_duplex = 0;
    wire flow_cntrl_en = 1;
    wire jumbo_frame_en = 0;
    wire in_band_fcs_en = 0;
    wire vlan_en = 0;
    wire trans_en = 1;
    wire trans_rst = tx_reset;
    wire recv_rst = rx_reset;
    wire promise_mode = 0;
    wire frame_length_check_dis = 0;
    wire length_type_error_check = 0;
    
    
    assign mac_add = mac_address;
    assign IP_add = IP_address;
    assign pause_val = 16'h0000;
    assign pause_req = 0;
//    assign config_vec_pcs_pma = 5'h02;
    assign config_vec_pcs_pma = 5'b10000;
    assign an_adv_config_vec_pcs_pms = 16'b1101100000100001;
//    assign an_adv_config_vec_pcs_pms = 16'h0021;
    assign tx_if_delay = 8'h0C;
//    assign signal_detect = 1;
    assign an_restart_config = 0;
    
    
    
    assign tx_config_vector = {mac_add[7:0],mac_add[15:8],mac_add[23:16],mac_add[31:24],mac_add[39:32],mac_add[47:40],max_frame_size,1'b0,max_frame_enable,speed,3'b000,igp_enable,1'b0,half_duplex,flow_cntrl_en,jumbo_frame_en,in_band_fcs_en,vlan_en,trans_en,trans_rst};
    assign rx_config_vector = {mac_add[7:0],mac_add[15:8],mac_add[23:16],mac_add[31:24],mac_add[39:32],mac_add[47:40],max_frame_size,1'b0,max_frame_enable,speed,promise_mode,1'b0,frame_length_check_dis,length_type_error_check,1'b0,half_duplex,flow_cntrl_en,jumbo_frame_en,in_band_fcs_en,vlan_en,trans_en,recv_rst};
//    assign rx_config_vector = 80'h0605040302DA00002806;
    
endmodule
