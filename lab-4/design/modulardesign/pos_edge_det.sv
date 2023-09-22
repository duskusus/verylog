

module posedgedet(
        input logic sig, clk,
        output logic pe
        
    );
    
    logic sig_dly;
    
    always_ff @ (posedge clk) begin
            sig_dly <= sig;
            pe       <= (sig && !sig_dly);
    end
    

endmodule
