###################################################################

# Created by write_sdc on Fri Oct 30 19:50:02 2020

###################################################################
set sdc_version 2.1

set_units -time ns -resistance MOhm -capacitance fF -voltage V -current mA
set_load -pin_load 3.40189 [get_ports vout]
set_load -pin_load 3.40189 [get_ports {dout[11]}]
set_load -pin_load 3.40189 [get_ports {dout[10]}]
set_load -pin_load 3.40189 [get_ports {dout[9]}]
set_load -pin_load 3.40189 [get_ports {dout[8]}]
set_load -pin_load 3.40189 [get_ports {dout[7]}]
set_load -pin_load 3.40189 [get_ports {dout[6]}]
set_load -pin_load 3.40189 [get_ports {dout[5]}]
set_load -pin_load 3.40189 [get_ports {dout[4]}]
set_load -pin_load 3.40189 [get_ports {dout[3]}]
set_load -pin_load 3.40189 [get_ports {dout[2]}]
set_load -pin_load 3.40189 [get_ports {dout[1]}]
set_load -pin_load 3.40189 [get_ports {dout[0]}]
create_clock [get_ports clk]  -name my_clk  -period 2.81  -waveform {0 1.405}
set_clock_uncertainty 0.07  [get_clocks my_clk]
set_input_delay -clock my_clk  -max 0.5  [get_ports rst_n]
set_input_delay -clock my_clk  -max 0.5  [get_ports vin]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {din[0]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b0[0]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b1[0]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {b2[0]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a1[0]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[11]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[10]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[9]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[8]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[7]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[6]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[5]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[4]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[3]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[2]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[1]}]
set_input_delay -clock my_clk  -max 0.5  [get_ports {a2[0]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports vout]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[11]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[10]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[9]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[8]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[7]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[6]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[5]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[4]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[3]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[2]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[1]}]
set_output_delay -clock my_clk  -max 0.5  [get_ports {dout[0]}]
