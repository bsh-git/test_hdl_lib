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


`define TEST_PWM

module knight_test #
    (
     parameter integer N_LEDS = 8,
     parameter integer DIV = 16000000 - 1
     )
    (
     input               clk_in,
     input               speed,
     output [N_LEDS-1:0] led
     );

    wire                 clk;
    wire [23:0]          div;


`ifndef TEST_PWM
    assign div = speed  ? DIV >> 1 : DIV;

    divider #(24) divider(.clk_in(clk_in), .clk_out(clk), .load(div));

    knight #(N_LEDS) knight(.clk_in(clk), .led(led));
`else

    (* mark_debug = "TRUE" *) wire  pwmclk, dbgclk, waveclk;

    divider #(16) divdbg(.clk_in(clk_in), .load(2000-1), .clk_out(dbgclk));
    divider #(16) div0(.clk_in(clk_in), .load(8000-1), .clk_out(pwmclk));
    divider #(8) div1(.clk_in(pwmclk), .load(40-1), .clk_out(waveclk));

    knight_pwm #(N_LEDS) knight(.pwm_clk(pwmclk), .mod_clk(waveclk), .led(led));

`endif

endmodule
