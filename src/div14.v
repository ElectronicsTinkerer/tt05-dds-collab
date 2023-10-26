`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/23/2023 04:54:43 PM
// Design Name: 
// Module Name: div14
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
