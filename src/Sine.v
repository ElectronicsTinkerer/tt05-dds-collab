`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2023 12:57:30 PM
// Design Name: 
// Module Name: SIne
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


module Sine
    #(
    parameter n = 14,
    parameter m = 12,
    //integer rad = ((2**n)/4)-1,
    integer rad = 127,
    integer mag = (2**m)-1
    )
    (
    input [n-1:0] phase,
    output reg [m-1:0] sine
    );
    reg [m-1:0] lut[0:rad];
    initial begin
    /////2^13 size, not 13        
        $readmemh("sin_table.mem",lut);
    end
    always @(phase)
    begin
    //probably better way to do this but i haven't thought of it yet
    //case of top 2 bits
        if(~phase[n-2]&&~phase[n-1])
            sine <= lut[phase[n-3:n-9]];
        else if (phase[n-2]&&~phase[n-1])
            sine <= lut[~phase[n-3:n-9]];
        else if (~phase[n-2]&&phase[n-1])
            sine <= mag-lut[phase[n-3:n-9]];
        else if (phase[n-2]&&phase[n-1])
            sine <= {mag,-lut[~phase[n-3:n-9]]};
    end    

endmodule

