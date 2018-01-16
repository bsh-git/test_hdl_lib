`default_nettype none

module firefly
  (
   input  wire clk_in,
   output wire mod_out
   );

   (* mark_debug = "TRUE" *) wire  pwmclk, dbgclk, waveclk, pwmout;
   (* mark_debug = "TRUE" *) wire [3:0] vol;


   divider #(4) divdbg(.clk_in(clk_in), .load(15-1), .clk_out(dbgclk));
   divider #(4) div0(.clk_in(clk_in), .load(60-1), .clk_out(pwmclk));

//   divider #(16) div1(.clk_in(pwmclk), .load(500-1), .clk_out(waveclk));
   divider #(16) div1(.clk_in(pwmclk), .load(30000), .clk_out(waveclk));

   triangle_wave #(4) wave(.clk(waveclk), .low_in(0), .high_in(~0), .mod_out(vol));
   pwm #(4) pwm0(.clk(pwmclk), .wave_length(15), .high_time(vol), .out(pwmout));

   assign mod_out = pwmout;
endmodule // firefly

`default_nettype wire
