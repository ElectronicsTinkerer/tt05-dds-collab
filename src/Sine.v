`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/18/2023 12:57:30 PM
Sine Wave Output for DDS Algorith
INPUTS: Phase value
OUTPUTS: Sine wave output
PARAMETERS: Input width
            Output width
            Radix of memory
            Max magnitude of sine wave

Initializes LUT for quarter sine wave then replicates for other values
*/


module Sine
    #(
    parameter n = 14,
    parameter m = 12,
    //integer rad = ((2**n)/4)-1,
    localparam rad = 127,
    localparam mag = (2**m)-1
    )
    (
    input [n-1:0] phase,
    output reg [m-1:0] sine
    );
    reg [m-1:0] lut[0:rad];
    initial begin
    /////2^13 size, not 13        
       // $readmemh("//wsl.localhost/Ubuntu/home/lsc57/tt05-dds-collab/src/sin_table.mem",lut);
       $readmemh("./sin_table.mem",lut);
       
    end
    always @(phase or lut)
    begin
    //probably better way to do this but i haven't thought of it yet
    //case of top 2 bit
       /*
	* 
        if(~phase[n-2]&&~phase[n-1])
            sine = lut[phase[n-3:n-9]];
        else if (phase[n-2]&&~phase[n-1])
            sine = lut[~phase[n-3:n-9]];
        else if (~phase[n-2]&&phase[n-1])
            sine = mag-lut[phase[n-3:n-9]];
        else if (phase[n-2]&&phase[n-1])
            sine = {mag,-lut[~phase[n-3:n-9]]};
    
	*/
       // Use $clog2(rad) instead of -9
       //Vivado likes ranges to be bound by constant expressions
   	case(phase[n-1:n-2])
	   	2'b00: sine = lut[phase[n-3:n-9]];
	   	2'b01: sine = lut[~phase[n-3:n-9]];
	  	2'b10: sine = ~lut[phase[n-3:n-9]];
	   	2'b11: sine = ~lut[~phase[n-3:n-9]];
  	endcase
    end    

endmodule

