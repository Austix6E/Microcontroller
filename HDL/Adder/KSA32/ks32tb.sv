module kstb;

    logic [31:0] a, b, s;
    logic cIn, cOut;

    koggestone32bit dut (a, b, cIn, s, cOut);

    initial begin
    
        #0 a = 32'd20; 
        #0 b = 32'd40;
        #0 cIn = 1'b0;
        #10 if(s == 32'd60 & cOut == 0) $display("T1 good");

    end 


endmodule
