`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10/23/2023 04:54:43 PM
Clk divition for Phase Accumulator clk
INPUTS: Clk
OUTPUTS: Divided clk

Divides main 50MHz clock by 18 for phase accumulator to give overhead for parallel to serial conversion
*/

///DIVIDES 50MHz primary clock by 14 to give time for serialization w/ 2 clock cycles overhead
//NEEDS DIV 18 NOT 14
module div14
    (
    input clkI,
    output reg clkO=0
    );
    reg [3:0] i = 0; 
    always @(posedge clkI)
    begin
        if(i<=7)
        begin 
            clkO=1;
        end
        else if(i<14)
            clkO=0;
        else i = 0;
        i=i+1;
    end
            
endmodule
