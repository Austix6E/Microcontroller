module kstb;

    logic [3:0] a, b, s;
    logic cIn, cOut;

    koggestone4bit dut (a, b, cIn, s, cOut);

    initial begin
    
        #0 a = 4'b0000; 
        #0 b = 4'b0000;
        #0 cIn = 1'b1;
        #10 if(s == 4'b0001 & cOut == 0) $display("T1 good");

        #0 a  = 4'b0101; 
        #0  b = 4'b1010;
        #0  cIn = 1'b1;
        #10 if(s == 4'b0000 & cOut == 1) $display("T2 good");

        #0 a  = 4'b1111; 
        #0  b = 4'b1010;
        #0  cIn = 1'b0;
        #10 if(s == 4'b1001 & cOut == 1) $display("T3 good");

        #0 a  = 4'b1001; 
        #0  b = 4'b1100;
        #0  cIn = 1'b0;
        #10 if(s == 4'b0101 & cOut == 1) $display("T4 good");

        #0 a  = 4'b1111; 
        #0  b = 4'b0000;
        #0  cIn = 1'b0;
        #10 if(s == 4'b1111 & cOut == 0) $display("T5 good");

        #0 a  = 4'b1111; 
        #0  b = 4'b0000;
        #0  cIn = 1'b1;
        #10 if(s == 4'b0000 & cOut == 1) $display("T6 good");
        
    end 


endmodule
