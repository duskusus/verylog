`timescale 1ns / 1ps

module register_unit (input  logic Clk, Reset, LD_REG, 
                      input  logic [15:0]  BUS, 
                      input logic [2:0]  SR2, SR1MUX, DRMUX,
                      output logic [15:0]  SR1out, SR2out
                      );

    //internal logic
    logic [15:0] A, B, C, D, E, F, G, H;
    logic [15:0] R0, R1, R2, R3, R4, R5, R6, R7;
    logic ldA, ldB, ldC, ldD, ldE, ldF, ldG, ldH;

    always_comb begin
        R0 = A;
        R1 = B;
        R2 = C;
        R3 = D;
        R4 = E;
        R5 = F;
        R6 = G;
        R7 = H;
    end

    //registers
    reg_16  reg_A (.*, .Load(ldA), .Data_Out(A));

    reg_16  reg_B (.*, .Load(ldB), .Data_Out(B));

    reg_16  reg_C (.*, .Load(ldC), .Data_Out(C));

    reg_16  reg_D (.*, .Load(ldD), .Data_Out(D));



    reg_16  reg_E (.*, .Load(ldE), .Data_Out(E));

    reg_16  reg_F (.*, .Load(ldF), .Data_Out(F));

    reg_16  reg_G (.*, .Load(ldG), .Data_Out(G));

    reg_16  reg_H (.*, .Load(ldH), .Data_Out(H));

    //DR selctor
    mux_1_8 drselect (.*, .DRselect(DRMUX), .ldA(ldA), .ldB(ldB), .ldC(ldC), .ldD(ldD), 
                                            .ldE(ldE), .ldF(ldF), .ldG(ldG), .ldH(ldH));
    //SR1 selector
    mux_8_1 sr1select (.*, .SRselect(SR1MUX), .SRreg(SR1out));
    //SR2 selctor
    mux_8_1 sr2select (.*, .SRselect(SR2), .SRreg(SR2out));
endmodule
