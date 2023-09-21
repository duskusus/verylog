
module control(
    input Clk, Reset, Run, LoadX, LoadB, LoadA,
    input logic [7:0] B,
    output Shift_En, Ld_A, Ld_B, Ld_X
    );
    
    
    enum logic [3:0] {shift, add, subtract, run, reset} state;
    logic[3:0] counter, counting; 
    logic shiften, M, c, R, d;
    
    assign Shift_En = shiften;
    
    always_ff @ (posedge Clk)
    begin
    
        counting <= counter;
    
    end
    
    always_comb
    begin
        case (state)
        
            reset : begin
                shiften = 0; //no shift
                //reset regB
                //reset regA
                //reset regX
                //if loadB load B
                //cond. Add
                //cond. Shift
            end
            run : begin
                d = 0;
                counter = 4'd0;
                shiften = 0;
                //cond. Add
                //cond. Shift
                //cond. reset
                //else run                
            end            
            shift : begin
                shiften = 1;
                //increment shift counter
                //cond. Add
                //cond. Shift
                //cond. run
                //else shift
            end   
            add : begin
                //load 
                //add
                //shift
            end
            subtract : begin
                d = 1;
                //load
                //change fn
                //shift
            end            
                               
        endcase
    end





    
endmodule
