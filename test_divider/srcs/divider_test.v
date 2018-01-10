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


   fixed_divider #(24'hffffff, 24) div0(.clk_in(clk_in), .clk_out(clk0));

   fixed_divider #(1'h0, 1) div1(.clk_in(clk0), .clk_out(clk1));
   

   fixed_divider #(4'b1010, 4) div2(.clk_in(clk1), .clk_out(clk2));

   assign led[0] = clk0;
   assign led[1] = clk1;
   assign led[2] = clk2;
   

   wire [15:0] 	 ltime = 5;
   wire [15:0] 	 htime = 10;
   
   (* mark_debug = "TRUE" *) wire pwm0_out;
   

   pwd #(16) pwm0(.clk(clk0), .low_time(ltime), .high_time(htime), .out(pwm0_out));

   assign led[3] = pwm0_out;
   

   
   pwd #(16) pwm1(.clk(clk_in), .low_time(16'hf00), .high_time(16'h100), .out(led[4]));

   pwd #(16) pwm2(.clk(clk_in), .low_time(16'h100), .high_time(16'hf00), .out(led[5]));
   


endmodule
