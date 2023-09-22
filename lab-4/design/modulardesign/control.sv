
module control(
    input Clk, ResetB, Run, 
    input logic [7:0] B,
    output logic Shift_En, Ld_XA, Ld_B, Reset, addsub, Clear
    );
    
    
    enum logic [3:0] {shift, add, subtract, run, reset} state, nstate;
    logic[3:0] counter, counting; 
    logic c, d;
    
//    assign Ld_B = Bload;;
    
    //impplement c
    
    always_ff @ (posedge Clk)
    begin
    
        counting <= counter;
        if (ResetB)
            state <= reset;
//        else if (Run)
//            state <= run;
        else 
            state <= nstate;
    
    
    end
    
    always_comb
    begin
    
        nstate  = state;	//required because I haven't enumerated all possibilities below
        unique case (state) 

            reset :    if (Run && B[0])
                        nstate = add;
                       else if(Run)
                        nstate = shift;
            run :      if (ResetB)
                        nstate = reset;
                       else if(Run && B[0])
                        nstate = add;
                       else if(Run)
                        nstate = shift;
            shift :    if (!B[1] && !(counting == 4'd7) && !d)
                        nstate = shift;
                       else if(B[1] && !(counting >= 4'd6) && !d)
                        nstate = add;
                       else if(B[1] && (counting == 4'd6) && !d)
                        nstate = subtract;  
                       else if((counting >= 4'd7))
                        nstate = run;
                       else if(d)
                        nstate = run;                      
            subtract :    nstate = shift;
            add :    nstate = shift;

							  
        endcase
    
    
    
        case (state)
        
            reset : begin
                Shift_En = 0;//shift
                Ld_XA = 0;//load sum 
                Reset = 1;//reset regs
                Clear = 0;
                d = 0;
                counter = 4'd0;
                Ld_B = 0;
                addsub = 0;
                Ld_B = ResetB;

            end
            run : begin
                d = 0;
                Ld_B = 0;
                counter = 4'd0;
                Shift_En = 0;//shift
                Ld_XA = 0;//load sum 
                Clear = 0;//reset regs
                Reset = 1;
                addsub = 0;
              
            end            
            shift : begin
                Shift_En = 1;//shift
                Ld_XA = 0;//load sum 
                Ld_B = 0;
                Reset = 0;//reset regs
                Clear = 0;
                addsub = 0;                
                counter = counting + 1;//increment shift counter

            end   
            add : begin
                Shift_En = 0;//shift
                Ld_XA = 1;//load sum 
                Reset = 0;//reset regs
                Clear = 0;
                addsub = 0;
                //add
                //shift
            end
            subtract : begin
                d = 1;
                addsub = 1;
                Shift_En = 0;//shift
                Ld_XA = 1;//load sum 
                Reset = 0;//reset regs
                Clear = 0;

            end        
            default: 
            begin
            end    
                               
        endcase
    end





    
endmodule