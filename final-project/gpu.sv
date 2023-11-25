`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: ECE-Illinois
// Engineer: Zuofu Cheng
// 
// Create Date: 06/08/2023 12:21:05 PM
// Design Name: 
// Module Name: hdmi_text_controller_v1_0_AXI
// Project Name: ECE 385 - hdmi_text_controller
// Target Devices: 
// Tool Versions: 
// Description: 
// This is a modified version of the Vivado template for an AXI4-Lite peripheral,
// rewritten into SystemVerilog for use with ECE 385.
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


`timescale 1 ns / 1 ps

module gpu #
(
    // Users to add parameters here
    parameter integer Reg_Count = 1200,
    parameter integer warp_width = 320,
    // User parameters ends
    // Do not modify the parameters beyond this line
    // comment to force resynthesis
    // Width of S_AXI data bus
    parameter integer C_S_AXI_DATA_WIDTH	= 32,
    // Width of S_AXI address bus
    parameter integer C_S_AXI_ADDR_WIDTH	= 16 //needed for the addresses
)
(
    input logic clear,
    // Users to add ports here
    input logic [9:0] DrawX, DrawY, //inputing drawx and drawy to make the color mapper in here
    output logic [4:0] Red, Blue, //outputting rgb to make the color mapper in here 
    output logic [5:0] Green,
    input pixel_clk, //clock to run the color mapping off of
    input logic raster_clk,
    // User ports ends
    // Do not modify the ports beyond this line

    // Global Clock Signal
    input logic  S_AXI_ACLK,
    // Global Reset Signal. This Signal is Active LOW
    input logic  S_AXI_ARESETN,
    // Write address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    // Write channel Protection type. This signal indicates the
        // privilege and security level of the transaction, and whether
        // the transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_AWPROT,
    // Write address valid. This signal indicates that the master signaling
        // valid write address and control information.
    input logic  S_AXI_AWVALID,
    // Write address ready. This signal indicates that the slave is ready
        // to accept an address and associated control signals.
    output logic  S_AXI_AWREADY,
    // Write data (issued by master, acceped by Slave) 
    input logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    // Write strobes. This signal indicates which byte lanes hold
        // valid data. There is one write strobe bit for each eight
        // bits of the write data bus.    
    input logic [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    // Write valid. This signal indicates that valid write
        // data and strobes are available.
    input logic  S_AXI_WVALID,
    // Write ready. This signal indicates that the slave
        // can accept the write data.
    output logic  S_AXI_WREADY,
    // Write response. This signal indicates the status
        // of the write transaction.
    output logic [1 : 0] S_AXI_BRESP,
    // Write response valid. This signal indicates that the channel
        // is signaling a valid write response.
    output logic  S_AXI_BVALID,
    // Response ready. This signal indicates that the master
        // can accept a write response.
    input logic  S_AXI_BREADY,
    // Read address (issued by master, acceped by Slave)
    input logic [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    // Protection type. This signal indicates the privilege
        // and security level of the transaction, and whether the
        // transaction is a data access or an instruction access.
    input logic [2 : 0] S_AXI_ARPROT,
    // Read address valid. This signal indicates that the channel
        // is signaling valid read address and control information.
    input logic  S_AXI_ARVALID,
    // Read address ready. This signal indicates that the slave is
        // ready to accept an address and associated control signals.
    output logic  S_AXI_ARREADY,
    // Read data (issued by slave)
    output logic [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    // Read response. This signal indicates the status of the
        // read transfer.
    output logic [1 : 0] S_AXI_RRESP,
    // Read valid. This signal indicates that the channel is
        // signaling the required read data.
    output logic  S_AXI_RVALID,
    // Read ready. This signal indicates that the master can
        // accept the read data and response information.
    input logic  S_AXI_RREADY
);

// AXI4LITE signals
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_awaddr;
logic  axi_awready;
logic  axi_wready;
logic  [1 : 0] 	axi_bresp;
logic  axi_bvalid;
logic  [C_S_AXI_ADDR_WIDTH-1 : 0] 	axi_araddr;
logic  axi_arready;
logic  [C_S_AXI_DATA_WIDTH-1 : 0] 	axi_rdata;
logic  [1 : 0] 	axi_rresp;
logic  	axi_rvalid;

// Example-specific design signals
// local parameter for addressing 32 bit / 64 bit C_S_AXI_DATA_WIDTH
// ADDR_LSB is used for addressing 32/64 bit registers/memories
// ADDR_LSB = 2 for 32 bits (n downto 2)
// ADDR_LSB = 3 for 64 bits (n downto 3)
localparam integer ADDR_LSB = (C_S_AXI_DATA_WIDTH/32) + 1;
localparam integer OPT_MEM_ADDR_BITS = 15; //creating a mask so that we can use only the 10bits required for address for the 601 registers


logic	 slv_reg_rden;
logic	 slv_reg_wren;
logic [C_S_AXI_DATA_WIDTH-1:0]	 reg_data_out;
integer	 byte_index;
logic	 aw_en;

// I/O Connections assignments

assign S_AXI_AWREADY	= axi_awready;
assign S_AXI_WREADY	= axi_wready;
assign S_AXI_BRESP	= axi_bresp;
assign S_AXI_BVALID	= axi_bvalid;
assign S_AXI_ARREADY	= axi_arready;
assign S_AXI_RDATA	= axi_rdata;
assign S_AXI_RRESP	= axi_rresp;
assign S_AXI_RVALID	= axi_rvalid;
// Implement axi_awready generation
// axi_awready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_awready is
// de-asserted when reset is low.

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awready <= 1'b0;
      aw_en <= 1'b1;
    end 
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // slave is ready to accept write address when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_awready <= 1'b1;
          aw_en <= 1'b0;
        end
        else if (S_AXI_BREADY && axi_bvalid)
            begin
              aw_en <= 1'b1;
              axi_awready <= 1'b0;
            end
      else           
        begin
          axi_awready <= 1'b0;
        end
    end 
end       

// Implement axi_awaddr latching
// This process is used to latch the address when both 
// S_AXI_AWVALID and S_AXI_WVALID are valid. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_awaddr <= 0;
    end 
  else
    begin    
      if (~axi_awready && S_AXI_AWVALID && S_AXI_WVALID && aw_en)
        begin
          // Write Address latching 
          axi_awaddr <= S_AXI_AWADDR;
        end
    end 
end       

// Implement axi_wready generation
// axi_wready is asserted for one S_AXI_ACLK clock cycle when both
// S_AXI_AWVALID and S_AXI_WVALID are asserted. axi_wready is 
// de-asserted when reset is low. 

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_wready <= 1'b0;
    end 
  else
    begin    
      if (~axi_wready && S_AXI_WVALID && S_AXI_AWVALID && aw_en )
        begin
          // slave is ready to accept write data when 
          // there is a valid write address and write data
          // on the write address and data bus. This design 
          // expects no outstanding transactions. 
          axi_wready <= 1'b1;
        end
      else
        begin
          axi_wready <= 1'b0;
        end
    end 
end       

assign slv_reg_wren = axi_wready && S_AXI_WVALID && axi_awready && S_AXI_AWVALID;

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_bvalid  <= 0;
      axi_bresp   <= 2'b0;
    end 
  else
    begin    
      if (axi_awready && S_AXI_AWVALID && ~axi_bvalid && axi_wready && S_AXI_WVALID)
        begin
          // indicates a valid write response is available
          axi_bvalid <= 1'b1;
          axi_bresp  <= 2'b0; // 'OKAY' response 
        end                   // work error responses in future
      else
        begin
          if (S_AXI_BREADY && axi_bvalid) 
            //check if bready is asserted while bvalid is high) 
            //(there is a possibility that bready is always asserted high)   
            begin
              axi_bvalid <= 1'b0; 
            end  
        end
    end
end   

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_arready <= 1'b0;
      axi_araddr  <= 32'b0;
    end 
  else
    begin    
      if (~axi_arready && S_AXI_ARVALID)
        begin
          // indicates that the slave has acceped the valid read address
          axi_arready <= 1'b1;
          // Read address latching
          axi_araddr  <= S_AXI_ARADDR;
        end
      else
        begin
          axi_arready <= 1'b0;
        end
    end 
end       

always_ff @( posedge S_AXI_ACLK )
begin
  if ( S_AXI_ARESETN == 1'b0 )
    begin
      axi_rvalid <= 0;
      axi_rresp  <= 0;
    end 
  else
    begin    
      if (axi_arready && S_AXI_ARVALID && ~axi_rvalid)
        begin
          // Valid read data is available at the read data bus
          axi_rvalid <= 1'b1;
          axi_rresp  <= 2'b0; // 'OKAY' response
        end   
      else if (axi_rvalid && S_AXI_RREADY)
        begin
          // Read data is accepted by the master
          axi_rvalid <= 1'b0;
        end                
    end
end    

assign slv_reg_rden = axi_arready & S_AXI_ARVALID & ~axi_rvalid;

logic [31:0] controlRegs[15:0];
logic [16:0] px_idx;
logic [9:0] fbX, fbY;

//vram
logic [8:0] addra;
logic [13:0] addrb;
logic wea;
logic [2559:0] dina;
logic [79:0] doutb;

blk_mem_gen_0 vram(
  .addra(addra),
  .addrb(addrb),
  .clka(raster_clk),
  .clkb(pixel_clk),
  .wea(wea),
  .ena(1),
  .enb(1),
  .doutb(doutb),
  .dina(dina)
);

// gram
logic [9:0] gram_addra;
logic [7:0] gram_addrb;
logic [3:0] gram_wea;
logic [31:0] gram_dina;
logic [127:0] gram_doutb;
logic [9:0] vertices[4][2];

blk_mem_gen_1 gram(
  .addra(gram_addra),
  .addrb(gram_addrb),
  .wea(gram_wea),
  .dina(gram_dina),
  .doutb(gram_doutb),
  .ena(1),
  .enb(1),
  .clka(S_AXI_ACLK),
  .clkb(raster_clk)
);

enum logic [2:0] {
  run,
  flushLeft,
  flushRight
} rasterState;
logic [9:0] rowIndex;

logic [15:0] color_in;
always_comb begin
    fbX = DrawX / 2; // using 320 x 240 (quarter-res)
    fbY = DrawY / 2;
    px_idx = fbX + fbY * 320;
    addrb = (px_idx + 1) / 5; // doutb is 80 bits, 80/16 = 5 -> 5 pixels per address
    color_in = doutb[((px_idx%5)*16)+:16];
/*
    //magic debug square
    if(fbX < 50 && fbY < 50)
    begin
      if(rasterState == run)
        color_in[4:0] = 31;
      if(rasterState == flushLeft)
        color_in[10:5] = 63;
      if(rasterState == flushRight || ((fbY - gram_addrb) < 5) || px_idx < gram_addrb)
        color_in[15:11] = 31;
    end
*/
end

always_ff @(posedge pixel_clk) begin
    
    Red <= color_in[15:11];
    Green <= color_in[10:5];
    Blue <= color_in[4:0];
end

always_ff @ (posedge S_AXI_ACLK)
begin
    for(int i = 0; i < 8; i++)
      controlRegs[i] <= controlRegs[i];

  //axi_awaddr[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB]
  if(slv_reg_wren &&  axi_awaddr[13])
  begin

    for(int j = 0; j < 4; j++)
      if(S_AXI_WSTRB[j] == 1)
        controlRegs[axi_awaddr[5:2]][(j*8) +: 8] <= S_AXI_WDATA[(j*8) +: 8];
  end
end;

always_comb begin
// a axi read
axi_rdata = 0;

// gram write
gram_wea = 4'd0;
gram_dina = S_AXI_WDATA;
gram_addra = S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

if(slv_reg_wren)
  gram_wea = S_AXI_WSTRB;
end

// read from gram

logic isInside[320];
logic [15:0] rowRegs[320];

always_ff @(posedge raster_clk)
begin
  // defaults
  wea <= 0;
  for (int i = 0; i < 320; i++)
    rowRegs[i] <= rowRegs[i];
  dina <= 0;
  addra <= 2 * rowIndex;
  
  // load from memory
  vertices[0][0] <= gram_doutb[9:0];
  vertices[0][1] <= gram_doutb[25:16];
  vertices[1][0] <= gram_doutb[41:32];
  vertices[1][1] <= gram_doutb[57:48];
  vertices[2][0] <= gram_doutb[73:64];
  vertices[2][1] <= gram_doutb[89:80];
  vertices[3][0] <= gram_doutb[105:96];
  vertices[3][1] <= gram_doutb[121:112];

  if(rasterState == run)
  begin

    // update row regs
    for (int i = 0; i < 320; i++)
    begin
      // z test goes here
      if(isInside[i])
        rowRegs[i] <= (gram_addrb) | ((64 - gram_addrb) << 5);
    end

    gram_addrb <= gram_addrb + 1;

    // continue to flushLeft
    if(gram_addrb > controlRegs[0])
    begin
      rasterState <= flushLeft;
    end
  end
  else if(rasterState == flushLeft)
  begin

    rasterState <= flushRight;
    addra <= 2 * rowIndex;
    wea <= 1;

    // flush left column
    for (int i = 0; i < 160; i++)
    begin
      dina[(16*i)+:16] <= rowRegs[i];
    end

  end
  else if(rasterState == flushRight)
  begin

    rasterState <= run;
    addra <= 2 * rowIndex + 1;
    wea <= 1;

    rowIndex <= rowIndex + 1; // move on to next row
    if(rowIndex > 240)
      rowIndex <= 0;

    // flush right column
    for (int i = 0; i < 160; i++)
    begin
      dina[(16*i)+:16] <= rowRegs[i + 160];
    end

    // clear regs
    for (int i = 0; i < 320; i++)
      rowRegs[i] <= controlRegs[1]; // clearColor

    gram_addrb <= 0;

  end

  if(clear)
  begin
    rasterState <= run;
    rowIndex <= 0;
    gram_addrb <= 0;
    for (int i = 0; i < 320; i++)
      rowRegs[i] <= controlRegs[1]; // clear color
  end

end

quad q(.vertices(vertices), .drawY(rowIndex), .isInside(isInside));
// user logic ends
endmodule