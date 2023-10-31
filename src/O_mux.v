`timescale 1ns/100ps
/*
Filename      : O_mux.v
Author        : Liam Crowley
Created       : Tue Oct 31 10:28:23 2023
INPUTS        : in0
                in1
                in2
                in3 
OUTPUTS       : out
PARAMETERS    : m

Description   : Output mux for testing multiple voices
*/

module O_mux 
#(
  parameter m = 12
  )
  (/*AUTOARG*/
   // Outputs
   out,
   // Inputs
   in0, in1, in2, in3, sel
   ) ;
   input  [m-1:0] in0, in1, in2, in3;
   output reg [m-1:0] out;
   input  [1:0] sel;
   always @ (*) begin
      case (sel) 
	2'b00: begin
	   out = in0;
	end
	2'b01: begin
	   out = in1;
	end
	2'b10: begin
	   out = in2;
	end
	2'b11: begin
	   out = in3;
	end
	default: begin
	   out = in0;
	end
      endcase
	  
   end
   
endmodule // O_mux
