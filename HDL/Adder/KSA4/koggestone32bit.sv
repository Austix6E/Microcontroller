module koggestone4bit( a, b, cIn, s, cOut);

    input [31:0] a, b;
    input       cIn;

    output [31:0] s;
    output       cOut;

	wire[31:0] ha_p, ha_g;
	wire[30:0] level_1_p, level_1_g;
	wire[29:0] level_2_p, level_2_g;
	wire[27:0] level_3_p, level_3_g;
	wire[23:0] level_4_p, level_4_g;
	wire[15:0] level_5_p, level_5_g;
	wire	   level_6_p, level_6_g;
	
	wire[33:0] c;

    //p0 & p1 = p10
    //(p1 & g0) | g1 = g10

    //preprocess -----------------------------------------------------------------------------
    assign ha_p = a ^ b;
    assign preprocess_g = a & b;

    //level 1 ----------------------------------------------------------------------------- 1 bit jump
    
	assign level_1_p = ha_p[31:1] & ha_p[30:0];
	assign level_1_g = (ha_p[31:1] & ha_g[30:0]) | ha_g[31:1];

    //level 2 ----------------------------------------------------------------------------- 2 bit jump
	
	assign level_2_p = {
			  level_1_p[30:2] 	& level_1_p[28:0]
			, level_1_p 		& ha_p[0]
		};
	assign level_2_g = {
			 (level_1_p[30:2] 	& level_1_g[28:0]) 	| level_1_g[30:2]
			, level_1_p[0] 		& ha_g[0] 			| level_1_g[0]
		};
	
    //level 3 ----------------------------------------------------------------------------- 4 bit jump
	assign level_3_p = {
			  level_2_p[29:4] 	& level_2_p[25:0]
			, level_2_p[3] 		& level_1_p[0]
			, level_2_p[2] 		& ha_p[0]
		}; 
	assign level_3_g = {
			  (level_2_p[29:4] 	& level_2_g[25:0]) 	| level_2_g[29:4]
			, (level_2_p[3] 	& level_1_g[0]) 	| level_2_g[3]
			, (level_2_p[2] 	& ha_g[0]) 			| level_2_g[2]
		};
		
    //level 4 ----------------------------------------------------------------------------- 8 bit jump
	assign level_4_p = {
			  level_3_p[27:8] 	& level_3_p[19:0]
			, level_3_p[7:6] 	& level_2_p[1:0]
			, level_3_p[5] 		& level_1_p[0]
			, level_3_p[4] 		& ha_p[0]
		};
	assign level_4_g = {
			  (level_3_p[27:8] 	& level_3_g[19:0]	)| level_3_g[27:8]
			, (level_3_p[7:6] 	& level_2_g[1:0]	)| level_3_g[7:6]
			, (level_3_p[5] 	& level_1_g[0]		)| level_3_g[5]
			, (level_3_p[4] 	& ha_g[0]			)| level_3_g[4] 
		};
		
    //level 5 ----------------------------------------------------------------------------- 16 bit jump
    assign level_5_p = {
			  level_4_p[23:15] 	& level_4_p[8:0]
			, level_4_p[14:11] 	& level_3_p[3:0]
			, level_4_p[10:9]	& level_2_p[1:0]
			, level_4_p[8] 		& level_1_p[0]
			, level_4_p[7]		& ha_p[0]
		};
	assign level_5_g = {
			  (level_4_p[23:15] & level_4_g[8:0]	)| level_4_g[23:15]
			, (level_4_p[14:11] & level_3_g[3:0]	)| level_4_g[14:11]
			, (level_4_p[10:9]	& level_2_g[1:0]	)| level_4_g[10:9]
			, (level_4_p[8] 	& level_1_g[0]		)| level_4_g[8]
			, (level_4_p[7]		& ha_g[0]			)| level_4_g[7]
		};
		
    //level 6 ----------------------------------------------------------------------------- 32 bit jump (needed for carry)
	assign level_6_p = level_5_p[15] & ha_p[0];
	assign level_6_g = (level_5_p[15] & ha_g[0]) | level_5_g[15];

    //C ----------------------------------------------------------------------------------- carry generation
	assign c = {
			  level_6_g[0] 		| (cIn 		& level_6_p[0])		//cOut 			[32]
			, level_5_g[15:8]	| (c[16:9]	& level_5_p[15:8])	//lvl5 ref lvl4	[31:25]
			, level_5_g[7:4]	| (c[8:5] 	& level_5_p[7:4])   //lvl4 ref lvl3	[24:21]
			, level_5_g[3:2]	| (c[4:3] 	& level_5_p[3:2])	//lvl4 ref lvl2	[20:19]
			, level_5_g[1]		| (c[2]		& level_5_p[1]) 	//lvl4 ref lvl1	[18]
			, level_5_g[0]		| (cIn		& level_5_p[0])		//lvl4 ref cIn	[17]
			, level_4_g[7:4]	| (c[8:5] 	& level_4_p[7:4])   //lvl4 ref lvl3	[16:13]
			, level_4_g[3:2]	| (c[4:3] 	& level_4_p[3:2])	//lvl4 ref lvl2	[12:11]
			, level_4_g[1]		| (c[2]		& level_4_p[1]) 	//lvl4 ref lvl1	[10]
			, level_4_g[0]		| (cIn		& level_4_p[0])		//lvl4 ref cIn	[9]
			, level_3_g[3:2]	| (c[4:3] 	& level_3_p[3:2])	//lvl3 ref lvl2	[8:7]
			, level_3_g[1]		| (c[2]		& level_3_p[1]) 	//lvl3 ref lvl1	[6]
			, level_3_g[0]		| (cIn		& level_3_p[0])		//lvl3 ref cIn	[5]
			, level_2_g[1] 		| (c[2] 	& level_2_p[1])		//lvl2 ref lvl1	[4]
			, level_2_g[0] 		| (cIn 		& level_2_p[0])		//lvl2 ref cIn	[3]
			, level_1_g[0] 		| (cIn 		& level_1_p[0])		//lvl1 ref cIn	[2]
			, ha_g[0] 			| (cIn 		& ha_p[0])			//ha   ref cIn	[1]
			, cIn												//cIn			[0]
		};
	
    //output  -----------------------------------------------------------------------------
	assign s = c[31:0] ^ ha_p[31:0];
	assign cOut = c[32];

endmodule