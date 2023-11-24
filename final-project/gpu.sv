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
    input logic frame_clk,
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
logic [15:0] addra;
logic [16:0] addrb;
logic[3:0] wea;
logic [31:0] dina;
logic [15:0] doutb;

blk_mem_gen_0 vram(
  .addra(addra),
  .addrb(addrb),
  .clka(S_AXI_ACLK),
  .clkb(S_AXI_ACLK),
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
  .clkb(frame_clk)
);

logic isInside[warp_width];

always_comb begin
    fbX = DrawX / 2; // using 320 x 240 (quarter-res)
    fbY = DrawY / 2;
    px_idx = fbX + fbY * 320;
    addrb = px_idx;
end

always_ff @(posedge pixel_clk) begin

    Red <= doutb[15:11];
    Green <= doutb[10:5];
    Blue <= doutb[4:0];

    if(isInside[fbX])
      Red <= 31;

    for (int i = 0; i < 4; i++)
    begin
      if((fbX - vertices[i][0]) < 10 && (fbY - vertices[i][1]) < 10)
      begin
        Red <= 31;
        Green <= 63;
        Blue <= 31;
      end
    end

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
end

logic clearing;
logic [15:0] clear_mem_addr;

always_comb begin

// a axi read
wea = 4'd0;
dina = S_AXI_WDATA;
addra = S_AXI_AWADDR[ADDR_LSB+OPT_MEM_ADDR_BITS:ADDR_LSB];

//a axi write
if(slv_reg_wren) begin
  wea = S_AXI_WSTRB;
end else if(clearing) begin
  addra = clear_mem_addr;
  dina = 32'h0000; // replace with clear color from control reg later
end

if(~S_AXI_ARESETN)
  axi_rdata = 0;

end

//clear framebuffer
always_ff @(posedge S_AXI_ACLK) begin

clearing <= clearing;
clear_mem_addr <= clear_mem_addr;


  if(clear) begin
    clearing <= 1'd1;
    clear_mem_addr <= 16'd0;
  end else

  if(clearing) begin
    if(clear_mem_addr < 16'd38400)
      clear_mem_addr <= clear_mem_addr + 16'd1;
    else begin
      clear_mem_addr <= 0;
      clearing <= 0;
    end
  end
end

// read from gram
//logic [9:0] poly_idx;
logic [9:0] frame_idx;
always_ff @(posedge frame_clk)
begin
  vertices[0][0] <= gram_doutb[9:0];
  vertices[0][1] <= gram_doutb[25:16];
  vertices[1][0] <= gram_doutb[41:32];
  vertices[1][1] <= gram_doutb[57:48];
  veritces[2][0] <= gram_doutb[73:64];
  vertices[2][1] <= gram_doutb[89:80];
  vertices[3][0] <= gram_doutb[105:96];
  vertices[3][1] <= gram_doutb[121:112]

  gram_addra <= gram_addra;

  if(frame_idx < 60)
    frame_idx <= frame_idx + 1;
  else
  begin
    frame_idx <= 0;
    gram_addra <= gram_addra + 1;
  end

  if(gram_addra > 10'controlRegs[0])
    gram_addra <= 0;
end

always_comb begin
  vertices[0][0] = controlRegs[0][15:0];
  vertices[0][1] = controlRegs[0][31:16];
  vertices[1][0] = controlRegs[1][15:0];
  vertices[1][1] = controlRegs[1][31:16];
  vertices[2][0] = controlRegs[2][15:0];
  vertices[2][1] = controlRegs[2][31:16];
  vertices[3][0] = controlRegs[3][15:0];
  vertices[3][1] = controlRegs[3][31:16];
end

quad q(.vertices(vertices), .drawY(fbY), .isInside(isInside));
// user logic ends
endmodule