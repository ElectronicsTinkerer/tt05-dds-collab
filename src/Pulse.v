`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2023 12:57:30 PM
// Design Name: 
// Module Name: Pulse
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


module Pulse
    #(
    parameter n=14,
    parameter m=12
    )
    (
    input [n-1:0] phase,
    output wire [m-1:0] pulse
    );
    assign pulse = {m{phase[n-1]}};
endmodule
