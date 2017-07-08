module koggestone4bit( a, b, cIn, s, cOut);

    input [3:0] a, b;
    input       cIn;

    output [3:0] s;
    output       cOut;

    wire [3:0]  internal_level1_p,
                internal_level1_g,
                internal_level2_p,
                internal_level2_g,
                internal_level3_p,
                internal_level3_g,
                internal_level4_c;

    //p0 & p1 = p10
    //(p1 & g0) | g1 = g10

    //level 1 -----------------------------------------------------------------------------
    assign internal_level1_p = a ^ b;
    assign internal_level1_g = a & b;

    //level 2 -----------------------------------------------------------------------------
    
    assign internal_level2_p[0] = internal_level1_p[0];
    assign internal_level2_p[1] = internal_level1_p[0] & internal_level1_p[1];
    assign internal_level2_p[2] = internal_level1_p[1] & internal_level1_p[2];
    assign internal_level2_p[3] = internal_level1_p[2] & internal_level1_p[3];
    
    assign internal_level2_g[0] = internal_level1_g[0];
    assign internal_level2_g[1] = (internal_level1_p[1] & internal_level1_g[0]) | internal_level1_g[1];
    assign internal_level2_g[2] = (internal_level1_p[2] & internal_level1_g[1]) | internal_level1_g[2];
    assign internal_level2_g[3] = (internal_level1_p[3] & internal_level1_g[2]) | internal_level1_g[3];

    //level 3 -----------------------------------------------------------------------------
    assign internal_level3_p[0] = internal_level2_p[0];
    assign internal_level3_p[1] = internal_level2_p[1];
    assign internal_level3_p[2] = internal_level2_p[0] & internal_level2_p[2];
    assign internal_level3_p[3] = internal_level2_p[1] & internal_level2_p[3];

    assign internal_level3_g[0] = internal_level2_g[0];
    assign internal_level3_g[1] = internal_level2_g[1];
    assign internal_level3_g[2] = internal_level2_p[2] & internal_level2_g[0] | internal_level2_g[2];
    assign internal_level3_g[3] = internal_level2_p[3] & internal_level2_g[1] | internal_level2_g[3];    

    assign internal_level4_c[0] = internal_level3_g[0] | (cIn & internal_level3_p[0]);
    assign internal_level4_c[1] = internal_level3_g[1] | (cIn & internal_level3_p[0]);
    assign internal_level4_c[2] = internal_level3_g[2] | (internal_level4_c[1] & internal_level3_p[2]);
    assign internal_level4_c[3] = internal_level3_g[3] | (cIn & internal_level3_p[3]); 

    //output  -----------------------------------------------------------------------------
    assign s[0] = cIn ^ internal_level1_p[0];
    assign s[1] = internal_level4_c[0] ^ internal_level1_p[1];
    assign s[2] = internal_level4_c[1] ^ internal_level1_p[2];
    assign s[3] = internal_level4_c[2] ^ internal_level1_p[3];
    
    assign cOut = internal_level4_c[3];

endmodule
