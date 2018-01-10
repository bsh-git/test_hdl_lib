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


module knight_test #
  (
   parameter integer WIDTH = 8,
   parameter integer DIV = 24'hffffff
   )
   (
    input 	       clk_in,
    input 	       speed, 
    output [WIDTH-1:0] led
    );

   wire 	       clk;
   wire [23:0] 	       div;


   assign div = speed  ? DIV >> 1 : DIV;

   divider #(24) divider(.clk_in(clk_in), .clk_out(clk), .load(div));
   
   knight #(WIDTH) knight(.clk_in(clk), .led(led));
   

endmodule
