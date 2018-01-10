`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2018/01/08 23:01:06
// Design Name: 
// Module Name: knight_test
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


module divider_test
   (
    input 	 clk_in,
    output [7:0] led
    );

   (* mark_debug = "TRUE" *) wire 	       clk0;
   (* mark_debug = "TRUE" *) wire 	       clk1;
   (* mark_debug = "TRUE" *) wire 	       clk2;
   (* mark_debug = "TRUE" *) wire 	       clkdbg;


   divider #(20) divdbg(.clk_in(clk_in), .load(20'h7ffff), .clk_out(clkdbg));

   divider #(24) div0(.clk_in(clk_in), .load(24'hffffff), .clk_out(clk0));

   divider #(1) div1(.clk_in(clk0), .load(1'h0), .clk_out(clk1));
   

   divider #(4) div2(.clk_in(clk1), .load(4'b1010), .clk_out(clk2));

   assign led[0] = clk0;
   assign led[1] = clk1;
   assign led[2] = clk2;
   


   (* mark_debug = "TRUE" *) wire pwm0_out;
   (* mark_debug = "TRUE" *) wire pwm1_out;
   (* mark_debug = "TRUE" *) wire pwm2_out;
   
   pwd #(16) pwm0(.clk(clk0), .wave_length(15), .high_time(10), .out(pwm0_out));

   // always high
   pwd #(8) pwm1(.clk(clk0), .wave_length(2), .high_time(3), .out(pwm1_out));
   // always low
   pwd #(8) pwm2(.clk(clk0), .wave_length(2), .high_time(0), .out(pwm2_out));

   assign led[3] = pwm0_out;
   assign led[4] = pwm1_out;
   assign led[5] = pwm2_out;

   pwd #(16) pwm3(.clk(clk_in), .wave_length(512), .high_time(256), .out(led[6]));
   pwd #(16) pwm4(.clk(clk_in), .wave_length(512), .high_time(450), .out(led[7]));
   


endmodule
