`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/18/2023 01:25:28 PM
// Design Name: 
// Module Name: Phase Accumulator
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


////MATH SAYS THAT for ~0-20kHz range, at 50/14 MHz, tune needs to be 17 bits
////OR n=21

module PhaseAccumulator
    #(
    parameter n = 23,
    parameter m = 14,
    parameter tune = 16
    )
    (
    input [tune-1:0] tuning,
    input clk,
    output wire [m-1:0] phaseReg
    );
    reg [n-1:0] phase;
    initial phase = 1;
    always @(posedge clk) 
    begin
        phase = phase + tuning;
    end
    assign phaseReg = phase[n-1:n-1-m];
endmodule
