//`timescale 1ns

module tb_iir ();

   wire CLK_i;
   wire RST_n_i;
   wire [11:0] DIN_i;
   wire VIN_i;
   wire [11:0] A1_i;
   wire [11:0] A2_i;
   wire [11:0] B0_i;
   wire [11:0] B1_i;
   wire [11:0] B2_i;
   wire [11:0] DOUT_i;
   wire [11:0] A0A1_i;
   wire [11:0] A1A1_i;
   wire [11:0] A1A2_i;
   wire [11:0] A1B0_i;
   wire [11:0] A1B1_i;
   wire [11:0] A1B2_i;
   wire VOUT_i;
   wire END_SIM_i;

   clk_gen CG(.END_SIM(END_SIM_i),
  	      .CLK(CLK_i),
	      .RST_n(RST_n_i));

   data_maker SM(.CLK(CLK_i),
	         .RST_n(RST_n_i),
		 .VOUT(VIN_i),
		 .DOUT(DIN_i),
		 .A1(A1_i),
		 .A2(A2_i),
		 .B0(B0_i),
		 .B1(B1_i),
		 .B2(B2_i),
		 .A0A1(A0A1_i),
		 .A1A1(A1A1_i),
		 .A1A2(A1A2_i),
		 .A1B0(A1B0_i),
		 .A1B1(A1B1_i),
		 .A1B2(A1B2_i),
		 .END_SIM(END_SIM_i));

   iir_lookahead UUT(.clk(CLK_i),
	     .rst_n(RST_n_i),
	     .din(DIN_i),
         .vin(VIN_i),
	     .a1(A1_i),
		 .a2(A2_i),
		 .b0(B0_i),
		 .b1(B1_i),
		 .b2(B2_i),
		 .a0a1(A0A1_i),
		 .a1a1(A1A1_i),
		 .a1a2(A1A2_i),
		 .a1b0(A1B0_i),
		 .a1b1(A1B1_i),
		 .a1b2(A1B2_i),
             .dout(DOUT_i),
             .vout(VOUT_i));

   data_sink DS(.CLK(CLK_i),
		.RST_n(RST_n_i),
		.VIN(VOUT_i),
		.DIN(DOUT_i));   

endmodule

		   
