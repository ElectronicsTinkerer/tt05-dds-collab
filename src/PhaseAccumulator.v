`timescale 1ns / 1ps
/**
Author: Liam Crowley
Date: 10-26-23

Phase Accumulator For the DDS algorithm
INPUTS: tuning word
        clk
OUTPUTS: phase register value (Truncated from primary phase register)

phase registere is large for added precision, ideally achieves about 1/3 Hz precision, from 1/3 Hz to ~22kHz

*/

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
