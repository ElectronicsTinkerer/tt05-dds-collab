`timescale 1ns/100ps
/*
Filename      : Mult.v
Author        : Liam Crowley
Created       : Thu Nov  2 17:03:09 2023
INPUTS        : a
                b
                clk
OUTPUTS       : mult (a*b)
PARAMETERS    : m(width of a and b)

Description   : Parameterized sequential multiplier 
*/
module Mult #(parameter m = 12) (/*AUTOARG*/
   // Outputs
   mult,
   // Inputs
   a, b, clk
   ) ;
   input  [m-1:0] a, b;
   input	  clk;
   //input	  Trig;
   output reg [2*m-1:0]	mult;
   //reg [m:0]	    p;
  // reg		    mult;
   reg [$clog2(m)-1:0]	cnt;
   reg [2*m-1:0]	pA;
   reg [m:0]		sum;
   initial begin 
      cnt = 0;
      pA = 0;
      sum = 0;
   end
   always @(posedge clk)
     begin
	if(cnt==m[$clog2(m)-1:0])
	  begin
	     cnt<=0;
	     pA<={{(m){1'b0}},a};
	  end
	else begin
	   if(pA[0]) begin
	      sum<=pA[2*m-1:m]+b;
	      pA<={sum,pA[m-1:1]}>>1;
	      
	   end
	   else pA<=pA>>1;
	   cnt <= cnt+1;
	end
     end
   always @ (pA) begin
      mult = pA[2*m-1:0];
   end
   
   
endmodule // Mult
