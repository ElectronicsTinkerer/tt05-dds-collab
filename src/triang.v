`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/22/2023 12:55:55 PM
// Design Name: 
// Module Name: triang
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

//little bit of trickery with replication and xor
//  takes largest bit and replicates it m times, then uses that xor(0,x)=x and xor(1,x)=~x
module triang
    #(
    parameter n=14,
    parameter m=12
    )
    (
    input [n-1:0] phase,
    output wire [m-1:0] triag
    );
    assign triag = {m{phase[n-1]}}^phase[n-2:1];
endmodule
