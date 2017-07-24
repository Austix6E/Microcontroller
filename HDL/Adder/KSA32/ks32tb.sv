module kstb;

    logic [31:0] a, b, s;
    logic cIn, cOut;

    koggestone32bit dut (a, b, cIn, s, cOut);

    initial begin
    
        #0 a = 32'd20; 
        #0 b = 32'd20;
        #0 cIn = 1'b0;
        #10 if(s == 32'd40 & cOut == 0) $display("T1 good");
    
        #0 a = 32'd60; 
        #0 b = 32'd480;
        #0 cIn = 1'b0;
        #10 if(s == 32'd540 & cOut == 0) $display("T2 good");
    
        #0 a = 32'd69196189; 
        #0 b = 32'd5054312;
        #0 cIn = 1'b0;
        #10 if(s == 32'd74250501 & cOut == 0) $display("T3 good");
    
        #0 a = 32'd5000; 
        #0 b = 32'd5000;
        #0 cIn = 1'b0;
        #10 if(s == 32'd10000 & cOut == 0) $display("T4 good");
    
        #0 a = 32'hffffffff; 
        #0 b = 32'hffffffff;
        #0 cIn = 1'b1;
        #10 if(s == 32'hffffffff & cOut == 1) $display("T5 good");

        #0 a = 32'hffffffff; 
        #0 b = 32'h0;
        #0 cIn = 1'b1;
        #10 if(s == 32'd0 & cOut == 1) $display("T6 good");

    end


endmodule
