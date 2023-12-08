#create_clock -period 10.000 -name clk_100 -waveform {0.000 5.000} [get_ports Clk]

set_property IOSTANDARD LVCMOS33 [get_ports Clk]
set_property IOSTANDARD LVCMOS33 [get_ports reset_rtl_0]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_rxd]
set_property IOSTANDARD LVCMOS33 [get_ports uart_rtl_0_txd]
set_property PACKAGE_PIN N15 [get_ports Clk]
set_property PACKAGE_PIN J2 [get_ports reset_rtl_0]
set_property PACKAGE_PIN B16 [get_ports uart_rtl_0_rxd]
set_property PACKAGE_PIN A16 [get_ports uart_rtl_0_txd]

set_property IOSTANDARD LVCMOS33 [get_ports {gpio_usb_int_tri_i[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_miso]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_mosi]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_sclk]
set_property PACKAGE_PIN T13 [get_ports {gpio_usb_int_tri_i[0]}]
set_property PACKAGE_PIN V14 [get_ports usb_spi_sclk]
set_property PACKAGE_PIN V15 [get_ports usb_spi_mosi]
set_property PACKAGE_PIN U12 [get_ports usb_spi_miso]

set_property IOSTANDARD LVCMOS33 [get_ports gpio_usb_rst_tri_o]
set_property PACKAGE_PIN V13 [get_ports gpio_usb_rst_tri_o]
set_property PACKAGE_PIN T12 [get_ports usb_spi_ss]
set_property IOSTANDARD LVCMOS33 [get_ports usb_spi_ss]

#HDMI Signals
set_property -dict {PACKAGE_PIN V17 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_n]
set_property -dict {PACKAGE_PIN U16 IOSTANDARD TMDS_33} [get_ports hdmi_tmds_clk_p]

set_property -dict {PACKAGE_PIN U18 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[0]}]
set_property -dict {PACKAGE_PIN R17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[1]}]
set_property -dict {PACKAGE_PIN T14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_n[2]}]

set_property -dict {PACKAGE_PIN U17 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[0]}]
set_property -dict {PACKAGE_PIN R16 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[1]}]
set_property -dict {PACKAGE_PIN R14 IOSTANDARD TMDS_33} [get_ports {hdmi_tmds_data_p[2]}]

set_property IOSTANDARD LVCMOS33 [get_ports {buttons[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {buttons[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {buttons[0]}]
set_property PACKAGE_PIN J1 [get_ports {buttons[0]}]
set_property PACKAGE_PIN G2 [get_ports {buttons[1]}]
set_property PACKAGE_PIN H2 [get_ports {buttons[2]}]
