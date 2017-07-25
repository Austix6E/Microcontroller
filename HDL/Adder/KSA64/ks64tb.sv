module kstb;

    logic [63:0] a, b, s;
    logic cIn, cOut;

    koggestone64bit dut (a, b, cIn, s, cOut);

    initial begin
    
        #0 a = 64'd20; 
        #0 b = 64'd20;
        #0 cIn = 1'b0;
        #10 if(s == 64'd40 & cOut == 0) $display("T1 good");
    
        #0 a = 64'd60; 
        #0 b = 64'd480;
        #0 cIn = 1'b0;
        #10 if(s == 64'd540 & cOut == 0) $display("T2 good");
    
        #0 a = 64'd69196189; 
        #0 b = 64'd5054312;
        #0 cIn = 1'b0;
        #10 if(s == 64'd74250501 & cOut == 0) $display("T3 good");
    
        #0 a = 64'd5000; 
        #0 b = 64'd5000;
        #0 cIn = 1'b0;
        #10 if(s == 64'd10000 & cOut == 0) $display("T4 good");
    
        #0 a = 64'hffffffffffffffff; 
        #0 b = 64'hffffffffffffffff;
        #0 cIn = 1'b1;
        #10 if(s == 64'hffffffffffffffff & cOut == 1) $display("T5 good");

        #0 a = 64'hffffffffffffffff; 
        #0 b = 64'h0;
        #0 cIn = 1'b1;
        #10 if(s == 64'd0 & cOut == 1) $display("T6 good");

        #0 a = 64'd6873888742830003792; 
        #0 b = 64'd222204639981293359;
        #0 cIn = 1'b1;
        #10 if(s == (a+b+cIn) & cOut == 0) $display("T7 good");

        #0 a = 64'hefffffffffffffff; 
        #0 b = 64'h0f0f0f0f0f0f0f0f;
        #0 cIn = 1'b1;
        #10 if(s == (a+b+cIn) & cOut == 0) $display("T8 good");

    end


endmodule
