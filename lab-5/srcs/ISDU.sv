//------------------------------------------------------------------------------
// Company:          UIUC ECE Dept.
// Engineer:         Stephen Kempf
//
// Create Date:    17:44:03 10/08/06
// Design Name:    ECE 385 Given Code - Incomplete ISDU for SLC-3
// Module Name:    ISDU - Behavioral
//
// Comments:
//    Revised 03-22-2007
//    Spring 2007 Distribution
//    Revised 07-26-2013
//    Spring 2015 Distribution
//    Revised 02-13-2017
//    Spring 2017 Distribution
//    Revised 07-25-2023
//    Xilinx Vivado
//------------------------------------------------------------------------------
`include "SLC3_2.sv"
import SLC3_2::*;

module ISDU (   input logic         Clk, 
									Reset,
									Run,
									Continue,
									
				input logic[3:0]    Opcode, 
				input logic         IR_5,
				input logic         IR_11,
				input logic         BEN,
				  
				output logic        LD_MAR,
									LD_MDR,
									LD_IR,
									LD_BEN,
									LD_CC,
									LD_REG,
									LD_PC,
									LD_LED, // for PAUSE instruction
									
				output logic        GatePC,
									GateMDR,
									GateALU,
									GateMARMUX,
									
				output logic [1:0]  PCMUX,
				output logic        DRMUX,
									SR1MUX,
									SR2MUX,
									ADDR1MUX,
				output logic [1:0]  ADDR2MUX,
									ALUK,
				  
				output logic        Mem_OE,
									Mem_WE
				);

	enum logic [5:0] {  Halted, 
						PauseIR1, 
						PauseIR2,
						S_00, S_01, S_02, S_03, S_04, S_05, S_06, S_07, S_08,
						S_09, S_10, S_11, S_12, S_13, S_14, S_15, S_17,
						S_18, S_19, S_20, S_21, S_22, S_23, S_24, S_26,
						S_27, S_28, S_29, S_30, S_31, S_32, S_34, S_35,
						S_33_1, S_33_2, S_33_3, S_33_4,
						S_25_1, S_25_2, S_25_3, S_25_4,
						S_16_1, S_16_2, S_16_3, S_16_4
						}   State, Next_state;   // Internal state logic
		
	always_ff @ (posedge Clk)
	begin
		if (Reset) 
			State <= Halted;
		else 
			State <= Next_state;
	end
   
	always_comb
	begin 
		// Default next state is staying at current state
		Next_state = State;
		
		// Default controls signal values
		LD_MAR = 1'b0;
		LD_MDR = 1'b0;
		LD_IR = 1'b0;
		LD_BEN = 1'b0;
		LD_CC = 1'b0;
		LD_REG = 1'b0;
		LD_PC = 1'b0;
		LD_LED = 1'b0;
		 
		GatePC = 1'b0;
		GateMDR = 1'b0;
		GateALU = 1'b0;
		GateMARMUX = 1'b0;
		 
		ALUK = 2'b00;
		 
		PCMUX = 2'b00;
		DRMUX = 1'b0;
		SR1MUX = 1'b0;
		SR2MUX = 1'b0;
		ADDR1MUX = 1'b0;
		ADDR2MUX = 2'b00;
		 
		Mem_OE = 1'b0;
		Mem_WE = 1'b0;
	
		// Assign next state
		unique case (State)
			Halted : 
				if (Run) 
					Next_state = S_18;
			S_18 : 
				Next_state = S_33_1; //Notice that we usually have 'R' here, but you will need to add extra states instead 
			S_33_1 :                 //e.g. S_33_2, etc. How many? As a hint, note that the BRAM is synchronous, in addition, 
				Next_state = S_33_2;   //it has an additional output register.
			S_33_2 :
				Next_state = S_33_3;
			S_33_3 :
				Next_state = S_33_4;
			S_33_4 :
				Next_state = S_35;
			S_35 : 
				Next_state = S_32;
			// PauseIR1 and PauseIR2 are only for Week 1 such that TAs can see 
			// the values in IR.
			PauseIR1 : 
				if (~Continue) 
					Next_state = PauseIR1;
				else 
					Next_state = PauseIR2;
			PauseIR2 : 
				if (Continue) 
					Next_state = PauseIR2;
				else 
					Next_state = S_18;
			S_01 : //add
				Next_state = S_18;

			S_05 : //and
				Next_state = S_18;

			S_09 : //not
				Next_state = S_18;

			S_06 : //LDR
				Next_state = S_25_1;
			S_25_1 : //pause states for LDR
				Next_state = S_25_2;   
			S_25_2 :
				Next_state = S_25_3;
			S_25_3 :
				Next_state = S_25_4;
			S_25_4 :
				Next_state = S_27;
			S_27 : //DR<-MDR, set CC
				Next_state = S_18;	
			S_07 : //STR
				Next_state = S_23;
			S_23 : 	//MDR <-SR
				Next_state = S_16_1;
			S_16_1 ://pause states for STR
				Next_state = S_16_2;   
			S_16_2 :
				Next_state = S_16_3;
			S_16_3 :
				Next_state = S_16_4;
			S_16_4 :
				Next_state = S_18;

			S_04 : //JSR, R7<- PC
				Next_state = S_21;
			S_21 : //PC <- PC +off11
				Next_state = S_18;

			S_12 : //JMP, PC <- BaseR
				Next_state = S_18;

            S_00 : //BR, [BEN]
                if (BEN) 
					Next_state = S_22;
				else 
					Next_state = S_18;

            S_22: //PC <- PC +off9
                Next_state = S_18;

			S_32 : 
				case (Opcode)
					op_ADD : 
                        Next_state = S_01;
                    op_AND:
                        Next_state = S_05;
                    op_NOT:
                        Next_state = S_09;
                    op_BR:
                        Next_state = S_00;
                    op_JMP:
                        Next_state = S_12;
                    op_JSR:
                        Next_state = S_04;
                    op_LDR:
                        Next_state = S_06;
                    op_STR:
                        Next_state = S_07;
                    op_PSE:
                        Next_state = PauseIR1;
                    NO_OP:
                        Next_state = S_18;
					default : 
						Next_state = S_18;
				endcase
			default :
				Next_state = S_18;

		endcase
		
		// Assign control signals based on current state
		case (State)
			Halted: ; 
			S_18 : // mar<-pc, pc<=pc+1
				begin 
					GatePC = 1'b1;
					LD_MAR = 1'b1;
					PCMUX = 2'b00;
					LD_PC = 1'b1;
					Mem_OE = 1'b0;
					Mem_WE = 1'b0;
				end
			S_33_1 :
				begin
					Mem_OE = 1'b1;
				end
			S_33_2:
				begin
					Mem_OE = 1'b1;
				end
			S_33_3:
				begin
					Mem_OE = 1'b1;
				end
			S_33_4:
				begin
					Mem_OE = 1'b1;
					LD_MDR = 1'b1;
				end
			S_35 : //IR<-MDR
				begin 
					GateMDR = 1'b1;
					LD_IR = 1'b1;
				end
			PauseIR1: LD_LED = 1'b1; 
			PauseIR2: LD_LED = 1'b1;  
			S_32 : //BEN<- IR[11] & N + IR[10] & Z + IR[9] & P[IR[15:12]]
				LD_BEN = 1'b1;
			S_01 : //add
				begin 
					SR2MUX = IR_5;
					ALUK = 2'b00;
					GateALU = 1'b1;
					LD_REG = 1'b1;
					LD_CC = 1;
					SR1MUX = 1'b1;
				end
			S_00: //
				begin
					ADDR2MUX = 2'b10;
				end
			S_05: //and
				begin
					LD_REG = 1;
					ALUK = 2'b01;
					LD_CC = 1;
					SR1MUX = 2'b01;
					DRMUX = 1;
					GateALU = 1;
				end
			S_06: //MAR<-B+off6
				begin
					GateMARMUX = 1;
					LD_MAR = 1;
					ADDR2MUX = 2'b01;
					ADDR1MUX = 1'b1;
					SR1MUX = 1'b1;
				end
            S_07: //MAR<-B+off6
				begin
					GateMARMUX = 1;
					LD_MAR = 1;
					ADDR2MUX = 2'b01;
					ADDR1MUX = 1'b1;
				end
			S_12: //PC<-baseR
				begin
					LD_PC = 1;
					SR1MUX = 1'b01;
					ADDR1MUX = 1'b01;
					ADDR2MUX = 2'b00;
					PCMUX = 2'b10;
				end
			S_22: //PC<-PC +off9
				begin
					LD_PC = 1;
					ADDR1MUX = 1'b00;
					ADDR2MUX = 2'b10;
					PCMUX = 2'b10;
				end
			S_25_1:
				Mem_OE = 1;
			S_25_2:
				Mem_OE = 1;
			S_25_3:
				Mem_OE = 1;
			S_25_4: //MDR<-M[Mar]
				begin
					Mem_OE = 1;
					LD_MDR = 1;
				end
			S_27: //DR<-MDR set CC
				begin
					GateMDR = 1;
					LD_CC = 1;
					LD_REG = 1;
				end
            S_23: //MDR<-SR
				begin
					LD_MDR = 1;
					GateALU = 1;
				end  
            S_16_1:
                begin
				Mem_OE = 1;
				Mem_WE = 1;
                end
			S_16_2:
                begin
				Mem_OE = 1;
				Mem_WE = 1;
                end
			S_16_3:
                begin
				Mem_OE = 1;
				Mem_WE = 1;
                end
			S_16_4: //M[MAR]<-MDR
                begin
				Mem_OE = 1;
				Mem_WE = 1;
                end
            S_09 : //not, reset cc
                begin
                LD_REG = 1;
                LD_CC = 1;
                ALUK = 2'b10;
                SR1MUX = 1'b1;
                SR2MUX = IR_5;
                GateALU = 1;
                end
            S_04 : //R7 <-PC
                begin
                    LD_REG = 1;
                    GatePC = 1;
                    DRMUX = 1;
                end
            S_21 : //PC <- PC + off11
                begin
                    LD_PC = 1;
                    PCMUX = 2'b10;
                    ADDR2MUX = 2'b11;
                    ADDR1MUX = 1'b0;
                    Mem_WE = 1;
                end    
			default : ;
		endcase
	end 

	
endmodule