## HDMI out constraints file. Can be used in Enclustra artix7 kit

## Clock signal 50 MHz
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { clk }]; 
create_clock -add -name sys_clk_pin -period 20.00 -waveform {0 4} [get_ports { clk }];

##Buttons
set_property -dict { PACKAGE_PIN F1   IOSTANDARD LVCMOS33 } [get_ports { rst }];

##HDMI Tx

set_property -dict { PACKAGE_PIN A4 IOSTANDARD TMDS_33 } [get_ports { data_p[2] }];
set_property -dict { PACKAGE_PIN A3 IOSTANDARD TMDS_33 } [get_ports { data_n[2] }];
set_property -dict { PACKAGE_PIN B7 IOSTANDARD TMDS_33 } [get_ports { data_p[1] }];
set_property -dict { PACKAGE_PIN B6 IOSTANDARD TMDS_33 } [get_ports { data_n[1] }];
set_property -dict { PACKAGE_PIN A6 IOSTANDARD TMDS_33 } [get_ports { data_p[0] }];
set_property -dict { PACKAGE_PIN A5 IOSTANDARD TMDS_33 } [get_ports { data_n[0] }];
set_property -dict { PACKAGE_PIN D5 IOSTANDARD TMDS_33 } [get_ports { clk_p }];
set_property -dict { PACKAGE_PIN D4 IOSTANDARD TMDS_33 } [get_ports { clk_n }];
#set_property -dict { PACKAGE_PIN R19   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_hpdn }];
#set_property -dict { PACKAGE_PIN G15   IOSTANDARD LVCMOS33 } [get_ports { hdmi_tx_cec }];
