module rfa (output logic g, p, Sum, input logic A, B, Cin);

  assign g = A & B;
  assign p = A | B;
  assign Sum = A ^ B ^ Cin;

endmodule

module bclg4 (
		output logic [2:0] cOut, 
		output logic gOut, pOut, 
		input logic [3:0] gIn, pIn, 
		input logic cIn
	);

	assign cOut[0] = gIn[0] | (pIn[0]&cIn);
	assign cOut[1] = gIn[1] | (pIn[1]&gIn[0]) | (pIn[1]&pIn[0]&cIn);
	assign cOut[2] = gIn[2] | (pIn[2]&gIn[1]) | (pIn[2]&pIn[1]&gIn[0]) | (pIn[2]&pIn[1]&pIn[0]&cIn);

	assign gOut = gIn[3] | (pIn[3]&gIn[2]) | (pIn[3]&pIn[2]&gIn[1]) | (pIn[3]&pIn[2]&pIn[1]&gIn[0]);
	assign pOut = pIn[3]&pIn[2]&pIn[1]&pIn[0];
   
endmodule

module bclg3 (
		output logic [1:0] cOut,
		output logic gOut, pOut,
		input logic [2:0] gIn, pIn,
		input logic cIn
	);

	assign cOut[0] = gIn[0] | (pIn[0]&cIn);
	assign cOut[1] = gIn[1] | (pIn[1]&gIn[0]) | (pIn[1]&pIn[0]&cIn);

	assign gOut = gIn[2] | (pIn[2]&gIn[1]) | (pIn[2]&pIn[1]&gIn[0]);
	assign pOut = pIn[2]&pIn[1]&pIn[0];

endmodule

module bclg2 (
		output logic cOut, gOut, pOut,
		input logic [1:0] gIn, pIn,
		input logic cIn
	);

	assign cOut = gIn[0]|(pIn[0]&cIn);

	assign gOut = gIn[1] | (pIn[1]&gIn[0]);
	assign pOut = pIn[1]&pIn[0];

endmodule

module cla14 (
		input logic [13:0] A, B, 
		input logic Cin, 
		output logic [13:0] Sum, 
		output logic P, G, Cout
	);

	logic [13:0] intrn_p	,intrn_g	, intrn_c;	//level 1
	logic [3:0]  intrn_p_2	,intrn_g_2	;			//level 2
	logic [1:0]  intrn_p_3	,intrn_g_3	;			//level 3

	//RFA -----------------------------------------------------------------------------------------

	rfa  r00 (intrn_g[ 0], intrn_p[ 0], Sum[ 0], A[ 0], B[ 0], Cin);
	rfa  r01 (intrn_g[ 1], intrn_p[ 1], Sum[ 1], A[ 1], B[ 1], intrn_c[ 1]);
	rfa  r02 (intrn_g[ 2], intrn_p[ 2], Sum[ 2], A[ 2], B[ 2], intrn_c[ 2]);
	rfa  r03 (intrn_g[ 3], intrn_p[ 3], Sum[ 3], A[ 3], B[ 3], intrn_c[ 3]);

	rfa  r04 (intrn_g[ 4], intrn_p[ 4], Sum[ 4], A[ 4], B[ 4], intrn_c[ 4]);
	rfa  r05 (intrn_g[ 5], intrn_p[ 5], Sum[ 5], A[ 5], B[ 5], intrn_c[ 5]);
	rfa  r06 (intrn_g[ 6], intrn_p[ 6], Sum[ 6], A[ 6], B[ 6], intrn_c[ 6]);

	rfa  r07 (intrn_g[ 7], intrn_p[ 7], Sum[ 7], A[ 7], B[ 7], intrn_c[ 7]);
	rfa  r08 (intrn_g[ 8], intrn_p[ 8], Sum[ 8], A[ 8], B[ 8], intrn_c[ 8]);
	rfa  r09 (intrn_g[ 9], intrn_p[ 9], Sum[ 9], A[ 9], B[ 9], intrn_c[ 9]);

	rfa  r10 (intrn_g[10], intrn_p[10], Sum[10], A[10], B[10], intrn_c[10]);
	rfa  r11 (intrn_g[11], intrn_p[11], Sum[11], A[11], B[11], intrn_c[11]);

	rfa  r12 (intrn_g[12], intrn_p[12], Sum[12], A[12], B[12], intrn_c[12]);
	rfa  r13 (intrn_g[13], intrn_p[13], Sum[13], A[13], B[13], intrn_c[13]);

	//LEVEL 1 -------------------------------------------------------------------------------------
  
		//[3:0]
	bclg4 b1 (intrn_c[3:1], intrn_g_2[0], intrn_p_2[0], intrn_g[3:0]  , intrn_p[3:0]  , Cin);

		//[6:4]
	bclg3 b2 (intrn_c[6:5], intrn_g_2[1], intrn_p_2[1], intrn_g[6:4]  , intrn_p[6:4]  , intrn_c[4]);

		//[9:7]
	bclg3 b3 (intrn_c[9:8], intrn_g_2[2], intrn_p_2[2], intrn_g[9:7]  , intrn_p[9:7]  , intrn_c[7]); 

		//[11:10]
	bclg2 b4 (intrn_c[11] , intrn_g_2[3], intrn_p_2[3], intrn_g[11:10], intrn_p[11:10], intrn_c[10]);  

		//[13:12]
	bclg2 b5 (intrn_c[13] , intrn_g_3[1], intrn_p_3[1], intrn_g[13:12], intrn_p[13:12], intrn_c[12]);

	//LEVEL 2 -------------------------------------------------------------------------------------
	
	bclg4 b6 ({intrn_c[10],intrn_c[7],intrn_c[4]},intrn_g_3[0],intrn_p_3[0], intrn_g_2[3:0], intrn_p_2[3:0], Cin);

	//LEVEL 3  -------------------------------------------------------------------------------------

	bclg2 b7 (intrn_c[12], G, P, intrn_g_3[1:0], intrn_p_3[1:0], Cin);

	//COUT     -------------------------------------------------------------------------------------

	//assign Cout = (A[13]&B[13]) | (A[13]&intrn_c[13]) | (B[13]&intrn_c[13]);
	assign Cout = G | (P&intrn_c[13]);

endmodule