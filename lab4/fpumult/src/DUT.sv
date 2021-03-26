module DUT(dut_if.port_in in_inter, dut_if.port_out out_inter, output enum logic [1:0] {INITIAL,WAIT,SEND} state);
    
    FPmul fpumult_under_test(.FP_A(in_inter.A),.FP_B(in_inter.B), .clk(in_inter.clk), .FP_Z(out_inter.data));

	integer count;
	logic [31:0] A_reg, B_reg;

    always_ff @(posedge in_inter.clk)
    begin
        if(in_inter.rst) begin
            in_inter.ready <= 0;
            out_inter.data <= 'x;
            out_inter.valid <= 0;
            state <= INITIAL;
        end
        else case(state)
                INITIAL: begin
                    in_inter.ready <= 1;
                    state <= WAIT;

					count = 0;
                end
                
                WAIT: begin
                    if(in_inter.valid) begin
                        in_inter.ready <= 0;
                        //out_inter.data <= in_inter.A + in_inter.B;
                        
						if (count == 0) begin
							A_reg = in_inter.A;
							B_reg = in_inter.B;						
						end
						
						count = count + 1;
						if (count == 6) begin
							out_inter.valid <= 1;
							state <= SEND;
							$display("mult: input A = %.23f, input B = %.23f, output OUT = %.23f",$bitstoshortreal(A_reg), $bitstoshortreal(B_reg),$bitstoshortreal(out_inter.data));
                        	$display("mult: input A = %b, input B = %b, output OUT = %b",A_reg, B_reg, out_inter.data);
						end                        
                    end
                end                
				
                SEND: begin
                    if(out_inter.ready) begin
                        out_inter.valid <= 0;
                        in_inter.ready <= 1;
                        state <= WAIT;
						count = 0;
                    end
                end
        endcase
    end
endmodule: DUT
