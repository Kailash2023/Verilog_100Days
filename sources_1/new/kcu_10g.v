`timescale 1ns / 1ps



module kcu_10g(
  input clk_20,
  input gt_ref_clk_0_clk_n,
  input gt_ref_clk_0_clk_p,
  input [0:0]gt_serial_port_0_grx_n,
  input [0:0]gt_serial_port_0_grx_p,
  output [0:0]gt_serial_port_0_gtx_n,
  output [0:0]gt_serial_port_0_gtx_p,
  output led_0,
  input reset,
  output tx_disable,
  output rs0,rs1,
  input tx_fault,
  input mod_abs,
  input rx_los
    );
    
    
    (*mark_debug = "true" *)wire signal_detect;
    (*mark_debug = "true" , keep = "true" *)wire tx_fault_w;
    (*mark_debug = "true" , keep = "true" *)wire mod_abs_w;
    (*mark_debug = "true" , keep = "true" *)wire rx_los_w;
    
    
    assign tx_disable = 0;
    assign rs0 = 0;
    assign rs1 = 0;
    assign signal_detect = !(rx_los || mod_abs);
    assign tx_fault_w = tx_fault;
    assign mod_abs_w = mod_abs;
    assign rx_los_w = rx_los;
    
    
    
  
    
    design_10g_wrapper inst_DUT(
     .clk_in1_0(clk_20),
     .gt_ref_clk_0_clk_n(gt_ref_clk_0_clk_n),
     .gt_ref_clk_0_clk_p(gt_ref_clk_0_clk_p),
     .gt_rx_0_gt_port_0_n(gt_serial_port_0_grx_n),
     .gt_rx_0_gt_port_0_p(gt_serial_port_0_grx_p),
     .gt_tx_0_gt_port_0_n(gt_serial_port_0_gtx_n),
     .gt_tx_0_gt_port_0_p(gt_serial_port_0_gtx_p),
     .led_0(led_0),
     .reset_0(reset),
     .signal_detect_0_0(signal_detect)
    );
endmodule
