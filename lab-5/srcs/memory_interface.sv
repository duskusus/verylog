`timescale 1ns / 1ps

module memory_interface(
    input logic[15:0] BUS, MDR_In,
    input logic MIO_EN, LD_MAR, LD_MDR, Clk, Reset,
    Data_from_SRAM,
    output logic[15:0] MAR, MDR
);
always_ff @ (posedge Clk)
begin
    if (Reset)
    begin
        MAR <= 0;
        MDR <= 0;
    end
    
    if(LD_MAR)
        MAR <= BUS;

    if(LD_MDR)
    begin
        if(MIO_EN)
            MDR <= MDR_In; // from memory
        else
            MDR <= BUS;
    end

end

endmodule
