module koggestone64bit( a, b, cIn, s, cOut);

    input [63:0] a, b;
    input       cIn;

    output [63:0] s;
    output       cOut;

    wire[63:0] ha_p, ha_g;
    wire[62:0] level_1_p, level_1_g;
    wire[61:0] level_2_p, level_2_g;
    wire[59:0] level_3_p, level_3_g;
    wire[55:0] level_4_p, level_4_g;
    wire[47:0] level_5_p, level_5_g;
    wire[31:0] level_6_p, level_6_g;
    wire       level_7_p, level_7_g;
    
    wire[64:0] c;

    //p0 & p1 = p10
    //(p1 & g0) | g1 = g10

    //preprocess -----------------------------------------------------------------------------
    assign ha_p = a ^ b;
    assign ha_g = a & b;

    //level 1 ----------------------------------------------------------------------------- 1 bit jump
    
    assign level_1_p = ha_p[63:1] & ha_p[62:0];
    assign level_1_g = (ha_p[63:1] & ha_g[62:0]) | ha_g[63:1];

    //level 2 ----------------------------------------------------------------------------- 2 bit jump
    
    assign level_2_p = {
              level_1_p[62:2]   & level_1_p[60:0]
            , level_1_p[1]      & ha_p[0]
        };
    assign level_2_g = {
             (level_1_p[62:2]   & level_1_g[60:0]   )| level_1_g[62:2]
            ,(level_1_p[1]      & ha_g[0]           )| level_1_g[1]
        };
    
    //level 3 ----------------------------------------------------------------------------- 4 bit jump
    assign level_3_p = {
              level_2_p[61:4]   & level_2_p[57:0]
            , level_2_p[3]      & level_1_p[0]
            , level_2_p[2]      & ha_p[0]
        }; 
    assign level_3_g = {
              (level_2_p[61:4]  & level_2_g[57:0])  | level_2_g[61:4]
            , (level_2_p[3]     & level_1_g[0])     | level_2_g[3]
            , (level_2_p[2]     & ha_g[0])          | level_2_g[2]
        };
        
    //level 4 ----------------------------------------------------------------------------- 8 bit jump
    assign level_4_p = {
              level_3_p[59:8]   & level_3_p[51:0]
            , level_3_p[7:6]    & level_2_p[1:0]
            , level_3_p[5]      & level_1_p[0]
            , level_3_p[4]      & ha_p[0]
        };
    assign level_4_g = {
              (level_3_p[59:8]  & level_3_g[51:0]   )| level_3_g[59:8]
            , (level_3_p[7:6]   & level_2_g[1:0]    )| level_3_g[7:6]
            , (level_3_p[5]     & level_1_g[0]      )| level_3_g[5]
            , (level_3_p[4]     & ha_g[0]           )| level_3_g[4] 
        };
        
    //level 5 ----------------------------------------------------------------------------- 16 bit jump
    assign level_5_p = {
              level_4_p[55:16]  & level_4_p[39:0]
            , level_4_p[15:12]  & level_3_p[3:0]
            , level_4_p[11:10]  & level_2_p[1:0]
            , level_4_p[9]      & level_1_p[0]
            , level_4_p[8]      & ha_p[0]
        };
    assign level_5_g = {
              (level_4_p[55:16] & level_4_g[39:0]   )| level_4_g[55:16]
            , (level_4_p[15:12] & level_3_g[3:0]    )| level_4_g[15:12]
            , (level_4_p[11:10] & level_2_g[1:0]    )| level_4_g[11:10]
            , (level_4_p[9]     & level_1_g[0]      )| level_4_g[9]    
            , (level_4_p[8]     & ha_g[0]           )| level_4_g[8]    
        };
        
    //level 6 ----------------------------------------------------------------------------- 32 bit jump
    assign level_6_p = {
              level_5_p[47:32]  & level_5_p[15:0]
            , level_5_p[31:24]  & level_4_p[7:0]
            , level_5_p[23:20]  & level_3_p[3:0]
            , level_5_p[19:18]  & level_2_p[1:0]
            , level_5_p[17]     & level_1_p[0]
            , level_5_p[16]     & ha_p[0]
        };
    assign level_6_g = {
              (level_5_p[47:32] & level_4_g[15:0]   )| level_5_g[47:32]
            , (level_5_p[31:24] & level_4_g[7:0]    )| level_5_g[31:24]
            , (level_5_p[23:20] & level_3_g[3:0]    )| level_5_g[23:20]
            , (level_5_p[19:18] & level_2_g[1:0]    )| level_5_g[19:18]
            , (level_5_p[17]    & level_1_g[0]      )| level_5_g[17]   
            , (level_5_p[16]    & ha_g[0]           )| level_5_g[16]   
        };
        
    //level 7 ----------------------------------------------------------------------------- 64 bit jump (needed for carry)
    assign level_7_p =  level_6_p[31] & ha_p[0];
    assign level_7_g = (level_6_p[31] & ha_g[0]) | level_6_g[31];

    //C ----------------------------------------------------------------------------------- carry generation
    assign c = {
              level_7_g         | (cIn          & level_7_p)        //cOut              [64]
            , level_6_g[30:16]  | (c[31:17]     & level_6_p[30:16]) //lvl6 ref lvl5     [63:49]
            , level_6_g[15:8]   | (c[16:9]      & level_6_p[15:8])  //lvl5 ref lvl4     [48:41]
            , level_6_g[7:4]    | (c[8:5]       & level_6_p[7:4])   //lvl4 ref lvl3     [40:37]
            , level_6_g[3:2]    | (c[4:3]       & level_6_p[3:2])   //lvl4 ref lvl2     [36:35]
            , level_6_g[1]      | (c[2]         & level_6_p[1])     //lvl4 ref lvl1     [34]
            , level_6_g[0]      | (cIn          & level_6_p[0])     //lvl4 ref cIn      [33]
            , level_5_g[15:8]   | (c[16:9]      & level_5_p[15:8])  //lvl5 ref lvl4     [32:25]
            , level_5_g[7:4]    | (c[8:5]       & level_5_p[7:4])   //lvl4 ref lvl3     [24:21]
            , level_5_g[3:2]    | (c[4:3]       & level_5_p[3:2])   //lvl4 ref lvl2     [20:19]
            , level_5_g[1]      | (c[2]         & level_5_p[1])     //lvl4 ref lvl1     [18]
            , level_5_g[0]      | (cIn          & level_5_p[0])     //lvl4 ref cIn      [17]
            , level_4_g[7:4]    | (c[8:5]       & level_4_p[7:4])   //lvl4 ref lvl3     [16:13]
            , level_4_g[3:2]    | (c[4:3]       & level_4_p[3:2])   //lvl4 ref lvl2     [12:11]
            , level_4_g[1]      | (c[2]         & level_4_p[1])     //lvl4 ref lvl1     [10]
            , level_4_g[0]      | (cIn          & level_4_p[0])     //lvl4 ref cIn      [9]
            , level_3_g[3:2]    | (c[4:3]       & level_3_p[3:2])   //lvl3 ref lvl2     [8:7]
            , level_3_g[1]      | (c[2]         & level_3_p[1])     //lvl3 ref lvl1     [6]
            , level_3_g[0]      | (cIn          & level_3_p[0])     //lvl3 ref cIn      [5]
            , level_2_g[1]      | (c[2]         & level_2_p[1])     //lvl2 ref lvl1     [4]
            , level_2_g[0]      | (cIn          & level_2_p[0])     //lvl2 ref cIn      [3]
            , level_1_g[0]      | (cIn          & level_1_p[0])     //lvl1 ref cIn      [2]
            , ha_g[0]           | (cIn          & ha_p[0])          //ha   ref cIn      [1]
            , cIn                                                   //cIn               [0]
        };

    //output  -----------------------------------------------------------------------------
    assign s = c[63:0] ^ ha_p[63:0];
    assign cOut = c[64];

endmodule