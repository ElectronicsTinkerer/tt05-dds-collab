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
   reg [11:0] a, b;
   wire [23:0] M;
   Mult #(.m(12)) UUT(.clk(clk),.a(a),.b(b),.mult(M));
   initial begin
      clk = 0;
      a = 12'haaa;
//12'b101;
      b = 12'haaa;
      forever #10 clk=~clk;
   end
   
endmodule // tb_Mult
