## HDMI out constraints file. Can be used in Arty-Z7-20, Pynq-Z1, and Pynq-Z2 since they share the same pinout

## Clock signal 125 MHz
set_property -dict { PACKAGE_PIN H16   IOSTANDARD LVCMOS33 } [get_ports { clk }]; #IO_L13P_T2_MRCC_35 Sch=sysclk
create_clock -add -name sys_clk_pin -period 8.00 -waveform {0 4} [get_ports { clk }];

##Buttons
set_property -dict { PACKAGE_PIN D19   IOSTANDARD LVCMOS33 } [get_ports { rst }]; #IO_L4P_T0_35 Sch=btn[0]

##HDMI Tx
set_property -dict { PACKAGE_PIN L17   IOSTANDARD TMDS_33  } [get_ports { clk_n }]; #IO_L11N_T1_SRCC_35 Sch=hdmi_tx_clk_n
set_property -dict { PACKAGE_PIN L16   IOSTANDARD TMDS_33  } [get_ports { clk_p }]; #IO_L11P_T1_SRCC_35 Sch=hdmi_tx_clk_p
set_property -dict { PACKAGE_PIN K18   IOSTANDARD TMDS_33  } [get_ports { data_n[0] }]; #IO_L12N_T1_MRCC_35 Sch=hdmi_tx_d_n[0]
set_property -dict { PACKAGE_PIN K17   IOSTANDARD TMDS_33  } [get_ports { data_p[0] }]; #IO_L12P_T1_MRCC_35 Sch=hdmi_tx_d_p[0]
set_property -dict { PACKAGE_PIN J19   IOSTANDARD TMDS_33  } [get_ports { data_n[1] }]; #IO_L10N_T1_AD11N_35 Sch=hdmi_tx_d_n[1]
set_property -dict { PACKAGE_PIN K19   IOSTANDARD TMDS_33  } [get_ports { data_p[1] }]; #IO_L10P_T1_AD11P_35 Sch=hdmi_tx_d_p[1]
set_property -dict { PACKAGE_PIN H18   IOSTANDARD TMDS_33  } [get_ports { data_n[2] }]; #IO_L14N_T2_AD4N_SRCC_35 Sch=hdmi_tx_d_n[2]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD TMDS_33  } [get_ports { data_p[2] }]; #IO_L14P_T2_AD4P_SRCC_35 Sch=hdmi_tx_d_p[2]
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_hpdn }]; #IO_0_34 Sch=hdmi_tx_hpdn
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }]; #IO_L19N_T3_VREF_35 Sch=hdmi_tx_cec
