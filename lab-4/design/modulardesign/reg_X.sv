module reg_1 (input  logic Clk, Clear, Shift_In, Load, Shift_En,
              input  logic  XSum,
              output logic Shift_Out,
              output logic  Data_Out);

    always_ff @ (posedge Clk)
    begin
	 	 if (Clear) //notice, this is a sycnrhonous reset, which is recommended on the FPGA
			  Data_Out <= 1'b0;
		 else if (Load)
			  Data_Out <= XSum;
		 else if (Shift_En)
		 begin
			  //concatenate shifted in data to the previous left-most 3 bits
			  //note this works because we are in always_ff procedure block
			  Data_Out <= Shift_In; 
	    end
    end
	
    assign Shift_Out = Data_Out;

endmodule