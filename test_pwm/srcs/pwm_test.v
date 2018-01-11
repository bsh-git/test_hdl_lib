`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/08 23:01:06
// Design Name: 
// Module Name: pwm_test
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module pwm_test
   (
    input 	 clk_in,
    input 	 sw, 
    output [7:0] led
    );

   (* mark_debug = "TRUE" *) wire 	       clk0;
   (* mark_debug = "TRUE" *) wire 	       clkdbg;
   (* mark_debug = "TRUE" *) wire [7:0]	       pwm_out;

   divider #(16) divdbg(.clk_in(clk_in), .load(16'h03ff), .clk_out(clkdbg));
   divider #(16) div0(.clk_in(clk_in), .load(16'h0fff), .clk_out(clk0));

   assign led = pwm_out;

   pwm #(8) pwm0(.clk(clk0), .wave_length(79), .high_time(80), .out(pwm_out[7]));
   pwm #(8) pwm1(.clk(clk0), .wave_length(79), .high_time(70), .out(pwm_out[6]));
   pwm #(8) pwm2(.clk(clk0), .wave_length(79), .high_time(60), .out(pwm_out[5]));
   pwm #(8) pwm3(.clk(clk0), .wave_length(79), .high_time(50), .out(pwm_out[4]));
   pwm #(8) pwm4(.clk(clk0), .wave_length(79), .high_time(40), .out(pwm_out[3]));
   pwm #(8) pwm5(.clk(clk0), .wave_length(79), .high_time(30), .out(pwm_out[2]));
   pwm #(8) pwm6(.clk(clk0), .wave_length(79), .high_time(20), .out(pwm_out[1]));
   pwm #(8) pwm7(.clk(clk0), .wave_length(79), .high_time(10), .out(pwm_out[0]));
   
endmodule
