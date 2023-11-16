`timescale 1ns / 1ps


module pipeline(

        input logic Clk, pixel_clk,
        input logic clear,
        input logic [9:0] fbX, fbY,
        input logic [15:0] primitive_count,
        input logic [15:0] clear_color,
        
        output logic [15:0] current_prim, 
        input logic [255:0] gmem_dout,

        output logic [4:0] Red, Blue,
        output logic [5:0] Green

    );

    localparam reg_count = 320;
    logic isInside[320];
    logic [15:0] row[reg_count];          // row (tile) buffer
    logic [15:0] rowdump_addr;      // address to store row
    logic [8:0] vertices[4][2];     // vertices of current prim
    logic [15:0] color;             // color of current prim

    logic [16:0] fb_waddr, fb_raddr;
    logic [3:0]  fb_wea;
    logic [31:0] fb_din;
    logic [15:0] fb_dout;

    logic dump;
    logic [7:0] row_part;
    logic [7:0] current_row;

    // control fsm
    always_ff @(posedge Clk)
    begin
        current_prim <= current_prim + 1;
        dump <= dump;
        row_part <= 0;

        if(current_prim == primitive_count)
        begin
            dump <= 1;
        end

        if(row_part == 80)
        begin
            dump <= 0;
            current_row <= current_row + 1;
        end

        if(dump)
        begin
            row_part <= row_part + 1;
            current_prim <= 0;
        end

        if(current_row == 240)
        begin
            current_row <= 0;
        end
    end

    // sequential pipeline for vertex & color data
    always_ff @(posedge Clk)
    begin

        vertices <= vertices;
        color <= color;
        for (int i = 0; i < reg_count; i++)
            row[i] <= row[i];

        // STAGE 1 - data is read from geometry memory
        if(!dump)
        begin
            vertices[0][0] <= gmem_dout[8:0];
            vertices[0][1] <= gmem_dout[24:16];

            vertices[1][0] <= gmem_dout[40:32];
            vertices[1][1] <= gmem_dout[56:48];

            vertices[2][0] <= gmem_dout[72:64];
            vertices[2][1] <= gmem_dout[88:80];

            vertices[3][0] <= gmem_dout[104:96];
            vertices[3][1] <= gmem_dout[120:112];

            color <= gmem_dout[136:128];

            // STAGE 1(.5) - vertices are transformed by matrix
            // this is done on microblaze for now

            // STAGE 2 - row is updated with output of quad
            for (int i = 0; i < 320; i++)
            begin
                if(isInside[i])
                    row[i] <= color;
                else
                    row[i] <= row[i];
            end
        end
    end

    // read framebuffer to vga signals
    assign fb_raddr = fbX + fbY * 320;
    always_ff @ (posedge pixel_clk)
    begin
        Red <= fb_dout[15:11];
        Green <= fb_dout[10:5];
        Blue <= fb_dout[4:0];
    end

    // fsm to clear framebuffer
    logic clearing;
    logic [15:0] clear_mem_addr;

    always_ff @(posedge pixel_clk)
    begin

        clearing <= clearing;
        clear_mem_addr <= clear_mem_addr;


        if(clear && !clearing)
        begin
            clearing <= 1'd1;
            clear_mem_addr <= 16'd0;
        end
        else if(clearing)
        begin
            if(clear_mem_addr < 16'd38400)
                clear_mem_addr <= clear_mem_addr + 16'd1;
            else
            begin
                clear_mem_addr <= 0;
                clearing <= 0;
            end
        end
    end

    // comb logic do decide memory inputs and outputs based on control signals
    always_comb
    begin
        fb_waddr = rowdump_addr;
        fb_din = {row[row_part * 2], row[(row_part * 2) + 1]};
        fb_wea = 4'b0000;

        if(clearing)
        begin
            fb_waddr = clear_mem_addr;
            fb_din  = clear_color;
            fb_wea = 4'b1111;
        end

        if(dump)
        begin
            fb_wea = 4'b1111;
            fb_waddr = row_part + current_row * 160;
        end
    end


    blk_mem_gen_0 fb(
      .addra(fb_waddr),
      .addrb(fb_raddr),
      .clka(Clk),
      .clkb(pixel_clk),
      .wea(fb_wea),
      .ena(1),
      .doutb(fb_dout),
      .dina(fb_din)
    );

    quad q(.vertices(vertices), .drawY(current_row), .isInside(isInside));

endmodule
