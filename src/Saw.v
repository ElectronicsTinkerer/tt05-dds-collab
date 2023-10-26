`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2023 12:57:30 PM
// Design Name: 
// Module Name: Saw
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


module saw#
    (
    parameter n = 14
    )
    (
    input [n-1:0] phase,
    output wire [n-3:0] outp
    );
    assign outp = phase[n-1:2];
endmodule
