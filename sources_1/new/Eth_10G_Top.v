`timescale 1ns / 1ps



module Eth_10G_top(
  input clk_156_p,clk_156_n,
  input clk_20,
  input reset,
  input mod_abs,
  input rx_los,
  input tx_fault,
  output tx_disable,
  output rs0,rs1,
  output txd_p,txd_n,
  input rxd_p,rxd_n,
  inout scl,
  inout sda

    );
    
    wire signal_detect;
    
    assign signal_detect = !(mod_abs || rx_los ); 
    assign rs0 = 0;
    assign rs1 = 0;
    
    Eth_10g_wrapper inst_DUT(
        .axis_rx_0_0_tdata(),
        .axis_rx_0_0_tkeep(),
        .axis_rx_0_0_tlast(),
        .axis_rx_0_0_tuser(),
        .axis_rx_0_0_tvalid(),
        .dclk_0(clk_20),
        .gt_ref_clk_0_clk_n(clk_156_n),
        .gt_ref_clk_0_clk_p(clk_156_p),
        .gt_rx_0_gt_port_0_n(rxd_n),
        .gt_rx_0_gt_port_0_p(rxd_p),
        .gt_tx_0_gt_port_0_n(txd_n),
        .gt_tx_0_gt_port_0_p(txd_p),
        .reset_0(reset),
        .signal_detect_0_0(signal_detect),
        .tx_disable_0(tx_disable)
//        .tx_preamble(56'hAAAAAAAAAAAAAA)
    );
endmodule
  