`timescale 1ns / 1ps

module toplevel(
     input logic Clk,
     input logic reset_rtl_0,
     
     //UART
     input logic uart_rtl_0_rxd,
     output logic uart_rtl_0_txd,
     
     //HDMI
     output logic hdmi_tmds_clk_n,
     output logic hdmi_tmds_clk_p,
     output logic [2:0]hdmi_tmds_data_n,
     output logic [2:0]hdmi_tmds_data_p,

     //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss
    );


  logic Clk_ext;
  logic [31:0]M01_AXI_0_ext_araddr;
  logic [1:0]M01_AXI_0_ext_arburst;
  logic [3:0]M01_AXI_0_ext_arcache;
  logic [7:0]M01_AXI_0_ext_arlen;
  logic [0:0]M01_AXI_0_ext_arlock;
  logic [2:0]M01_AXI_0_ext_arprot;
  logic [3:0]M01_AXI_0_ext_arqos;
  logic M01_AXI_0_ext_arready;
  logic [3:0]M01_AXI_0_ext_arregion;
  logic [2:0]M01_AXI_0_ext_arsize;
  logic M01_AXI_0_ext_arvalid;
  logic [31:0]M01_AXI_0_ext_awaddr;
  logic [1:0]M01_AXI_0_ext_awburst;
  logic [3:0]M01_AXI_0_ext_awcache;
  logic [7:0]M01_AXI_0_ext_awlen;
  logic [0:0]M01_AXI_0_ext_awlock;
  logic [2:0]M01_AXI_0_ext_awprot;
  logic [3:0]M01_AXI_0_ext_awqos;
  logic M01_AXI_0_ext_awready;
  logic [3:0]M01_AXI_0_ext_awregion;
  logic [2:0]M01_AXI_0_ext_awsize;
  logic M01_AXI_0_ext_awvalid;
  logic M01_AXI_0_ext_bready;
  logic [1:0]M01_AXI_0_ext_bresp;
  logic M01_AXI_0_ext_bvalid;
  logic [31:0]M01_AXI_0_ext_rdata;
  logic M01_AXI_0_ext_rlast;
  logic M01_AXI_0_ext_rready;
  logic [1:0]M01_AXI_0_ext_rresp;
  logic M01_AXI_0_ext_rvalid;
  logic [31:0]M01_AXI_0_ext_wdata;
  logic M01_AXI_0_ext_wlast;
  logic M01_AXI_0_ext_wready;
  logic [3:0]M01_AXI_0_ext_wstrb;
  logic M01_AXI_0_ext_wvalid;
  logic clk_100MHz;
  logic reset_rtl_0;
  logic s_axi_aclk_ext;
  logic [0:0]s_axi_aresetn_ext;
  logic gpio_clear_framebuffer;

      redstone redstone_i
       (.Clk_ext(Clk_ext),
        .M01_AXI_0_ext_araddr(M01_AXI_0_ext_araddr),
        .M01_AXI_0_ext_arburst(M01_AXI_0_ext_arburst),
        .M01_AXI_0_ext_arcache(M01_AXI_0_ext_arcache),
        .M01_AXI_0_ext_arlen(M01_AXI_0_ext_arlen),
        .M01_AXI_0_ext_arlock(M01_AXI_0_ext_arlock),
        .M01_AXI_0_ext_arprot(M01_AXI_0_ext_arprot),
        .M01_AXI_0_ext_arqos(M01_AXI_0_ext_arqos),
        .M01_AXI_0_ext_arready(M01_AXI_0_ext_arready),
        .M01_AXI_0_ext_arregion(M01_AXI_0_ext_arregion),
        .M01_AXI_0_ext_arsize(M01_AXI_0_ext_arsize),
        .M01_AXI_0_ext_arvalid(M01_AXI_0_ext_arvalid),
        .M01_AXI_0_ext_awaddr(M01_AXI_0_ext_awaddr),
        .M01_AXI_0_ext_awburst(M01_AXI_0_ext_awburst),
        .M01_AXI_0_ext_awcache(M01_AXI_0_ext_awcache),
        .M01_AXI_0_ext_awlen(M01_AXI_0_ext_awlen),
        .M01_AXI_0_ext_awlock(M01_AXI_0_ext_awlock),
        .M01_AXI_0_ext_awprot(M01_AXI_0_ext_awprot),
        .M01_AXI_0_ext_awqos(M01_AXI_0_ext_awqos),
        .M01_AXI_0_ext_awready(M01_AXI_0_ext_awready),
        .M01_AXI_0_ext_awregion(M01_AXI_0_ext_awregion),
        .M01_AXI_0_ext_awsize(M01_AXI_0_ext_awsize),
        .M01_AXI_0_ext_awvalid(M01_AXI_0_ext_awvalid),
        .M01_AXI_0_ext_bready(M01_AXI_0_ext_bready),
        .M01_AXI_0_ext_bresp(M01_AXI_0_ext_bresp),
        .M01_AXI_0_ext_bvalid(M01_AXI_0_ext_bvalid),
        .M01_AXI_0_ext_rdata(M01_AXI_0_ext_rdata),
        .M01_AXI_0_ext_rlast(M01_AXI_0_ext_rlast),
        .M01_AXI_0_ext_rready(M01_AXI_0_ext_rready),
        .M01_AXI_0_ext_rresp(M01_AXI_0_ext_rresp),
        .M01_AXI_0_ext_rvalid(M01_AXI_0_ext_rvalid),
        .M01_AXI_0_ext_wdata(M01_AXI_0_ext_wdata),
        .M01_AXI_0_ext_wlast(M01_AXI_0_ext_wlast),
        .M01_AXI_0_ext_wready(M01_AXI_0_ext_wready),
        .M01_AXI_0_ext_wstrb(M01_AXI_0_ext_wstrb),
        .M01_AXI_0_ext_wvalid(M01_AXI_0_ext_wvalid),
        .clk_100MHz(Clk),
        .reset_rtl_0(reset_ah),
        .s_axi_aclk_ext(s_axi_aclk_ext),
        .s_axi_aresetn_ext(s_axi_aresetn_ext),
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .gpio_rtl_0_tri_o(gpio_clear_framebuffer));


//additional logic variables as necessary to support VGA, and HDMI modules.
    //declaring logic here to be used between modules
    logic clk_25MHz, clk_125MHz; 
    logic locked;
    logic [9:0] drawX, drawY;

    logic hsync, vsync, vde, raster_clk;
    logic [4:0] red, blue;
    logic [5:0] green;
    logic reset_ah;
    assign reset_ah = ~reset_rtl_0;
    

    

// Instantiation of Axi Bus Interface AXI
    gpu # ( 
        .C_S_AXI_DATA_WIDTH(32),
        .C_S_AXI_ADDR_WIDTH(18)
    ) iPeeForce4090ti (
        .S_AXI_ACLK(s_axi_aclk_ext),
        .S_AXI_ARESETN(s_axi_aresetn_ext),
        .S_AXI_AWADDR(M01_AXI_0_ext_awaddr),
        .S_AXI_AWPROT(M01_AXI_0_ext_awprot),
        .S_AXI_AWVALID(M01_AXI_0_ext_awvalid),
        .S_AXI_AWREADY(M01_AXI_0_ext_awready),
        .S_AXI_WDATA(M01_AXI_0_ext_wdata),
        .S_AXI_WSTRB(M01_AXI_0_ext_wstrb),
        .S_AXI_WVALID(M01_AXI_0_ext_wvalid),
        .S_AXI_WREADY(M01_AXI_0_ext_wready),
        .S_AXI_BRESP(M01_AXI_0_ext_bresp),
        .S_AXI_BVALID(M01_AXI_0_ext_bvalid),
        .S_AXI_BREADY(M01_AXI_0_ext_bready),
        .S_AXI_ARADDR(M01_AXI_0_ext_araddr),
        .S_AXI_ARPROT(M01_AXI_0_ext_arprot),
        .S_AXI_ARVALID(M01_AXI_0_ext_arvalid),
        .S_AXI_ARREADY(M01_AXI_0_ext_arready),
        .S_AXI_RDATA(M01_AXI_0_ext_rdata),
        .S_AXI_RRESP(axi_rresp),
        .S_AXI_RVALID(axi_rvalid),
        .S_AXI_RREADY(axi_rready),
        
        .Green(green),
        .Blue(blue),
        .Red(red),
        .DrawX(drawX),
        .DrawY(drawY), 
        .pixel_clk(clk_25MHz),
        .raster_clk(raster_clk),
        .clear(gpio_clear_framebuffer)
    );
    
    
    //Instiante clocking wizard, VGA sync generator modules, and VGA-HDMI IP here. For a hint, refer to the provided
    //top-level from the previous lab. You should get the IP to generate a valid HDMI signal (e.g. blue screen or gradient)
    //prior to working on the text drawing.
    
            
        //clock wizard configured with a 1x and 5x clock for HDMI
        clk_wiz_0 clk_wiz (
            .clk_out1(clk_25MHz),
            .clk_out2(clk_125MHz),
            .clk_out3(raster_clk),
            .reset(reset_rtl_0),
            .locked(locked),
            .clk_in1(Clk)
        );

    
        
        //VGA Sync signal generator
        vga_controller vga (
            .pixel_clk(clk_25MHz),
            .reset(reset_rtl_0),
            .hs(hsync),
            .vs(vsync),
            .active_nblank(vde),
            .drawX(drawX),
            .drawY(drawY)
        );    
    
        //Real Digital VGA to HDMI converter
        hdmi_tx_0 vga_to_hdmi (
            //Clocking and Reset
            .pix_clk(clk_25MHz),
            .pix_clkx5(clk_125MHz),
            .pix_clk_locked(locked),
            //Reset is active LOW
            .rst(reset_rtl_0),
            //Color and Sync Signals
            .red(red),
            .green(green),
            .blue(blue),
            .hsync(hsync),
            .vsync(vsync),
            .vde(vde),
            
            //aux Data (unused)
            .aux0_din(4'b0),
            .aux1_din(4'b0),
            .aux2_din(4'b0),
            .ade(1'b0),
            
            
            //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)           
        );

endmodule
