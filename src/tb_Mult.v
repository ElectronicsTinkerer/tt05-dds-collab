`timescale 1ns/100ps
/*
Filename      : tb_Mult.v
Author        : Liam Crowley
Created       : Thu Nov  2 18:42:04 2023
INPUTS        : 
OUTPUTS       : 
PARAMETERS    : 

Description   : Testbench for the multiplier module.
*/
module tb_Mult (/*AUTOARG*/) ;
   reg   clk;
   reg [7:0] a, b;
   wire [15:0] M;
   Mult #(.m(8)) UUT(.clk(clk),.a(a),.b(b),.mult(M));
   initial begin
      clk = 0;
      a = 8'haa;
//12'b101;
      b = 8'haa;
      forever #10 clk=~clk;
   end
   
endmodule // tb_Mult
