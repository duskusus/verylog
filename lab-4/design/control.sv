
module control(
    input Clk, ResetB, Run, LoadB, 
    input logic [7:0] B,
    output Shift_En, Ld_A, Ld_B, Ld_X, Reset, addsub, Clear
    );
    
    
    enum logic [3:0] {shift, add, subtract, run, reset} state, nstate;
    logic[3:0] counter, counting; 
    logic shiften, M, c, R, d, loadS, Bload, fn, Clr;
    
    assign Shift_En = shiften;
    assign Ld_A = loadS;
    assign Reset = R;
    assign Ld_B = Bload;
    assign Ld_X = loadS;
    assign addsub = fn;
    assign Clear = Clr;
    assign M = B[7];
    
    //impplement c
    
    always_ff @ (posedge Clk)
    begin
    
        counting <= counter;
        if (ResetB)
            state <= reset;
        else 
            state <= nstate;
    
    end
    
    always_comb
    begin
    
        nstate  = state;	//required because I haven't enumerated all possibilities below
        unique case (state) 

            reset :    if (Run && M)
                        nstate = add;
                       else if(Run)
                        nstate = shift;
            run :      if (ResetB)
                        nstate = reset;
                       else if(Run && M)
                        nstate = add;
                       else if(Run)
                        nstate = shift;
            shift :    if (!M && !(counting == 4'd8) && !d)
                        nstate = shift;
                       else if(M && !(counting == 4'd8) && !d)
                        nstate = add;
                       else if(M && (counting == 4'd8) && !d)
                        nstate = subtract;  
                       else if(d)
                        nstate = run;                      
            subtract :    nstate = shift;
            add :    nstate = shift;

							  
        endcase
    
    
    
        case (state)
        
            reset : begin
                shiften = 0;//shift
                loadS = 0;//load sum 
                R = 1;//reset regs
                Clr = 1;
                d = 0;
                Bload = 0;
                fn = 0;
                if(LoadB == 1)
                    Bload = 1;

            end
            run : begin
                d = 0;
                Bload = 0;
                counter = 4'd0;
                shiften = 0;//shift
                loadS = 0;//load sum 
                Clr = 1;//reset regs
                R = 0;
                fn = 0;
              
            end            
            shift : begin
                shiften = 1;//shift
                loadS = 0;//load sum 
                R = 0;//reset regs
                Clr = 0;
                counter = counting + 1;//increment shift counter

            end   
            add : begin
                shiften = 0;//shift
                loadS = 1;//load sum 
                R = 0;//reset regs
                Clr = 0;
                fn = 0;
                //add
                //shift
            end
            subtract : begin
                d = 1;
                fn = 1;
                shiften = 0;//shift
                loadS = 1;//load sum 
                R = 0;//reset regs
                Clr = 0;

            end        
            default: 
            begin
            end    
                               
        endcase
    end





    
endmodule
